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

            db.collection('planets').limit(1).where('planetName', '==', planetName).get().then((querySnapshot) => {
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
            }).then(() => db.collection('planets').limit(10).orderBy('numberOfPosts', 'desc').get().then((querySnapshot) => {
                if (!querySnapshot.empty) {
                    querySnapshot.docs.forEach((doc) => {
                        console.log(`Got planet: ${doc.data().planetName}`);
                        db.collection('topPlanets').doc(doc.id).set({
                            'planetName': doc.data().planetName,
                            'dateCreated': doc.data().dateCreated,
                            'numberOfPosts': doc.data().numberOfPosts,
                        }).catch((error) => console.log(error));
                    })
                    console.log(`querySnapshot empty`);

                }
            }).catch((e) => console.log(e))).catch((e) => console.log(e));

        return null;
    });