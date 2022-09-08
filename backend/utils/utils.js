

exports.getIPFSCid = (url) => {
    let urlSplitted = url.split('/');
    let ipfsIndex = urlSplitted.indexOf('ipfs');
    if (ipfsIndex < urlSplitted.length) {
        let ipfs = urlSplitted[ipfsIndex + 1];
        return ipfs;
    }
    return "";
}
