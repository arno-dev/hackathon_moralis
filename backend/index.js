require("dotenv").config();
const { default: Moralis }  = require("moralis");
const express  = require("express");
const { urlencoded, json } =  require('express');
const { JsonDB, Config } = require('node-json-db');
const app = express()
// Parse URL-encoded bodies (as sent by HTML forms)
app.use(urlencoded());

// Parse JSON bodies (as sent by API clients)
app.use(json());

const {
  MORALIS_API_KEY,
  PORT
} = process.env;

var db = new JsonDB(new Config("tempDatabase", true, false, '/'));

/// example body:
/// {
///   "images": [
///      {
///        "path": "QmVH1D8x5tUhpehBKgL8mZLdL62jqkEg1afQCVnqCM8Jae/moralis/logo5.jpg",
///        "content":
///          "iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAApgAAAKYB3X3"
///      },
///      {
///        "path": "QmVH1D8x5tUhpehBKgL8mZLdL62jqkEg1afQCVnqCM8Jae/moralis/logo4.jpg",
///        "content":
///          "iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAApgAAAKYB3X3"
///      }
///    ],
///   "address": "0xFE2b19a3545f25420E3a5DAd1154ed5011w852ew",
///   "encryptIpfsKey": test
/// }
// 0xFE2b19a3545f25420E3a5DAd1154ed5011w852ex
app.post('/saveImages', async function (request, response) {
  const {images, address, encryptIpfsKey} = request.body;
  var data = {};
  if(!images || !address || !encryptIpfsKey){
    return response.sendStatus(400);
  }
  const options = {abi: request.body.images};
  const imagePath = await Moralis.EvmApi.ipfs.uploadFolder(options);
  data[address] = {imagePath, "ipfsKey": encryptIpfsKey};
  await db.push("/images", data);
  return response.send(data[address]);
});

// get your images
app.get('/getImages/:address', async function (request, response){
  const {address} = request.params
  if(!address){
    return response.sendStatus(400);
  }
  const images = await db.getData("/images/"+ address);
  return response.send(images);
});


app.listen(PORT || 3000, async () => {
  console.log("listening on localhost:3000");
  await Moralis.start({
    apiKey: MORALIS_API_KEY,
  })
});