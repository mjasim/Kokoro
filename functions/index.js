/* eslint-disable */

const functions = require('firebase-functions');
const admin = require('firebase-admin');

var app = admin.initializeApp();

let axios;

const googleLocationApiKey = 'AIzaSyB4vwPM5fwg6M-LUoo6mqbflDtDNXodOKs';
const db = admin.firestore();


exports.updatePlanetOnPostCreated = functions.firestore
    .document('posts/{docId}')
    .onCreate((snapshot, context) => {
        console.log(`Document created ${JSON.stringify(snapshot.data())["planets"]}, ${context}`);
        console.log(`Planets: ${snapshot.data().planets}`);
        let planets = snapshot.data().planets;
        async function checkIfPlanetExists(planetName) {
            console.log(`checkIfPlanetExists called on ${planetName}`);

            await db.collection('planets').limit(1).where('planetName', '==', planetName).get().then((querySnapshot) => {
                if (querySnapshot.empty) {
                    console.log(`querySnapshot empty`);
                    db.collection('planets').doc().set({
                        'planetName': planetName,
                        'dateCreated': admin.firestore.FieldValue.serverTimestamp(),
                        'numberOfPosts': 1,
                    }).catch((error) => console.log(error));
                } else {
                    let doc = querySnapshot.docs[0];
                    db.collection('planets').doc(doc.id).update({
                        'numberOfPosts': admin.firestore.FieldValue.increment(1),
                    }).catch((error) => console.log(error));
                }
            }).catch((error) => console.log(error));


            console.log(`checkIfPlanetUserExsits called on ${planetName} and ${snapshot.data().authorUid}`);
            await db.collection('planetUserCount').limit(1)
                .where('planetName', '==', planetName)
                .where('userUid', '==', snapshot.data().authorUid)
                .get()
                .then((querySnapshot) => {
                    if (querySnapshot.empty) {
                        console.log(`querySnapshot empty planet-user-count`);
                        db.collection('planetUserCount').doc().set({
                            'planetName': planetName,
                            'userUid': snapshot.data().authorUid,
                            'dateCreated': admin.firestore.FieldValue.serverTimestamp(),
                            'lastPosted': admin.firestore.FieldValue.serverTimestamp(),
                            'numberOfPosts': 1,
                        }).catch((error) => console.log(error));
                    } else {
                        let doc = querySnapshot.docs[0];
                        db.collection('planetUserCount').doc(doc.id).update({
                            'numberOfPosts': admin.firestore.FieldValue.increment(1),
                            'lastPosted': admin.firestore.FieldValue.serverTimestamp(),
                        }).catch((error) => console.log(error));
                    }
                }).catch((error) => console.log(error));
        }
        planets.forEach((planetName) => checkIfPlanetExists(String(planetName)).catch((e) => console.log(e)));

        return null;
    });

/*
This function updates the location count for the country and city when a user creates
an account. This function is called when ever a new account is made.
*/
exports.updateLocationsOnCreateUser = functions.firestore
    .document('users/{docId}')
    .onCreate(async (snapshot, context) => {
        let location = snapshot.data().location;
        console.log(`update Locations On Create User ${JSON.stringify(location)}, ${location.countryLatLng.placeId}`);

        /* 
            Checks to see if a document exists in the [countryUserCount] collection for this countries placeId.
            If no document exists one is created otherwise the count is incrimented by one.
        */
        return await db.collection('countryUserCount').doc(location.countryLatLng.placeId).get().then(async (documentSnapshot) => {
            console.log('Inside get document');
            if (!documentSnapshot.exists) {
                console.log(`documentSnapshot empty`);
                await db.collection('countryUserCount').doc(location.countryLatLng.placeId).set({
                    'countryName': location.country,
                    'lat': location.countryLatLng.lat,
                    'lng': location.countryLatLng.lng,
                    'numberOfUsers': 1,
                }).catch((error) => console.log(`${error}`));
            } else {
                console.log(`documentSnapshot does exist ${documentSnapshot.data()}`);
                await db.collection('countryUserCount').doc(location.countryLatLng.placeId).update({
                    'numberOfUsers': admin.firestore.FieldValue.increment(1),
                }).catch((error) => console.log(error));
            }
        }).then(async () => {
            /*
                Once the country document is made, checks to see if the city placeId is in the subcollection [cityUserCounts].
                If it is incriments the count by one otherwise creates it and sets its count to 1.
            */
            return await db.collection('countryUserCount')
                .doc(location.countryLatLng.placeId)
                .collection('cityUserCounts')
                .doc(location.placeId)
                .get().then(async (documentSnapshot) => {
                    if (!documentSnapshot.exists) {
                        console.log(`documentSnapshot empty cityUserCounts`);
                        return await db.collection('countryUserCount')
                            .doc(location.countryLatLng.placeId)
                            .collection('cityUserCounts')
                            .doc(location.placeId).set({
                                'cityName': location.cityName,
                                'lat': location.cityLatLng.lat,
                                'lng': location.cityLatLng.lng,
                                'numberOfUsers': 1,
                            }).then(() => null).catch((error) => console.log(error));
                    } else {
                        return await db.collection('countryUserCount')
                            .doc(location.countryLatLng.placeId)
                            .collection('cityUserCounts')
                            .doc(location.placeId).update({
                                'numberOfUsers': admin.firestore.FieldValue.increment(1),
                            }).then(() => null).catch((error) => console.log(error));
                    }
                }).catch((error) => console.log(error));
        }).catch((error) => console.log(error));
    });



exports.createGlobalViewData = functions.firestore
    .document('countryUserCount/{docId}')
    .onCreate(async (snapshot, context) => {
        console.log(`createGlobalViewData called`);
        function getDataForCollection(collection) {
            let totalNumberOfUsersInCollection = 0;
            let placesInCollectionData = new Array();
            collection.forEach(element => {
                let data = element.data();
                totalNumberOfUsersInCollection += data.numberOfUsers;
                data['placeId'] = element.id;
                placesInCollectionData.push(data);
            });

            placesInCollectionData.map((element) => {
                let newElement = element;
                newElement['normalizedUserCount'] = newElement.numberOfUsers / totalNumberOfUsersInCollection;
            });

            return placesInCollectionData;
        }

        async function uploadToGlobalViewCollection(key, data) {
            return await db.collection('globalViewData').doc(key).set({
                'data': data,
            });
        }

        async function getUserDataForCity(cityPlaceId) {
            return db.collection('users').where('location.placeId', '==', cityPlaceId).limit(20).get().then((querySnapshot) => {
                let userDataForCity = querySnapshot.docs.map((element) => element.data());
                console.log(`getUserDataForCity ${JSON.stringify(userDataForCity)}`);
                return db.collection('globalViewData').doc(cityPlaceId).set({
                    'data': userDataForCity,
                });
            })
        }

        let countryData = new Array();
        await db.collection('globalViewData').get()
            .then(() => db.collection('countryUserCount').get())
            .then(async res => {
                countryData = getDataForCollection(res);
                console.log(countryData);
                for (let i = 0; i < countryData.length; i++) {
                    let element = countryData[i];
                    await db.collection('countryUserCount').doc(element.placeId).collection('cityUserCounts').get().then(async (res) => {
                        let cityData = getDataForCollection(res);
                        for (let j = 0; j < cityData.length; j++) {
                            let currCityData = cityData[j];
                            await getUserDataForCity(currCityData.placeId);
                        }
                        console.log(`country Data for each ${JSON.stringify(element)}, city data ${JSON.stringify(cityData)}`);
                        return uploadToGlobalViewCollection(element.placeId, cityData);
                    });
                }
                return await uploadToGlobalViewCollection('world', countryData).then(() => null);
            }).catch((error) => console.log(error));


    });


exports.storeHistoricPlanetSize = functions.firestore
    .document('planets/{docId}')
    .onWrite((snapshot, context) => {
        return db.collection('planets').get()
            .then(async res => {
                let planetInfo = res.docs.map(element => element.data());
                console.log(`planetInfo ${JSON.stringify(planetInfo)}`);
                for (let i = 0; i < planetInfo.length; i++) {
                    await db.collection('historicPlanetSize').doc().set({
                        'date': admin.firestore.FieldValue.serverTimestamp(),
                        'planetName': planetInfo[i].planetName,
                        'numberOfPosts': planetInfo[i].numberOfPosts,
                    });
                }
                return null;
            }).catch((error) => console.log(error));
    });

exports.updatePlanetRanking = functions.firestore
    .document('planets/{docId}')
    .onWrite((snapshot, context) => {
        return db.collection('topPlanets').get()
            .then(res => {
                res.forEach(element => {
                    element.ref.delete();
                });
            }).then(async () => db.collection('planets').limit(10).orderBy('numberOfPosts', 'desc').get().then(async (querySnapshot) => {
                if (!querySnapshot.empty) {
                    let docs = querySnapshot.docs;
                    for (let i = 0; i < docs.length; i++) {
                        let doc = docs[i];
                        let data = doc.data();
                        console.log(`Doc ${JSON.stringify(data)}`);
                        console.log(`Got planet: ${data.planetName}`);
                        let topContributors = [];
                        await db.collection('planetUserCount').limit(10)
                            .where('planetName', '==', data.planetName)
                            .orderBy('numberOfPosts', 'desc')
                            .get().then(async (topContributorData) => {
                                for (let j = 0; j < topContributorData.docs.length; j++) {
                                    let _data = topContributorData.docs[j].data();
                                    console.log(`topContributorData ${JSON.stringify(_data)}`);
                                    await db.collection('users').doc(_data.userUid).get().then((userInfo) => {
                                        if (userInfo.exists) {
                                            userInfo = userInfo.data();
                                            userInfo['numberOfPosts'] = _data['numberOfPosts'];
                                            userInfo['userUid'] = _data.userUid;
                                            topContributors.push(userInfo);
                                        }
                                    });
                                }
                            }).then(async () => {
                                for (let j = 0; j < topContributors.length; j++) {
                                    let currContributor = topContributors[j];
                                    // console.log(`currContributor ${JSON.stringify(currContributor)}, ${currContributor.userUid}, ${data.planetName}`);
                                    await db.collection('posts').limit(10)
                                        .where('authorUid', '==', currContributor.userUid)
                                        .where('planets', 'array-contains', data.planetName)
                                        .orderBy('dateCreated', 'desc').get().then((querySnapshotPosts) => {
                                            if (!querySnapshotPosts.empty) {
                                                let postStore = new Map();
                                                querySnapshotPosts.forEach((element) => {
                                                    let postData = element.data();
                                                    if (postData.contentType === null) {
                                                        if (postStore.has('text')) {
                                                            postStore['text'].push(element.id);
                                                        } else {
                                                            postStore['text'] = [element.id];
                                                        }
                                                    } else if (postData.contentType === 'video') {
                                                        if (postStore.has('video')) {
                                                            postStore['video'].push(element.id);
                                                        } else {
                                                            postStore['video'] = [element.id];
                                                        }
                                                    } else if (postData.contentType === 'image') {
                                                        if (postStore.has('image')) {
                                                            postStore['image'].push(element.id);
                                                        } else {
                                                            postStore['image'] = [element.id];
                                                        }
                                                    }
                                                    // console.log(`posts ${element.data()}`);
                                                });
                                                currContributor['posts'] = JSON.parse(JSON.stringify(postStore));
                                            }
                                        });
                                }
                            }).catch((error) => console.log(error));

                        // console.log(`topContributors ${JSON.stringify(topContributors)}`);
                        db.collection('topPlanets').doc(doc.id).set({
                            'planetName': data.planetName,
                            'dateCreated': data.dateCreated,
                            'numberOfPosts': data.numberOfPosts,
                            'topContributors': topContributors,
                        }).catch((error) => console.log(error));
                    }

                    console.log(`querySnapshot not empty`);
                    return null;
                }
            }).catch((e) => console.log(e))).catch((e) => console.log(e));
    });


exports.getPersonalMapData = functions.https.onCall(async (data, context) => {
    let startDate = data.startDate;
    let stopDate = data.stopDate;

    let userUid = data.userUid;

    async function getUserInfo(uid) {
        return await db.collection('users').doc(uid).get().then((userInfo) => {
            if (userInfo.exists) {
                let userData = userInfo.data();
                userData['uid'] = userInfo.id;
                return userData;
            } else {
                return null;
            }
        }).catch((e) => console.log(e));
    }

    let incoming = new Map();
    let outgoing = new Map();

    let userInfoStore = new Map();
    let locationInfoStore = new Map();

    function addToMap(userInfo, map) {
        let placeId = userInfo.location.placeId;
        if (placeId in map) {
            if (userInfo['uid'] in map[placeId]) {
                map[placeId][userInfo['uid']] += 1;
            } else {
                userInfoStore[userInfo['uid']] = userInfo;
                map[placeId][userInfo['uid']] = 1;
            }
        } else {
            locationInfoStore[placeId] = userInfo.location;
            map[placeId] = new Map();
            userInfoStore[userInfo['uid']] = userInfo;
            map[placeId][userInfo['uid']] = 1;
        }
    }

    async function collectionDataForTimeWindow(collection, isComments = false) {
        let userInfoArray = new Array();
        console.log(`collectionDataForTimeWindow ${new Date(...(startDate.split('-').reverse()))}, ${new Date(...(stopDate.split('-').reverse()))}, ${userUid}`);
        collection.where('dateCreated', '>=', new Date(...(startDate.split('-').reverse())))
            .where('dateCreated', '<', new Date(...(stopDate.split('-').reverse())))
            .where('postAuthorUid', '==', userUid).get()
            .then(async (querySnapshot) => {
                console.log(`querySnapshot ${querySnapshot.docs.length}`);
                for (let i = 0; i < querySnapshot.docs.length; i++) {
                    let _data = querySnapshot.docs[i].data();
                    console.log(`_data has ${'reactorUid' in _data}`);
                    if ('reactorUid' in _data) {
                        let userInfo = await getUserInfo(_data.reactorUid).catch((e) => console.log(e));
                        addToMap(userInfo, incoming);
                    } else if ('authorUid' in _data) {
                        console.log(`authorUid in data`);
                        let userInfo = await getUserInfo(_data.authorUidUid).catch((e) => console.log(e));
                        addToMap(userInfo, incoming);
                    }
                }
                console.log(`getPersonalMapData userInfoArray ${JSON.stringify(incoming)}`);
            }).catch((e) => console.log(e));

        let searchBy = 'reactorUid';
        if (isComments) {
            searchBy = 'authorUid';
        }


        return collection.where('dateCreated', '>=', new Date(...(startDate.split('-').reverse())))
            .where('dateCreated', '<', new Date(...(stopDate.split('-').reverse())))
            .where(searchBy, '==', userUid).get()
            .then(async (querySnapshot) => {
                console.log(`querySnapshot ${querySnapshot.docs.length}`);
                for (let i = 0; i < querySnapshot.docs.length; i++) {
                    let _data = querySnapshot.docs[i].data();
                    console.log(`_data has ${'reactorUid' in _data}`);
                    let userInfo = await getUserInfo(_data.postAuthorUid).catch((e) => console.log(e));
                    addToMap(userInfo, outgoing);
                }
                console.log(`getPersonalMapData outgoing ${JSON.stringify(outgoing)}`);
            }).catch((e) => console.log(e));
    }

    await collectionDataForTimeWindow(db.collection('comments'), true);
    await collectionDataForTimeWindow(db.collection('color-reactions'));
    await collectionDataForTimeWindow(db.collection('slider-reactions'));

    console.log(`getPersonalMapData ${JSON.stringify(data)}`);

    return { 'userInfo': userInfoStore, 'incoming': incoming, 'outgoing': outgoing, 'locationInfo': locationInfoStore, };
});


exports.googleLocationAutoFill = functions.https.onCall(async (data, context) => {
    axios = require('axios');

    let url = `https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${data.queryText}&types=(cities)&key=${googleLocationApiKey}`;

    return axios.get(url).then((response) => {
        console.log(`Returned data ${JSON.stringify(response.data)}`);
        return JSON.stringify(response.data);
    }).catch((e) => {
        console.log(e);
        return null;
    });
});


exports.latLngFromPlaceId = functions.https.onCall(async (data, context) => {
    return await db.collection('locationLatLngCache').limit(1).where('placeId', '==', data.placeId).get().then(async (querySnapshot) => {
        if (querySnapshot.empty) {
            axios = require('axios');

            let url = `https://maps.googleapis.com/maps/api/place/details/json?placeid=${data.placeId}&key=${googleLocationApiKey}`;

            return axios.get(url).then((response) => {
                console.log(`Returned data ${JSON.stringify(response.data)}`);
                let responseData = response.data;
                let lat = responseData.result.geometry.location.lat;
                let lng = responseData.result.geometry.location.lng;
                console.log(`Response data lat long ${JSON.stringify()}`);
                db.collection('locationLatLngCache').doc().set({
                    'placeId': data.placeId,
                    'name': responseData.result.address_components[0].long_name,
                    'location': new admin.firestore.GeoPoint(lat, lng),
                }).catch((error) => console.log(error));
                return JSON.stringify({
                    'lat': lat,
                    'lng': lng,
                });
            }).catch((e) => {
                console.log(e);
                return null;
            });
        } else {
            let doc = querySnapshot.docs[0];
            let dbData = doc.data();
            console.log(`Document did exist ${JSON.stringify(dbData)} placeId ${doc.placeId}`);
            return JSON.stringify({
                'lat': dbData.location._latitude,
                'lng': dbData.location._longitude,
            });
        }
    }).catch((error) => {
        console.log(error);
        return error;
    });
});


exports.latLngFromName = functions.https.onCall(async (data, context) => {
    return await db.collection('locationLatLngCache').limit(1).where('name', '==', data.name).get().then(async (querySnapshot) => {
        if (querySnapshot.empty) {
            axios = require('axios');

            let url = `https://maps.googleapis.com/maps/api/place/textsearch/json?query=${data.name}&key=${googleLocationApiKey}`

            return axios.get(url).then((response) => {
                console.log(`Returned data ${JSON.stringify(response.data)}`);

                let responseData = response.data;
                let lat = responseData.results[0].geometry.location.lat;
                let lng = responseData.results[0].geometry.location.lng;
                console.log(`latLngFromName ${data.name} responseData ${responseData.results[0].place_id}`);
                db.collection('locationLatLngCache').doc().set({
                    'placeId': responseData.results[0].place_id,
                    'name': data.name,
                    'location': new admin.firestore.GeoPoint(lat, lng),
                }).catch((error) => console.log(error));
                return JSON.stringify({
                    'lat': lat,
                    'lng': lng,
                    'placeId': responseData.results[0].place_id,
                });
            }).catch((e) => {
                console.log(e);
                return null;
            });
        } else {
            let doc = querySnapshot.docs[0];
            let dbData = doc.data();
            console.log(`Document did exist ${JSON.stringify(dbData)} placeId ${doc.placeId}`);
            return JSON.stringify({
                'lat': dbData.location._latitude,
                'lng': dbData.location._longitude,
                'placeId': dbData.placeId,
            });
        }
    }).catch((error) => {
        console.log(error);
        return error;
    });
});