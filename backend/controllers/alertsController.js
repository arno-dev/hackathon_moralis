const { JsonDB, Config } = require('node-json-db');
const ALERT = require('../utils/alertType.js');
const { admin, notification_options } = require("../utils/firebase-config")
var alertDB = new JsonDB(new Config("alertDatabase", true, false, '/'));

/// Create a notification table 
/*
There will be differnt type of alerts :
- someone added you in his list of contacts
- someone is trying to share a link with you
- someone is trying to access to a link you share
*/

function now() {
    return new Date().toISOString();
}


// save firebase token
exports.saveRegistrationToken = async (request, response) => {
    const { address, token } = request.body;
    if (!address || !token) {
        return response.sendStatus(400);
    }
    try {
        await alertDB.push("/token/" + address, token);
        return response.status(200).send({ message: "Save token success." });
    } catch (error) {
        return response.sendStatus(500)
    }
}
// get firebase token from address
exports.getRegistrationTokenFromAddress = async (request, response) => {
    const { address } = request.params;
    if (!address) {
        return response.status(400);
    }
    const firebaseToken = await alertDB.getData("/token/" + address);
    return response.send({ "token": firebaseToken });
}

async function sendPush(dest, message) {
    const options = notification_options;

    // Get the token based on the destination address
    try {
        const firebaseToken = await alertDB.getData("/token/" + dest);

        admin.messaging().sendToDevice(firebaseToken, message, options)
            .then(_ => {
                return response.status(200).send("Notification sent successfully")
            })
            .catch(error => {
                return response.status(500).send(error)
            });
    }
    catch (e) {
        console.log("No firebase token was found for : " + dest);
    }
}

// send invite link via firebase cloud messaging
exports.sendNotifications = async (request, response) => {
    const { registrationToken, message } = request.body
    const options = notification_options
    if (!registrationToken || !message) {
        return response.status(400)
    }
    admin.messaging().sendToDevice(registrationToken, message, options)
        .then(data => {
            return response.status(200).send(data)
        })
        .catch(error => {
            return response.status(500).send(error)
        });
}


async function insertAlertInDB(address, message, payload) {
    const alertData = {
        "message": message,
        "payload": payload,
        "createdAt": now()
    };
    await alertDB.push("/alerts/" + address + '/messages[]', alertData, true);
}

exports.getAlerts = async (request, response) => {
    const { address } = request.params;
    if (!address) {
        return response.sendStatus(400);
    }
    try {
        const shareLink = await alertDB.getData("/alerts/" + address + "/messages");
        return response.send(shareLink);
    }
    catch (e) {
        return response.send([]);
    }
}

exports.saveAlert = async (alertType, address, payload) => {
    console.log("SaveAlert::(" + alertType + ", " + address + ", " + payload);
    if (alertType == ALERT.AddedInContact) {
        // Grab the origin address
        const emitterAddress = payload["origin"];
        const message = emitterAddress.substring(0, 10) + "[...] has added you in his contact";

        await insertAlertInDB(address, message, payload);
        await sendPush(address, message);
    }
    else if (alertType == ALERT.GotSharedLink) {
        // Grab the origin address
        const emitterAddress = payload["origin"];
        const cid = payload["cid"];
        const link = payload["link"];
        const message = emitterAddress.substring(0, 10) + "[...] shared with you a link " + link.substring(0, 10) + "[...] for accessing : " + cid.substring(0, 10) + "[...]";

        console.log("insertAlertInDB:: " + message);
        await insertAlertInDB(address, message, payload);
        await sendPush(address, message);
    }
    else if (alertType == ALERT.TryingAccessSharedLink) {
        // Grab the origin address
        const emitterAddress = payload["origin"];
        const cid = payload["cid"];
        const link = payload["link"];
        const message = emitterAddress.substring(0, 10) + "[...] is trying to access the link : " + link.substring(0, 10) + "[...]";

        await insertAlertInDB(address, message, payload);
        await sendPush(address, message);
    }
    // Need to call a push notification maybe
}