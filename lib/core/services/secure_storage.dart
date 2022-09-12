import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SecureStorage{
  final FlutterSecureStorage storage;

  SecureStorage(this.storage);

  Future writeSecureData(String key, String value)  async {
    var writeData = await storage.write(key: key, value: value);
    return writeData;
  }
  Future readSecureData(String key) async {
    var readData = await storage.read(key: key);
    return readData;
  }
  Future deleteSecureData(String key) async{
    var deleteData = await storage.delete(key: key);
    return deleteData;
  }
}