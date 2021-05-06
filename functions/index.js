const functions = require('firebase-functions');
const admin = require('firebase-admin');

var app = admin.initializeApp();
var axios;

const googleLocationApiKey = 'AIzaSyB4vwPM5fwg6M-LUoo6mqbflDtDNXodOKs';
const db = admin.firestore();

exports.updatePlanetOnPostCreated = functions.firestore
    .document('posts/{docId}')
    .onCreate((snapshot, context) => {
        console.log(`Document created ${JSON.stringify(snapshot.data())["planets"]}, ${context}`);
        console.log(`Planets: ${snapshot.data().planets}`);
        var planets = snapshot.data().planets;
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


exports.updatePlanetRanking = functions.firestore
    .document('planets/{docId}')
    .onWrite((snapshot, context) => {
        db.collection('topPlanets').get()
            .then(res => {
                res.forEach(element => {
                    element.ref.delete();
                });
            }).then(async () => db.collection('planets').limit(10).orderBy('numberOfPosts', 'desc').get().then(async (querySnapshot) => {
                if (!querySnapshot.empty) {
                    var docs = querySnapshot.docs;
                    for (var i = 0; i < docs.length; i++) {

                        var doc = docs[i];
                        var data = doc.data();
                        console.log(`Doc ${JSON.stringify(data)}`);
                        console.log(`Got planet: ${data.planetName}`);
                        var topContributorData = await db.collection('planetUserCount').limit(10)
                            .where('planetName', '==', data.planetName)
                            .orderBy('numberOfPosts', 'desc')
                            .get().catch((error) => console.log(error));

                        var topContributors = [];
                        for (var j = 0; j < docs.length; j++) {
                            var _data = topContributorData.docs[j].data();
                            console.log(`topContributorData ${JSON.stringify(_data)}`);
                            var userInfo = await db.collection('users').doc(_data.userUid).get();
                            userInfo = userInfo.data();
                            userInfo['numberOfPosts'] = _data['numberOfPosts'];
                            topContributors.push(userInfo);
                        }

                        console.log(`topContributors ${JSON.stringify(topContributors)}`);
                        db.collection('topPlanets').doc(doc.id).set({
                            'planetName': data.planetName,
                            'dateCreated': data.dateCreated,
                            'numberOfPosts': data.numberOfPosts,
                            'topContributors': topContributors,
                        }).catch((error) => console.log(error));
                    }
                    console.log(`querySnapshot empty`);
                }
            }).catch((e) => console.log(e))).catch((e) => console.log(e));

        return null;
    });


exports.googleLocationAutoFill = functions.https.onCall(async (data, context) => {
    axios = require('axios');

    var url = `https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${data.queryText}&types=(cities)&key=${googleLocationApiKey}`;

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

            var url = `https://maps.googleapis.com/maps/api/place/details/json?placeid=${data.placeId}&key=${googleLocationApiKey}`;

            return axios.get(url).then((response) => {
                console.log(`Returned data ${JSON.stringify(response.data)}`);
                var responseData = response.data;
                var lat = responseData.result.geometry.location.lat;
                var lng = responseData.result.geometry.location.lng;
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

            var url = `https://maps.googleapis.com/maps/api/place/textsearch/json?query=${data.name}&key=${googleLocationApiKey}`

            return axios.get(url).then((response) => {
                console.log(`Returned data ${JSON.stringify(response.data)}`);

                var responseData = response.data;
                var lat = responseData.results[0].geometry.location.lat;
                var lng = responseData.results[0].geometry.location.lng;
                console.log(`latLngFromName ${data.name} responseData ${responseData.results[0].place_id}`);
                db.collection('locationLatLngCache').doc().set({
                    'placeId': responseData.results[0].place_id,
                    'name': data.name,
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