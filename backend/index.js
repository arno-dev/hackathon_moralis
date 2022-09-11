require("dotenv").config();
const express = require("express");
const { urlencoded, json } = require('express');
const { default: Moralis }  = require("moralis");
const bodyParser = require("body-parser")
const { JsonDB, Config } = require('node-json-db');
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
app.get('/v2/getImagesFromIPFS/:cid', imagesController.getIpfsFromCID);
// app.get('/v2/getImageFromShareableLink/:link', imagesController.getShareableLink, imagesController.getImageFromShareableLink);
app.get('/v2/getImagesFromAddress/:address', imagesController.getIpfsFromAddress);
app.post('/v2/share', imagesController.createShareableLink);
app.get('/v2/share/address', imagesController.getShareableLinkByAddresses);
app.get('/v2/share/cid', imagesController.getShareableLinkByCID);
app.get('/v2/share/:link', imagesController.getShareableLink);
app.get('/v2/getImagesFromLink/:link', imagesController.getImagesFromLink);

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

// TODO: write a unit test with an extra derivated public address and test if crypto retro compabilities work
/*
User A want to share with User B 
User A need to retrieve all users (we don't do invite system at the moment)
User A need to create a shareable link from IPFS 
  - the file is first local and not uploaded to IPFS
  - an ipfskey is used by using User B public key
  - a shared link is constant if User A to User B
  - a shared link can be for User A to User A (himself to decrypt)
  - a shared link contains the ipfskey and IPFS CID
  - 
*/
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