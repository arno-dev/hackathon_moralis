class FirebaseTokenParam {
  final String? address;
  final String? token;

  const FirebaseTokenParam({this.address, this.token});

  Map<String, dynamic> toMap() => {
        'address': address,
        'token': token,
      };
}