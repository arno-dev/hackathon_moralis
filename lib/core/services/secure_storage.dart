import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SecureStorage {
  final FlutterSecureStorage storage;

  SecureStorage(this.storage);

  Future<void> writeSecureData(String key, Object object) async {
    var writeData = await storage.write(key: key, value: jsonEncode(object));
    return writeData;
  }

  Future<T?> readSecureData<T>(String key) async {
    String? readData = await storage.read(key: key);
    if (readData != null) {
      return jsonDecode(readData);
    }
    return null;
  }

  Future<void> deleteSecureData(String key) async {
    var deleteData = await storage.delete(key: key);
    return deleteData;
  }
}
