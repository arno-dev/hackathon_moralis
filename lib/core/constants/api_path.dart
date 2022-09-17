class ApiPath {
  //base url
  static const String urlMoralis = "https://ipfs.moralis.io:2053/ipfs/";
  static const String baseUrl = "https://c1a0-103-43-76-42.ap.ngrok.io";
  // static const String baseUrl = "http://localhost:3000";
  //api path
  static const String imagesFromLink = "/v2/images/link/{link}";
  static const String recent = "/v2/share/recents/{recents}";
  static const String alertAddress = "/v2/alerts/{address}";
  static const String saveImages = "/v2/share/images";
  static const String saveFirebaseToken = "/v2/saveRegistrationToken";
}
