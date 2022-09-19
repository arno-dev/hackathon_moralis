require("dotenv").config();
const express = require("express");

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
    limit: "Infinity",
    parameterLimit: 100000
  })
);

app.use(
  bodyParser.json({
    limit: "Infinity",
    parameterLimit: 100000
  })
);

app.use(
  bodyParser.raw({
    limit: "Infinity",
    inflate: true,
    parameterLimit: 100000
  })
);

const {
  PORT
} = process.env;

// !important : this one will be used
app.get('/v2/share/recents/:address', imagesController.getRecentImagesSharedWithMyself);
app.get('/v2/images/link/:link', imagesController.getImagesFromLink);
app.get('/v2/alerts/:address', alertsController.getAlerts);
app.post('/v2/share/images', imagesController.uploadImagesToIpfs, imagesController.saveIpfsPathToDB, imagesController.createShareableLink);
app.post('/v2/saveRegistrationToken', alertsController.saveRegistrationToken)


app.listen(PORT || 3000, async () => {
  console.log("listening on localhost:3000");
  await Moralis.start({
    apiKey: MORALIS_API_KEY,
  })

  await imagesController.main();
});