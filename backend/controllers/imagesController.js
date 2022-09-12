
const { default: Moralis } = require("moralis");
const { JsonDB, Config } = require('node-json-db');
const { getIPFSCid } = require('../utils/utils');
const merge = require('deepmerge');
const { nanoid } = require('nanoid');
const e = require("express");

var db = new JsonDB(new Config("tempDatabase", true, false, '/'));

exports.uploadImagesToIpfs = async (request, response, next) => {
    const { images, origin, dest, encryptIpfsKey } = request.body;
    var data = {};
    if (!images || !origin || !dest || !encryptIpfsKey) {
        return response.sendStatus(400);
    }
    const options = { abi: request.body.images };
    const imagePath = await Moralis.EvmApi.ipfs.uploadFolder(options);
    if (imagePath.data.length == 0) {
        return response.sendStatus(400);
    }
    let firstImagePath = imagePath.data[0]["path"];
    let ipfs = getIPFSCid(firstImagePath);
    request.ipfs = { "cid": ipfs, imagePath, "origin": origin, "dest": dest, "ipfsKey": encryptIpfsKey };
    next();
}

exports.saveIpfsPathToDB = async (request, response, next) => {
    const { cid, imagePath, ipfsKey, origin, dest } = request.ipfs;
    if (!cid || !imagePath || !ipfsKey || !origin || !dest) {
        return response.sendStatus(400);
    }

    // We want to save owner ship of IPFS along publid address
    var ownerShipData = {};

    await db.push("/ownership/" + origin + "[]", cid, true);

    var ipfsData = {};
    ipfsData[cid] = {
        "paths": imagePath["data"],
        "ipfsKey": ipfsKey
    };
    // TODO: remove below
    console.log(ipfsData);
    await db.push("/ipfs/" + cid + "/paths", ipfsData)

    // TODO: change with that 
    /*
        "ipfs": {
        "QmdeFdCNVYHiTsYf2Wg1xoz9CbQvBckZCAuHi1yGGxvsFP": {
            "paths": [
                {
                    "path": "https://ipfs.moralis.io:2053/ipfs/QmdeFdCNVYHiTsYf2Wg1xoz9CbQvBckZCAuHi1yGGxvsFP/moralis/logo5.jpg"
                },
                {
                    "path": "https://ipfs.moralis.io:2053/ipfs/QmdeFdCNVYHiTsYf2Wg1xoz9CbQvBckZCAuHi1yGGxvsFP/moralis/logo4.jpg"
                }
            ],
            "ipfsKey": "test+ananothertest"
        }
    },
    */
    request.body = {
        "cid": cid,
        "ipfsKey": ipfsKey,
        "origin": origin,
        "dest": dest
    }
    next();
    // return response.send(request.body)
}

exports.getSharedUsers = async (request, response) => {
    const { address } = request.params;
    if (!address) {
        return response.sendStatus(400);
    }

    try {
        const sharedUsers = await db.getData("/sharing/" + address + "/users");
        const sharedUserAddresses = sharedUsers.map((e) => e["user"]);
        return response.send(sharedUserAddresses);
    }
    catch (e) {
        return response.sendStatus(204);
    }
}

exports.createShareableLink = async (request, response) => {
    console.log("request.body " + request.body);
    const { dest, origin, ipfsKey, cid } = request.body;
    if (!dest || !origin || !ipfsKey || !cid) {
        return response.sendStatus(400);
    }
    var ID = nanoid();

    // We want to save the list of users somewhere
    try {
        const sharedUsers = await db.getData("/sharing/" + origin + "/users");
        const sharedUserAddresses = sharedUsers.map((e) => e["user"]);
        if (sharedUserAddresses.indexOf(dest) < 0) {
            // Doesn't exist so we can push it
            await db.push("/sharing/" + origin + "/users[]/user", dest);
        }
    }
    catch (e) {
        // Doesn't exist so we can push it
        await db.push("/sharing/" + origin + "/users[]/user", dest);
    }

    try {
        const shareLink = await db.getData("/sharing/" + origin + "/" + dest + "/" + cid);
        return response.send(shareLink);
    }
    catch (e) {
        var shareData = { "origin": origin, "dest": dest, "ipfsKey": ipfsKey, "cid": cid, "link": ID };
        await db.push("/links/" + ID, shareData, true);
        await db.push("/cid/links/" + cid, shareData, true);
        await db.push("/sharing/" + origin + "/" + dest + "/" + cid, shareData, true);

        return response.send(shareData);
    }
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


// !Important : this one is the main method to retrieve a formatted filetree images
exports.getImagesFromLink = async (request, response) => {
    const { link } = request.params;
    if (!link) {
        return response.sendStatus(400);
    }

    try {
        const imagesFromLink = await db.getData("/links/" + link);
        const cid = imagesFromLink["cid"];
        const ipfsInfo = await db.getData("/ipfs/" + cid + "/paths");
        const ipfsKey = imagesFromLink["ipfsKey"];
        const ipfsImages = ipfsInfo[cid]["paths"];
        paths = await this.getImages(ipfsImages, cid);

        response.send({
            "ipfsKey": ipfsKey,
            "cid": cid,
            "filetree": paths
        });
    }
    catch (e) {
        return response.sendStatus(204);
    }
}

// !Important : this one is the main method to retrieve a formatted filetree images
exports.getImagesFromAddress = async (request, response) => {
    const { address } = request.params;
    if (!address) {
        return response.sendStatus(400);
    }

    try {
        const imagesFromAddress = await db.getData("/images/" + address);
        const cid = imagesFromAddress["cid"];
        // const ipfsInfo = await db.getData("/ipfs/" + cid);
        // const ipfsKey = imagesFromLink["ipfsKey"];
        const ipfsImages = imagesFromAddress["imagePath"];
        paths = await this.getImages(ipfsImages, cid);

        response.send({
            // "ipfsKey": ipfsKey, // We intentionally hide the ipfsKey
            "cid": cid,
            "filetree": paths
        });
    }
    catch (e) {
        return response.sendStatus(204);
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
    // result =  mergeChildrenIfNameExists(result["children"]);
    // var resultTree = {};
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