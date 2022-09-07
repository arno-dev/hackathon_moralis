require("dotenv").config();
import { default as Moralis } from "moralis";
import express, { urlencoded, json } from 'express';
import { JsonDB, Config } from 'node-json-db';
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

// Access the parse results as request.body
app.post('/', async function (request, response) {
  const options = request.body
  Moralis.EvmApi
  const imagePath = await Moralis.EvmApi.ipfs.uploadFolder(options)
  response.send(imagePath)
});


app.listen(PORT || 3000, async () => {
  console.log("listening on localhost:3000");
  await Moralis.start({
    apiKey: MORALIS_API_KEY,
  })
});