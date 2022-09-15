class ApiPath {
  //base url
  static const String baseUrl = "https://ba4d-103-43-78-128.ap.ngrok.io";
  // static const String baseUrl = "http://localhost:3000";
  //api path
  static const String todos = "/todos";
  static const String users = "/users";
  static const String imagesFromLink = "/v2/images/link/{link}";
  static const String recent = "/v2/share/recents/{recents}";
  static const String alertAddress = "/v2/alerts/{address}";
  static const String saveImages = "/v2/share/images";
  static const String saveFirebaseToken = "/v2/saveRegistrationToken";
}
