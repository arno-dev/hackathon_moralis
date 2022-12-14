"use strict";

const { default: Moralis } = require("moralis");
const { getIPFSCid } = require('../utils/utils');
const merge = require('deepmerge');
const { nanoid } = require('nanoid');
const e = require("express");
const OrbitDB = require('orbit-db');
const axios = require("axios");
const ALERT = require('../utils/alertType.js');
const { admin, notification_options } = require("../utils/firebase-config")

// var alertDB = new JsonDB(new Config("alertDatabase", true, false, '/'));

const {
    MORALIS_API_KEY
} = process.env;


async function loadIpfs() {
    return node
}

let db
let orbitdb
var isDBReady = false;

exports.main = async () => {
    const { create } = await import('ipfs-core')
    try {
        const ipfs = await create({
            start: true,
            EXPERIMENTAL: {
                pubsub: true,
            },
        });
        console.log("LOG:: we are checking if there's an existing DB")
        orbitdb = await OrbitDB.createInstance(ipfs);
        console.log("LOG:: we are creating a doc store from Orbit DB");

        const ipfs_db = await orbitdb.docstore("ipfs-db");
        console.log("LOG:: ipfs_db.address " + ipfs_db.address);
        db = await orbitdb.open(ipfs_db.address.toString())
        await db.load()
        // await db.put({ _id: 'gaddasg' +  Math.random() , doc: Math.random() });

        console.log("LOG:: we are creating a doc store at address : " + db.address.toString());
        isDBReady = true;
        console.log("LOG:: Orbit DB init done");
    }
    catch (e) {
        console.log("error " + e);
    }
}



// Controllers
const alertsController = require('./alertsController');

// Ty[e]
// const ALERT = require('../utils/alertType.js');

exports.uploadImagesToIpfs = async (request, response, next) => {
    const { images, origin, dest, encryptIpfsKey } = request.body;
    var data = {};
    if (!images || !origin || !dest || !encryptIpfsKey) {
        return response.sendStatus(400);
    }
    const options = request.body.images;

    try {
        const imagePath = await axios.post('https://deep-index.moralis.io/api/v2/ipfs/uploadFolder',
            JSON.stringify(options),
            {
                headers: {
                    'X-API-KEY': MORALIS_API_KEY,
                    'Content-Type': 'application/json',
                    accept: 'application/json'
                },
                maxBodyLength: Infinity
            }
        )
        if (imagePath.data.length == 0) {
            return response.sendStatus(400);
        }
        let firstImagePath = imagePath.data[0]["path"];
        let ipfs = getIPFSCid(firstImagePath);
        request.ipfs = { "cid": ipfs, imagePath, "origin": origin, "dest": dest, "ipfsKey": encryptIpfsKey };
        next();
    } catch (error) {
        response.status(500).json({ message: "Your files size is over 50MB" });
    }

}

exports.saveIpfsPathToDB = async (request, response, next) => {
    const { cid, imagePath, ipfsKey, origin, dest } = request.ipfs;
    if (!cid || !imagePath || !ipfsKey || !origin || !dest) {
        return response.sendStatus(400);
    }
    var ipfsData = {
        "paths": imagePath["data"],
        "ipfsKey": ipfsKey
    };

    await db.put({ _id: "/" + cid, doc: ipfsData })
    // await db.push("/" + cid, ipfsData)

    request.body = {
        "cid": cid,
        "ipfsKey": ipfsKey,
        "origin": origin,
        "dest": dest
    }
    next();
}

exports.createShareableLink = async (request, response) => {
    console.log("request.body " + request.body);
    const { dest, origin, ipfsKey, cid } = request.body;
    if (!dest || !origin || !ipfsKey || !cid) {
        return response.sendStatus(400);
    }
    var ID = nanoid();

    // We will create our share links
    const createdAt = new Date().toISOString();
    try {

        const shareLink = await db.query((doc) => doc._id == "/sharing/" + origin + "/" + dest + "/" + cid)[0];
        const { cid, link } = shareLink;
        await saveAlert(ALERT.GotSharedLink, dest, { "origin": origin, "ipfsKey": ipfsKey, "cid": cid, "link": link, "createdAt": createdAt });
        return response.send(shareLink);
    }
    catch (e) {
        var shareData = { "origin": origin, "dest": dest, "ipfsKey": ipfsKey, "cid": cid, "link": ID, "link": ID, "createdAt": createdAt };
        await db.put({ _id: "/links/" + ID, doc: shareData });
        await db.put({ _id: "/cid/links/" + cid, doc: shareData });
        await db.put({ _id: "/sharing/" + origin + "/" + dest + "/" + cid, doc: shareData });
        // We want to store the receivers so they can retrieve all the links shared to themselves

        await db.put({ _id: "/receivers/" + dest + "/links/" + ID, type: "links", dest: dest, doc: shareData });
        await saveAlert(ALERT.GotSharedLink, dest, { "origin": origin, "ipfsKey": ipfsKey, "cid": cid, "link": ID, "createdAt": createdAt });

        return response.send(shareData);
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


// !Important : this one is the main method to retrieve a formatted filetree images
exports.getImagesFromLink = async (request, response) => {
    const { link } = request.params;
    if (!link) {
        return response.sendStatus(400);
    }

    try {
        const imagesFromLink = await db.query((doc) => doc._id == "/links/" + link)[0];
        const { cid, ipfsKey, origin, dest } = imagesFromLink["doc"];
        const ipfsInfo = await db.query((doc) => doc._id == "/" + cid)[0];
        const ipfsImages = ipfsInfo["doc"]["paths"];
        const paths = await this.getImages(ipfsImages, cid);

        return response.send({
            "ipfsKey": ipfsKey,
            "origin": origin,
            "dest": dest,
            "cid": cid,
            "filetree": paths
        });
    }
    catch (e) {
        return response.sendStatus(204);
    }
}

exports.getRecentImagesSharedWithMyself = async (request, response) => {
    const { address } = request.params;
    if (!address) {
        return response.sendStatus(400);
    }

    try {
        const linksAddressedToMyselfRaw = await db.query((doc) => doc.type == "links" && doc.dest == address);
        var linksAddressedToMyself = [];
        for (var i = 0; i < linksAddressedToMyselfRaw.length; i++) {
            linksAddressedToMyself.push(linksAddressedToMyselfRaw[i]["doc"]);
        }
        // Now we want to grab all the files from those links
        const linksUniqueAddressedToMyself = [...new Set(linksAddressedToMyself)];
        var files = [];
        for (var i = 0; i < linksUniqueAddressedToMyself.length; i++) {
            const { link } = linksUniqueAddressedToMyself[i];

            console.log("LOG:: link : " + link);
            const imagesFromLink = await db.query((doc) => doc._id == "/links/" + link)[0];
            // const imagesFromLink = await db.getData("/links/" + link);
            const { cid, ipfsKey, origin, dest } = imagesFromLink["doc"];
            const ipfsInfo = await db.query((doc) => doc._id == "/" + cid)[0];
            // const ipfsInfo = await db.getData("/" + cid);
            const ipfsImages = ipfsInfo["doc"]["paths"];
            console.log("LOG:: ipfsImages : " + JSON.stringify(ipfsImages));
            const paths = await this.getImages(ipfsImages, cid);

            files.push({
                "ipfsKey": ipfsKey,
                "origin": origin,
                "dest": dest,
                "cid": cid,
                "createdAt": new Date().toISOString(),
                "filetree": paths
            });
        }
        return response.send(files);
    }
    catch (e) {
        return response.send([]);
    }
}

exports.getImages = async (imagesPath, ipfs) => {
    const truncatedImagesPath = imagesPath.map(e => {
        const path = e["path"];
        const pathSlices = path.split("/");
        const indexOfIpfs = pathSlices.indexOf(ipfs);
        const pathSlicesTrimmed = pathSlices.slice(indexOfIpfs + 1, pathSlices.length);
        return pathSlicesTrimmed.join("/");
    });

    var treePath = {};
    var currentTreePath = {};
    var fileFound = false;
    // We should filter by extension but for now we assume any .xxx is file extension
    const fileExtension = ["jpg", "png", "pdf"];

    const organizedPath = truncatedImagesPath.map((e) => {
        return {
            "isFolder": true,
            "name": "/",
            "children": [loop(e.split("/"), 0)]
        };
    });
    const combineMerge = (target, source, options) => {
        const destination = target.slice()

        source.forEach((item, index) => {
            if (typeof destination[index] === 'undefined') {
                destination[index] = options.cloneUnlessOtherwiseSpecified(item, options)
            } else if (options.isMergeableObject(item)) {
                destination[index] = merge(target[index], item, options)
            } else if (target.indexOf(item) === -1) {
                destination.push(item)
            }
        })
        return destination
    }

    var result = merge.all(organizedPath, combineMerge);

    const childrenTest = result;
    mergeChildren(result);

    // response.send(result);return
    return result;
}

//// To transform a path to a file tree
function loop(truncatedImagesPathSplitted, index) {
    if (index == truncatedImagesPathSplitted.length)
        return;

    const currentFolderOrFileName = truncatedImagesPathSplitted[index];
    const currentFolderOrFileNameSplitted = currentFolderOrFileName.split(".");
    // We got a file
    console.log(currentFolderOrFileNameSplitted);
    if (currentFolderOrFileNameSplitted.length > 1 && currentFolderOrFileNameSplitted[currentFolderOrFileNameSplitted.length - 1].length == 3) {
        return {
            "isFolder": false,
            "name": currentFolderOrFileName
        };
    }

    // We got a folder
    return {
        "isFolder": true,
        "name": currentFolderOrFileName,
        "children": [loop(truncatedImagesPathSplitted, index + 1)]
    };
}

/// To combine children when parent got the same name
function mergeChildren(tree) {
    // If there's no more children, stop it

    // If there's children, check all the child and if there are all the same name, merge their children
    // SO if A -> [B -> [C, D], B' -> [C] ]

    var children = tree["children"] ?? [];
    var isFolder = tree["isFolder"];
    var parentName = tree["name"];
    // No children found so nothing to do and we stop
    if (children == undefined || isFolder == false) {
        return [];
    }

    console.log("parent [" + parentName + "] got as children [" + children.length + "]");

    // Merge names first
    children = mergeChildrenIfNameExists(children);
    tree["children"] = children;

    console.log("parent [" + parentName + "] got as NEW children [" + tree["children"].length + "]");

    // Then go inside each child
    for (var i = 0; i < tree["children"].length; i++) {
        var child = tree["children"][i];
        mergeChildren(child);
    }

    // SO if A -> [B -> [C, D], B' -> [C'] ] ----> A -> [B -> [C, D, C']]
    // params : array is the children list, we go 1 by 1. If name doesn't exist, then we fill newArray with the child. If name does exsit, we append child
    function mergeChildrenIfNameExists(array) {
        var newArray = [];

        for (var i = 0; i < array.length; i++) {
            const existingName = array[i]["name"];

            // Check if we already put it in new array
            var foundIndex = -1;
            for (var j = 0; j < newArray.length && foundIndex == -1; j++) {
                const resultArrayName = newArray[j]["name"];
                if (resultArrayName == existingName) {
                    foundIndex = j;
                }
            }
            // Check if we found a similar name parent. If so, then merge their children. Otherwise just push it to new array
            if (foundIndex == -1) {
                newArray.push(array[i]);
            }
            else {
                // Merge the children so we can keep the name (only if there's children actually)
                var foundTree = newArray[foundIndex];
                var foundTreeChildren = foundTree["children"] ?? [];
                const existingTree = array[i]["children"] ?? [];
                foundTreeChildren.push(existingTree[0]);
                foundTree["children"] = foundTreeChildren;
            }
        }
        return newArray;
    };
}

// ---- ALerts ---- 
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
        await db.put({ _id: "/token/" + address, doc: token })
        return response.status(200).send({ message: "Save token success." });
    } catch (error) {
        return response.sendStatus(500)
    }
}

async function sendPush(dest, message) {
    console.log("Send push");
    try {
        const tokens = await db.query((doc) => doc._id == "/token/" + dest)[0];
        const { doc } = tokens;

        const options = notification_options;
        admin.messaging().sendToDevice(doc, message, options)
            .then(_ => {
                console.log("Notification sent successfully");
            })
            .catch(error => {
                console.log("Notification error : " + error);
            });
    } catch (error) {
        console.log("Notification error : " + error);
    }

}


async function insertAlertInDB(address, message, payload) {
    const alertData = {
        "message": message,
        "payload": payload,
        "createdAt": now()
    };

    var docs = [];
    try {
        const doc = await db.query((doc) => doc._id == "/alerts/" + address + "/messages")[0];
        docs = doc["doc"];
    }
    catch (e) {
        console.log("LOG:: no alerts available");
    }
    docs.push(alertData);
    await db.put({ _id: "/alerts/" + address + "/messages", doc: docs })
}

exports.getAlerts = async (request, response) => {
    const { address } = request.params;
    if (!address) {
        return response.sendStatus(400);
    }
    try {
        const doc = await db.query((doc) => doc._id == "/alerts/" + address + "/messages")[0];
        const shareLink = doc["doc"];
        return response.send(shareLink);
    }
    catch (e) {
        return response.send([]);
    }
}
async function saveAlert(alertType, address, payload) {
    console.log("SaveAlert::(" + alertType + ", " + address + ", " + payload);
    if (alertType == ALERT.AddedInContact) {
        // Grab the origin address
        const emitterAddress = payload["origin"];
        const body = emitterAddress.substring(0, 10) + "[...] has added you in his contact";
        const message = {
            "notification": {
                "title": "Added In Contact",
                "body": body
            },
        };

        await insertAlertInDB(address, message, payload);
        await sendPush(address, message);
    }
    else if (alertType == ALERT.GotSharedLink) {
        // Grab the origin address
        const emitterAddress = payload["origin"];
        const cid = payload["cid"];
        const link = payload["link"];
        const body = emitterAddress.substring(0, 10) + "[...] shared with you a link " + link.substring(0, 10) + "[...] for accessing : " + cid.substring(0, 10) + "[...]";
        const message = {
            "notification": {
                "title": "Got Shared Link",
                "body": body
            },
            "data": {
                "link": link
            }
        };

        console.log("insertAlertInDB:: " + message);
        await insertAlertInDB(address, message, payload);
        await sendPush(address, message);
    }
    else if (alertType == ALERT.TryingAccessSharedLink) {
        // Grab the origin address
        const emitterAddress = payload["origin"];
        const cid = payload["cid"];
        const link = payload["link"];
        const body = emitterAddress.substring(0, 10) + "[...] is trying to access the link : " + link.substring(0, 10) + "[...]";
        const message = {
            "notification": {
                "title": "Trying to access shared link",
                "body": body
            }, "data": {
                "link": link
            }
        };
        await insertAlertInDB(address, message, payload);
        await sendPush(address, message);
    }
}