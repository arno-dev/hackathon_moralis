require("dotenv").config();
const express = require("express");

const { urlencoded, json } = require('express');
const { default: Moralis }  = require("moralis");
const bodyParser = require("body-parser")
const codec = require('json-url')('lzw');
const app = express()

// Controllers
const imagesController = require('./controllers/imagesController');
const alertsController = require('./controllers/alertsController');

// Parse JSON bodies (as sent by API clients)
app.use(
  bodyParser.urlencoded({
    extended: true,
    limit: "50mb",
    parameterLimit: 100000
  })
);

app.use(
  bodyParser.json({
    limit: "50mb",
    parameterLimit: 100000
  })
);

app.use(
  bodyParser.raw({
    limit: "50mb",
    inflate: true,
    parameterLimit: 100000
  })
);

const {
  MORALIS_API_KEY,
  PORT
} = process.env;

// !important : this one will be used
app.get('/v2/images/link/:link', imagesController.getImagesFromLink);
// This one will be used to retrieve our own images
app.get('/v2/images/address/:address', imagesController.getImagesFromAddress);
app.post('/v2/share', imagesController.createShareableLink);

app.get('/v2/share/address', imagesController.getShareableLinkByAddresses);
app.get('/v2/share/recents/:address', imagesController.getRecentImagesSharedWithMyself);

// We want to have a list of users we shared links in the past
app.get('/v2/share/users/:address', imagesController.getSharedUsers);

app.post('/v2/share/images', imagesController.uploadImagesToIpfs, imagesController.saveIpfsPathToDB, imagesController.createShareableLink);

// Push notification
app.post('/v2/saveRegistrationToken', alertsController.saveRegistrationToken)
app.post('/v2/sendNotifications', alertsController.sendNotifications) // Note : it shouldn't be available in UAT
app.get('/v2/getRegistrationTokenFromAddress/:address', alertsController.getRegistrationTokenFromAddress)

// Alerts 
app.get('/v2/alerts/:address', alertsController.getAlerts);


app.listen(PORT || 3000, async () => {
  console.log("listening on localhost:3000");
  await Moralis.start({
    apiKey: MORALIS_API_KEY,
  })
});