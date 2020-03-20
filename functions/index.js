const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNewLikeNotification = functions.https.onCall(event => {
  const payload = {
    notification: {
      body: 'Somebody liked your post!',
      badge: '1',
      sound: 'default',
    }
  };

  const registrationToken = event.text;
  return admin.messaging().sendToDevice(registrationToken, payload).then(response => {
    return null;
  });
});

exports.sendNewReplyNotification = functions.https.onCall(event => {
  const payload = {
    notification: {
      body: 'Somebody replied to your post!',
      badge: '1',
      sound: 'default',
    }
  };

  const registrationToken = event.text;
  return admin.messaging().sendToDevice(registrationToken, payload).then(response => {
    return null;
  });
});
