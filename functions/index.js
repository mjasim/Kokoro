const functions = require('firebase-functions');
const admin = require('firebase-admin');

var app = admin.initializeApp();
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