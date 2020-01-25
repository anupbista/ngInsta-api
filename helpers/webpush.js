const webpush = require('web-push');
const { VAPID_KEYS } = require('../config/config');
const { Alias, User } = require('../db/sequilize');

webpush.setVapidDetails(
    'mailto:https://nginsta.netlify.com',
    VAPID_KEYS.publicKey,
    VAPID_KEYS.privateKey
);

 module.exports = {
    sendNotification: function(payload, type) {
        return new Promise( async (resolve, reject) => {
            try {
                const subscriptionUser =  await User.findOne({ where: { id: payload.userId }, attributes: ['id', 'notification_subs'] });
                let messageBody = "";
                if(type === "followRequested"){
                    messageBody = payload.aliasName + " has requested to follow you."
                }
                const notificationPayload = {
                    "notification": {
                        "title": "ngInsta",
                        "body": messageBody,
                        "icon": "assets/loading-logo.svg",
                        "vibrate": [100, 50, 100],
                        "data": {
                            "url": "https://nginsta.netlify.com",
                            "dateOfArrival": Date.now(),
                            "primaryKey": 1
                        },
                        "actions": [{
                            "action": "notification",
                            "title": "Open ngInsta"
                        }]
                    }
                };
                await webpush.sendNotification(JSON.parse(subscriptionUser.notification_subs), JSON.stringify(notificationPayload) )
                resolve("Notification sent successfully.");
            } catch (error) {
                reject(error);
            }
        } )
    }
}