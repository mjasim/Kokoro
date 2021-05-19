/* eslint-disable */

const functions = require('firebase-functions');
const admin = require('firebase-admin');

var app = admin.initializeApp();

let sw;
let axios;
let tsnejs;

const googleLocationApiKey = 'AIzaSyB4vwPM5fwg6M-LUoo6mqbflDtDNXodOKs';
const db = admin.firestore();
const storage = admin.storage();


exports.updatePlanetOnPostCreated = functions.firestore
    .document('posts/{docId}')
    .onCreate(async (snapshot, context) => {
        sw = require('stopword');

        console.log(`Document created ${JSON.stringify(snapshot.data())["planets"]}, ${context}`);
        console.log(`Planets: ${snapshot.data().planets}`);
        let planets = snapshot.data().planets;
        let postText = snapshot.data().postText;
        let stopwordPostText = sw.removeStopwords(postText.replace(/[.,\/#!$%\^&\*;:{}=\-_`~()]/g, "").toLowerCase().split(' '));

        function addArrayToMap(map, wordArray) {
            wordArray.forEach((word) => {
                if (word in map) {
                    map[word] += 1;
                } else {
                    map[word] = 1;
                }
            });
            return map;
        }

        async function checkIfPlanetExists(planetName) {
            console.log(`checkIfPlanetExists called on ${planetName}`);
            await db.collection('planets').limit(1).where('planetName', '==', planetName).get().then(async (querySnapshot) => {
                console.log(`stopwordPostText ${stopwordPostText}, addArrayToMap value ${JSON.stringify(addArrayToMap(new Map(), stopwordPostText))}`);
                if (querySnapshot.empty) {
                    console.log(`querySnapshot empty`);
                    let documentReference = db.collection('planets').doc()

                    await documentReference.set({
                        'planetName': planetName,
                        'dateCreated': admin.firestore.FieldValue.serverTimestamp(),
                        'numberOfPosts': 1,
                    }).catch((error) => console.log(error));

                    return db.collection('planetWordCount').doc(documentReference.id).set({
                        'planetName': planetName,
                        'wordCounts': JSON.stringify(addArrayToMap(new Map(), stopwordPostText)),
                    }).catch((error) => console.log(error));
                } else {
                    let doc = querySnapshot.docs[0];
                    await db.collection('planets').doc(doc.id).update({
                        'numberOfPosts': admin.firestore.FieldValue.increment(1),
                    }).catch((error) => console.log(error));

                    return db.collection('planetWordCount').doc(doc.id).get().then((documentReference) => {
                        console.log(`wordCount planet exists existing data ${documentReference.data().wordCounts}`);
                        let previousWordCount = JSON.parse(documentReference.data().wordCounts);
                        return addArrayToMap(previousWordCount, stopwordPostText);
                    }).then((updatedWordCountMap) => db.collection('planetWordCount').doc(doc.id).set({
                        'planetName': planetName,
                        'wordCounts': JSON.stringify(updatedWordCountMap),
                    })).catch((error) => console.log(error));
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

        async function runForAllPlanets() {
            for (let i = 0; i < planets.length; i++) {
                let planetName = planets[i];
                await checkIfPlanetExists(String(planetName)).catch((e) => console.log(e));
            }
        }
        return await runForAllPlanets();
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

// TODO make this happen every day at midnight
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


exports.makePlanetUsedImagesCollection = functions.https.onCall(async (data, context) => {
    let planetImageBucket = storage.bucket('planet-images');
    return await planetImageBucket.getFiles().then(async (files) => {
        for (let i = 0; i < files.length; i++) {
            let file = files[i];
            let url = file.publicUrl();
            await db.collection('planetUsedImages').doc().set({
                'lastUsed': admin.firestore.FieldValue.serverTimestamp(),
                'photoUrl': url,
            }).catch((error) => console.log(error));;
        }
    }).catch((error) => console.log(error));
});

function termFreqMap(str) {
    var words = str.split(' ');
    var termFreq = {};
    words.forEach(function (w) {
        termFreq[w] = (termFreq[w] || 0) + 1;
    });
    return termFreq;
}

function addKeysToDict(map, dict) {
    for (var key in map) {
        dict[key] = true;
    }
}

function termFreqMapToVector(map, dict) {
    var termFreqVector = [];
    for (var term in dict) {
        termFreqVector.push(map[term] || 0);
    }
    return termFreqVector;
}

function vecDotProduct(vecA, vecB) {
    var product = 0;
    for (var i = 0; i < vecA.length; i++) {
        product += vecA[i] * vecB[i];
    }
    return product;
}

function vecMagnitude(vec) {
    var sum = 0;
    for (var i = 0; i < vec.length; i++) {
        sum += vec[i] * vec[i];
    }
    return Math.sqrt(sum);
}

function cosineSimilarity(vecA, vecB) {
    return vecDotProduct(vecA, vecB) / (vecMagnitude(vecA) * vecMagnitude(vecB));
}

function textCosineSimilarity(strA, strB) {
    var termFreqA = termFreqMap(strA);
    var termFreqB = termFreqMap(strB);

    var dict = {};
    addKeysToDict(termFreqA, dict);
    addKeysToDict(termFreqB, dict);

    var termFreqVecA = termFreqMapToVector(termFreqA, dict);
    var termFreqVecB = termFreqMapToVector(termFreqB, dict);

    return cosineSimilarity(termFreqVecA, termFreqVecB);
}

// All functions for TSNE
function get_tsne(dists) {
    var opt = {};
    opt.epsilon = 10; // epsilon is learning rate (10 = default)
    opt.perplexity = 30; // roughly how many neighbors each point influences (30 = default)
    opt.dim = 2; // dimensionality of the embedding (2 = default)

    var tsne = new tsnejs.tSNE(opt); // create a tSNE instance

    // initialize data. Here we have 3 points and some example pairwise dissimilarities
    // var dists = [
    //     [1.0, 0.1, 0.2],
    //     [0.1, 1.0, 0.3],
    //     [0.2, 0.1, 1.0],
    // ];
    tsne.initDataDist(dists);

    for (var k = 0; k < 500; k++) {
        tsne.step(); // every time you call this, solution gets better
    }

    var Y = tsne.getSolution(); // Y is an array of 2-D points that you can plot
    return Y;
}

function minShift(list) {
    console.log(list);
    inc_val = Math.abs(Math.min.apply(Math, list));

    for (var i in list) {
        list[i] = list[i] + inc_val;
    }

    return list;
}

function rangeConversion(value, sourceMax, targetMax, sourceMin, targetMin) {
    percent = (value - sourceMin) / (sourceMax - sourceMin);
    output = percent * (targetMax - targetMin) + targetMin;
    return output;
}

function rangeManipulation(tsne) {
    og_xvalues = [];
    og_yvalues = [];

    converted_cordinates = { coordinates: [] };

    for (var i in tsne) {
        og_xvalues.push(tsne[i][0]);
        og_yvalues.push(tsne[i][1]);
    }

    minshifted_X = minShift(og_xvalues);
    minshifted_Y = minShift(og_yvalues);

    sourceMaxX = Math.max.apply(Math, minshifted_X);
    sourceMaxY = Math.max.apply(Math, minshifted_Y);
    targetMaxX = 720;
    targetMaxY = 520;

    sourceMinX = Math.min.apply(Math, minshifted_X);
    sourceMinY = Math.min.apply(Math, minshifted_Y);
    targetMinX = 80;
    targetMinY = 80;

    for (var i = 0; i < minshifted_X.length; i++) {
        c_x = rangeConversion(minshifted_X[i], sourceMaxX, targetMaxX, sourceMinX, targetMinX);
        c_y = rangeConversion(minshifted_Y[i], sourceMaxY, targetMaxY, sourceMinY, targetMinY);
        converted_cordinates.coordinates.push({ x: Math.round(c_x), y: Math.round(c_y) });
    }

    return converted_cordinates;
}

//function to find the index of best dist value in the grid_center_distances
function find_best_distance(value, grid_center_matrix) {
    for (var i = 0; i < grid_center_matrix.length; i++) {
        for (var j = 0; j < grid_center_matrix[i].length; j++) {
            if (grid_center_matrix[i][j] == value) {
                return [i, j];
            }
        }
    }
}

//function for checking if there is an overlap
function check_overlap(circle, non_overlapping_circles) {
    for (var i in non_overlapping_circles) {
        dist_between_circles = parseInt(Math.sqrt((non_overlapping_circles[i]['x'] - circle['x']) ** 2 + (non_overlapping_circles[i]['y'] - circle['y']) ** 2));
        if (dist_between_circles < non_overlapping_circles[i]['r'] + circle['r']) {
            return 'overlap';
        }
    }
    return 'no-overlap';
}

// All functions for collision removal
function removeCollision(initial_circles) {
    screen_height = 600;
    screen_width = 800;
    max_radius = 80;
    min_radius = 30;

    num_rows = parseInt(Math.floor((screen_height - max_radius) / (min_radius / 2)));
    num_columns = parseInt(Math.floor((screen_width - max_radius) / (min_radius / 2)));

    // create grids
    grid = Array.from(Array(num_rows), (_) => Array(num_columns).fill(0));
    grid_centers = Array.from(Array(num_rows), (_) => Array(num_columns).fill(0));

    for (var i = 0; i < num_rows; i++) {
        for (var j = 0; j < num_columns; j++) {
            grid_centers[i][j] = { x: (j * min_radius) / 2 + min_radius / 2, y: (i * min_radius) / 2 + min_radius / 2 };
        }
    }
    console.log(initial_circles);
    console.log(num_rows, num_columns);

    //find initially overlapping circles
    overlapping_circles = [];
    non_overlapping_circles = [];
    cnt = -1;
    for (var i in initial_circles.coordinates) {
        cnt += 1;
        flag = 0;
        for (var j in initial_circles.coordinates) {
            if (initial_circles.coordinates[i]['idx'] == initial_circles.coordinates[j]['idx']) {
                continue;
            }
            dist_between_circles = parseInt(
                Math.sqrt((initial_circles.coordinates[i]['x'] - initial_circles.coordinates[j]['x']) ** 2 + (initial_circles.coordinates[i]['y'] - initial_circles.coordinates[j]['y']) ** 2)
            );
            if (dist_between_circles < initial_circles.coordinates[i]['r'] + initial_circles.coordinates[j]['r']) {
                initial_circles.coordinates[i]['idx'] = cnt;
                flag = 1;

                overlapping_circles.push(initial_circles.coordinates[i]);
                break;
            }
        }
        if (flag == 0) {
            initial_circles.coordinates[i]['idx'] = cnt;
            non_overlapping_circles.push(initial_circles.coordinates[i]);
        }
    }

    console.log(overlapping_circles);
    console.log(non_overlapping_circles);

    for (var i in overlapping_circles) {
        console.log(non_overlapping_circles.length);
        grid_center_dist = Array.from(Array(num_rows), (_) => Array(num_columns).fill(0));
        temp = [];

        // get distance to all grid centers
        for (var j = 0; j < num_rows; j++) {
            for (var k = 0; k < num_columns; k++) {
                dist = parseInt(Math.sqrt((overlapping_circles[i]['x'] - grid_centers[j][k]['x']) ** 2 + (overlapping_circles[i]['y'] - grid_centers[j][k]['y']) ** 2));
                grid_center_dist[j][k] = dist;
                temp.push(dist);
            }
        }

        grid_center_dist_sorted = temp.sort();

        // console.log(grid_center_dist);

        for (var d in grid_center_dist_sorted) {
            best_cell = find_best_distance(grid_center_dist_sorted[d], grid_center_dist);
            // console.log(i, d, best_cell);
            isoverlap = check_overlap(
                { x: grid_centers[best_cell[0]][best_cell[1]]['x'], y: grid_centers[best_cell[0]][best_cell[1]]['y'], r: overlapping_circles[i]['r'] },
                non_overlapping_circles
            );

            if (isoverlap == 'no-overlap') {
                console.log('storing nono circle', best_cell, overlapping_circles[i]['idx']);
                non_overlapping_circles.push({
                    x: parseInt(grid_centers[best_cell[0]][best_cell[1]]['x']),
                    y: parseInt(grid_centers[best_cell[0]][best_cell[1]]['y']),
                    r: parseInt(overlapping_circles[i]['r']),
                    idx: overlapping_circles[i]['idx'],
                });
                break;
            }
        }
    }

    console.log('non-after', non_overlapping_circles);

    for (var i in non_overlapping_circles) {
        for (var j in non_overlapping_circles) {
            dist_between_circles = parseInt(
                Math.sqrt((non_overlapping_circles[i]['x'] - non_overlapping_circles[j]['x']) ** 2 + (non_overlapping_circles[i]['y'] - non_overlapping_circles[j]['y']) ** 2)
            );
            if (dist_between_circles < non_overlapping_circles[i]['r'] + non_overlapping_circles[j]['r']) {
                console.log('overlap', i, j);
            }
        }
    }

    return non_overlapping_circles;
}

function get_new_coordinates(data, radii) {
    strings = [];
    cosim_matrix = [];

    // data = JSON.parse(localStorage.getItem('keywords_data'));
    // radii = JSON.parse(localStorage.getItem('radius_data'));

    for (var i in data) {
        strings.push(data[i].flat().join().replace(/,/g, ' '));
    }

    for (var i in strings) {
        row_cosim = [];
        for (j in strings) {
            row_cosim.push(textCosineSimilarity(strings[i], strings[j]));
        }
        cosim_matrix.push(row_cosim);
    }

    // console.log(cosim_matrix);

    tsne_vals = get_tsne(cosim_matrix);
    initial_coordinates = rangeManipulation(tsne_vals);

    for (var i in initial_coordinates.coordinates) {
        initial_coordinates.coordinates[i].r = rangeConversion(radii[i], Math.max.apply(Math, radii), 80, Math.min.apply(Math, radii), 30);
        initial_coordinates.coordinates[i].idx = i;
    }

    new_circles = removeCollision(initial_coordinates);
    // console.log(initial_coordinates.coordinates);

    return new_circles;
}

// TODO make this happen every day at midnight
exports.updatePlanetRanking = functions.firestore
    .document('planets/{docId}')
    .onWrite((snapshot, context) => {
        tsnejs = require('tsne');
        function getTopWords(map, N = 10) {
            let sortedKeys = Object.keys(map).sort(function (a, b) { return map[b] - map[a] });
            return sortedKeys.slice(0, N);
        }

        let topContributors = [];
        let previousTopPlanetInfo = new Map(); // Stores previous top planet data mostly so the photo remains the same

        // This function gets the document in the [planetUsedImages] collection that has the oldest [lastUsed] date
        // The purpose is to get a planet photo that is least close to any of the last used ones
        async function getPlanetPhotoUrl() {
            // Query that finds the document with the latest [lastUsed] date
            return db.collection('planetUsedImages').orderBy('lastUsed').limit(1).get().then(async (querySnapshot) => {
                if (!querySnapshot.empty) { // Checks something exists for this query
                    // Updates the document so that it's [lastUsed] date is the current time 
                    await db.collection('planetUsedImages').doc(querySnapshot.docs[0].id).update({
                        'lastUsed': admin.firestore.FieldValue.serverTimestamp(),
                    }).catch((error) => console.log(error));
                    return querySnapshot.docs[0].data()['photoUrl']; // Returns the [photoUrl] of the retrived document
                }
            }).catch((error) => console.log(error));
        }

        return db.collection('topPlanets').get() // Deletes all documents in the topPlanet collection
            .then(res => {
                res.forEach(element => {
                    previousTopPlanetInfo[element.id] = element.data(); // existing top planet data is stored
                    element.ref.delete();
                }); // Queries the [planet] collection for the top 10 planets with the must number of posts
            }).then(async () => db.collection('planets').limit(10).orderBy('numberOfPosts', 'desc').get().then(async (querySnapshot) => {
                if (!querySnapshot.empty) { // Checks planets exists
                    let docs = querySnapshot.docs;
                    let frequentWords = new Array();
                    let radii = new Array();
                    for (let i = 0; i < docs.length; i++) { // Iterates through each planet document
                        let doc = docs[i];
                        let data = doc.data();
                        console.log(`Doc ${JSON.stringify(data)}`);
                        console.log(`Got planet: ${data.planetName}`);
                        await db.collection('planetWordCount').doc(doc.id).get().then((documentReference) => {
                            console.log(`documentReference $$$$ ${JSON.stringify(documentReference.data())}`);
                            let wordCountsMap = JSON.parse(documentReference.data().wordCounts);
                            let mostFrequentWords = getTopWords(wordCountsMap);
                            frequentWords.push(mostFrequentWords);
                        }).catch((error) => console.log(error));

                        radii.push(data.numberOfPosts);


                        await db.collection('planetUserCount').limit(10) // Finds top 10 contributors for a given planet
                            .where('planetName', '==', data.planetName)
                            .orderBy('numberOfPosts', 'desc')
                            .get().then(async (topContributorData) => {
                                for (let j = 0; j < topContributorData.docs.length; j++) { // iterates through top contributors
                                    let _data = topContributorData.docs[j].data();
                                    console.log(`topContributorData ${JSON.stringify(_data)}`);
                                    // Gets top contributor [userUid]
                                    await db.collection('users').doc(_data.userUid).get().then((userInfo) => {
                                        if (userInfo.exists) {
                                            userInfo = userInfo.data();
                                            userInfo['numberOfPosts'] = _data['numberOfPosts'];
                                            userInfo['userUid'] = _data.userUid;
                                            topContributors.push(userInfo);
                                        }
                                    });
                                }
                            }).catch((error) => console.log(error));

                        // Gets the posts of the top contributors
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
                                }).catch((error) => console.log(error));;
                        }


                        // console.log(`topContributors ${JSON.stringify(topContributors)}`);



                    }

                    console.log(`Frequent Words ${frequentWords[0]} ${frequentWords.length}, radii ${radii[0]} ${radii.length}`);
                    let newCircles = get_new_coordinates(frequentWords, radii);
                    console.log(`new circles ${newCircles}`);

                    for (let i = 0; i < docs.length; i++) {
                        let doc = docs[i];
                        let data = doc.data();

                        console.log(`${JSON.stringify(newCircles[i])}, ${data.planetName}`);

                        let planetPhotoUrl = '';
                        if (doc.id in previousTopPlanetInfo && 'planetPhotoUrl' in previousTopPlanetInfo[doc.id]) {
                            planetPhotoUrl = previousTopPlanetInfo[doc.id]['planetPhotoUrl'];
                        } else {
                            planetPhotoUrl = await getPlanetPhotoUrl();
                        }

                        if (planetPhotoUrl === undefined) {
                            planetPhotoUrl = null;
                        }

                        db.collection('topPlanets').doc(doc.id).set({
                            'planetName': data.planetName,
                            'dateCreated': data.dateCreated,
                            'x_coord': newCircles[i]['x'],
                            'y_coord': newCircles[i]['y'],
                            'radius': newCircles[i]['r'],
                            'planetPhotoUrl': planetPhotoUrl,
                            'numberOfPosts': data.numberOfPosts,
                            'topContributors': topContributors,
                        }).catch((error) => console.log(error));
                    }

                    console.log(`querySnapshot not empty`);
                    return null;
                }
            }).catch((e) => console.log(e))).catch((e) => console.log(e));
    });

/*
    When called returns the data for the personal history view. It takes four parameters:
        - startDate : The start date for the data you want
*/
exports.getPersonalHistoryData = functions.https.onCall(async (data, context) => {
    let startDate = data.startDate;
    let stopDate = data.stopDate;

    let senderUid = data.senderUid;
    let receiverUid = data.receiverUid;


    async function getPersonalHistoryDataFromStore(collection) {
        return collection
            .where('receiverUid', '==', receiverUid)
            .where('senderUid', '==', senderUid)
            .where('startDate', '==', startDate)
            .where('stopDate', '==', stopDate)
            .get().then((querySnapshot) => {
                if (!querySnapshot.empty) {
                    return querySnapshot.docs[0].data();
                } else {
                    return null;
                }
            }).catch((e) => console.log(e));
    }

    let storedCollectionResults = await getPersonalHistoryDataFromStore(db.collection('personalHistoryDataCache'));
    if (storedCollectionResults !== null) {
        return storedCollectionResults['data'];
    } else {
        let storedPostInfo = new Map();

        class JSONSet extends Set {
            toJSON() {
                return [...this]
            }
        }


        function safeMapAdd(map, key, value) {
            if (key in map) {
                map[key].add(value);
            } else {
                map[key] = new JSONSet([value]);
            }
        }


        async function collectionDataForTimeWindow(collection, isComments = false) {
            let searchBy = 'reactorUid';
            if (isComments) {
                searchBy = 'authorUid';
            }

            return collection.where('dateCreated', '>=', new Date(...(startDate.split('-').reverse())))
                .where('dateCreated', '<', new Date(...(stopDate.split('-').reverse())))
                .where('postAuthorUid', '==', receiverUid)
                .where(searchBy, '==', senderUid)
                .get()
                .then(async (querySnapshot) => {
                    console.log(`querySnapshot ${querySnapshot.docs.length}`);
                    for (let i = 0; i < querySnapshot.docs.length; i++) {
                        let _data = querySnapshot.docs[i].data();
                        if (_data.postType === null) {
                            safeMapAdd(storedPostInfo, 'text', _data.postUid);
                        } else {
                            safeMapAdd(storedPostInfo, _data.postType, _data.postUid);
                        }
                    }
                    console.log(`getPersonalHistoryData ${JSON.stringify(storedPostInfo)}`);
                }).catch((e) => console.log(e));
        }

        async function saveToCollection(collection) {
            return collection.doc().set({
                'startDate': startDate,
                'stopDate': stopDate,
                'receiverUid': receiverUid,
                'senderUid': senderUid,
                'data': JSON.stringify(storedPostInfo),
            }).catch((e) => console.log(e));
        }

        console.log(`getPersonalHistoryData ${JSON.stringify(data)}, ${startDate} ${stopDate} ${senderUid} ${receiverUid}`);

        await collectionDataForTimeWindow(db.collection('comments'), true);
        await collectionDataForTimeWindow(db.collection('color-reactions'));
        await collectionDataForTimeWindow(db.collection('slider-reactions'));

        saveToCollection(db.collection('personalHistoryDataCache'));

        return JSON.stringify(storedPostInfo);
    }
});

// TODO save values to Firestore for faster reuse
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