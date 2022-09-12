var admin = require("firebase-admin");

var serviceAccount = require("../d-box-app.json");


admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
})

exports.notification_options = {
    priority: "high",
    timeToLive: 60 * 60 * 24
};



module.exports.admin = admin