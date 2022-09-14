import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SecureStorage {
  final FlutterSecureStorage storage;

  SecureStorage(this.storage);

  Future<void> writeSecureData(String key, String value) async {
    var writeData = await storage.write(key: key, value: value);
    return writeData;
  }

  Future<String?> readSecureData(String key) async {
    var readData = await storage.read(key: key);
    return readData;
  }

  Future<void> deleteSecureData(String key) async {
    var deleteData = await storage.delete(key: key);
    return deleteData;
  }
}
