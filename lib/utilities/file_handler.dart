// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:path_provider/path_provider.dart';

class FileHandler {
  Future<String?> get _localPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  File get testFile {
    return File('assets/images/metamask.png');
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/fineName.txt');
  }

  Future<String?> readData(String password, [bool relative = true]) async {
    try {
      File? file;
      if (relative) {
        file = testFile;
      } else {
        file = await _localFile;
      }
      final data = await file.readAsString();
      return decryption(data, password);
    } catch (e) {
      rethrow;
    }
  }
  
  String encryption(String payload, String strPwd) {
    String strIv = 'SuperSecretBLOCK';
    var iv = sha256.convert(utf8.encode(strIv)).toString().substring(0, 16);         // Consider the first 16 bytes of all 64 bytes
    var key = sha256.convert(utf8.encode(strPwd)).toString().substring(0, 32); 
    IV ivObj = IV.fromUtf8(iv.toString());
    Key keyObj = Key.fromUtf8(key.toString());
    final encrypter = Encrypter(AES(keyObj));
    final encrypted = encrypter.encrypt(payload, iv: ivObj);
    return encrypted.base64;
  }

  String decryption(String payload, String strPwd) {
    String strIv = 'SuperSecretBLOCK';
     var iv = sha256.convert(utf8.encode(strIv)).toString().substring(0, 16);         // Consider the first 16 bytes of all 64 bytes
    var key = sha256.convert(utf8.encode(strPwd)).toString().substring(0, 32); 
    IV ivObj = IV.fromUtf8(iv.toString());
    Key keyObj = Key.fromUtf8(key.toString());
    final encrypter = Encrypter(AES(keyObj));
    final decrypted = encrypter.decrypt(Encrypted.from64(payload), iv: ivObj);
    return decrypted;
  }
  Future<File> writeFile(String data, String password,
      [bool relative = true]) async {
    File? file;
    if (relative) {
      file = testFile;
    } else {
      file = await _localFile;
    }
    final base16 = await encryption(data, password);
    return file.writeAsString(base16);
  }
}
