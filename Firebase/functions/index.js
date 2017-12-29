const functions = require('firebase-functions');

const firebase = require('firebase-admin');
const firebaseApp = firebase.initializeApp(
    functions.config().firebase
);
const firestore = firebase.firestore();


exports.onCreateUser = functions.auth.user().onCreate(event => {
    const token = event.data.uid;
    return createNewUser(token);
});

function createNewUser(token) {
    const todayDate = new Date();

    return firestore.collection('users').doc(token).set({
        created: todayDate
    });
}
