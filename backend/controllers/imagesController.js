
const { default: Moralis } = require("moralis");
const { JsonDB, Config } = require('node-json-db');
const { getIPFSCid } = require('../utils/utils');

const { nanoid } = require('nanoid')

var db = new JsonDB(new Config("tempDatabase", true, false, '/'));

exports.uploadImagesToIpfs = async (request, res, next) => {
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
    request.ipfs = { "cid": ipfs, imagePath, "ipfsKey": encryptIpfsKey };

    // request.ipfs = {
    //     "cid": "QmdeFdCNVYHiTsYf2Wg1xoz9CbQvBckZCAuHi1yGGxvsFP",
    //     "imagePath": [
    //         {
    //             "path": "https://ipfs.moralis.io:2053/ipfs/QmdeFdCNVYHiTsYf2Wg1xoz9CbQvBckZCAuHi1yGGxvsFP/moralis/logo5.jpg"
    //         },
    //         {
    //             "path": "https://ipfs.moralis.io:2053/ipfs/QmdeFdCNVYHiTsYf2Wg1xoz9CbQvBckZCAuHi1yGGxvsFP/moralis/logo4.jpg"
    //         }
    //     ],
    //     "ipfsKey": "test"
    // };
    next();
}

// TODO: in the future we want it to be stored in a smart contract
exports.saveIpfsPathToDB = async (request, response, next) => {
    const { address } = request.body;

    const { cid, imagePath, ipfsKey } = request.ipfs;
    if (!cid || !imagePath || !ipfsKey || !address) {
        return response.sendStatus(400);
    }

    // We want to save owner ship of IPFS along publid address
    var ownerShipData = {};

    // ownerShipData[address] = ownerShipData;
    await db.push("/ownership/" + address + "[]", cid, true);

    var ipfsData = {};
    ipfsData[cid] = {
        "paths": imagePath,
        "ipfsKey": ipfsKey
    };
    await db.push("/ipfs", ipfsData)

    response.send(request.ipfs);
}

// TODO: in the future we want it to be retrieved from a smart contract
exports.getIpfsFromCID = async (request, response) => {
    const { cid } = request.params;
    if (!cid) {
        return response.sendStatus(400);
    }
    const images = await db.getData("/ipfs/" + cid);
    return response.send(images);
}

// TODO: in the future we want it to be retrieved from a smart contract
exports.getIpfsFromAddress = async (request, response) => {
    const { address } = request.params;
    if (!address) {
        return response.sendStatus(400);
    }

    const cids = await db.getData("/ownership/" + address);
    var totalImages = [];
    for (var i = 0; i < cids.length; i++) {

        const images = await db.getData("/ipfs/" + cids[i]);
        totalImages.push(images);
    }
    return response.send(totalImages);
}

exports.createShareableLink = async (request, response) => {
    const { dest, origin, ipfsKey, cid } = request.body;
    if (!dest || !origin || !ipfsKey || !cid) {
        return response.sendStatus(400);
    }
    var ID = nanoid();
    // Check if it exist already ; if it does it means that most likely we coant 
    var shareData = { "origin": origin, "dest": dest, "ipfsKey": ipfsKey, "cid": cid , "link": ID };
    await db.push("/links/" + ID, shareData, true);
    await db.push("/cid/links/" + cid, shareData, true);
    await db.push("/sharing/" + origin + "/" + dest, shareData, true);

    return response.send(shareData);
}

exports.getShareableLinkByAddresses = async (request, response) => {
    const { dest, origin } = request.body;
    if (!dest || !origin) {
        return response.sendStatus(400);
    }

    try {
        const link = await db.getData("/sharing/" + origin + "/" + dest);
        return response.send(link);
    }
    catch (e) {
        return response.sendStatus(204);
    }
}

exports.getShareableLinkByCID = async (request, response) => {
    const { cid } = request.body;
    if (!cid) {
        return response.sendStatus(400);
    }

    try {
        const link = await db.getData("/cid/links/" + cid);
        return response.send(link);
    }
    catch (e) {
        return response.sendStatus(204);
    }
}

exports.getShareableLink = async (request, response) => {
    const { link } = request.params;
    if (!link) {
        return response.sendStatus(400);
    }

    try {
        const link = await db.getData("/links/" + link);
        return response.send(link);
    }
    catch (e) {
        return response.sendStatus(204);
    }
}
