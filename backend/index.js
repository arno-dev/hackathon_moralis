require("dotenv").config();
const express = require("express");
const { json } = require('express');
const { default: Moralis }  = require("moralis");
const bodyParser = require("body-parser")
const codec = require('json-url')('lzw');
const app = express()

// Controllers
const imagesController = require('./controllers/imagesController');

// Parse JSON bodies (as sent by API clients)
app.use(json());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

const {
  MORALIS_API_KEY,
  PORT
} = process.env;

/// TODO: move to utils
function getIPFSCid(url) {
  let urlSplitted = url.split('/');
  let ipfsIndex = urlSplitted.indexOf('ipfs');
  if (ipfsIndex < urlSplitted.length) {
    let ipfs = urlSplitted[ipfsIndex + 1];
    return ipfs;
  }
  return "";
}

/// New version of saving images on IPFS
app.post('/v2/saveImages', imagesController.uploadImagesToIpfs, imagesController.saveIpfsPathToDB)
// !important : this one will be used
app.get('/v2/images/link/:link', imagesController.getImagesFromLink);
app.get('/v2/images/address/:address', imagesController.getImagesFromAddress);
app.post('/v2/share', imagesController.createShareableLink);
// WIP
app.get('/v2/share/address', imagesController.getShareableLinkByAddresses);
app.get('/v2/share/users/:address', imagesController.getSharedUsers);
// Push notification
app.post('/v2/saveRegistrationToken', imagesController.saveRegistrationToken)
app.post('/v2/sendNotifications', imagesController.sendNotifications)
app.get('/v2/getRegistrationTokenFromAddress/:address', imagesController.getRegistrationTokenFromAddress)

/// Old version below

/// Save images on IPFS and return list of path 
app.post('/saveImages', async function (request, response) {
  const { images, address, encryptIpfsKey } = request.body;
  var data = {};
  if (!images || !address || !encryptIpfsKey) {
    return response.sendStatus(400);
  }
  const options = { abi: request.body.images };
  const imagePath = await Moralis.EvmApi.ipfs.uploadFolder(options);
  if (imagePath.data.length == 0) {
    return response.sendStatus(400);
  }
  let firstImagePath = imagePath.data[0]["path"];
  let ipfs = getIPFSCid(firstImagePath);
  data[address] = { "cid": ipfs, imagePath, "ipfsKey": encryptIpfsKey };

  // We will save the IPFS CID along the list of images

  await db.push("/images", data);
  return response.send(data[address]);
});

/// Get your images from IPFS
app.get('/getImages/:address', async function (request, response) {
  const { address } = request.params
  if (!address) {
    return response.sendStatus(400);
  }
  const images = await db.getData("/images/" + address);
  return response.send(images);
});

/// Register push notification token 
app.post('/register/token', async function (request, response) {
  const { token } = request.body;
  if (!token) {
    return response.sendStatus(400);
  }
  data[address] = { "token": token, "ipfsKey": encryptIpfsKey };
  await db.push("/images", data);
});

/// Get users 
app.get('/users', async function (request, response) {
  // const users = await db.getData("/users");
  const url = "https://ipfs.moralis.io:2053/ipfs/QmdeFdCNVYHiTsYf2Wg1xoz9CbQvBckZCAuHi1yGGxvsFP/moralis";
  let ipfs = getIPFSCid(url);
  if (ipfs === "") {
    return response.statusCode(403);
  }

  return response.send({ "ipfs-cid": ipfs });
});

/// Create shareable links
app.post('/getLinks/:address', async function (request, response) {
  const { address } = request.params;
  const { ipfsKey, ipfs } = request.body;
  if (!ipfsKey || !address) {
    return response.sendStatus(400);
  }

  // TODO: we will reuse the /saveImages logic 

  // TODO: we will return a link which is a JSON embed {ipfsURL }
  codec.compress(obj).then(result => console.log(result));

});


app.listen(PORT || 3000, async () => {
  console.log("listening on localhost:3000");
  await Moralis.start({
    apiKey: MORALIS_API_KEY,
  })
});