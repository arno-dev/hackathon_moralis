import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

@lazySingleton
class FileHandler {
  final FilePicker filePicker;
  final http.Client client;

  FileHandler(this.filePicker, this.client);

  Future<String?> getSingleFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    String? path = result?.files.single.path;
    if (path != null) {
      File file = File(path);
      String base64 = await _convertFileToBase64(file);
      return base64;
    } else {
      return null;
    }
  }

  Future<List<String>> getMultiFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    List<String> files = [];
    if (result != null) {
      for (var path in result.paths) {
        if (path != null) {
          final imageBase64 = await _convertFileToBase64(File(path));
          files.add(imageBase64);
        }
      }
    }
    return files;
  }

  Future<String> _convertFileToBase64(File file) async {
    List<int> imageBytes = await file.readAsBytes();
    return base64Encode(imageBytes);
  }

  Future<String> networkImageToBase64(String imageUrl) async {
    http.Response response = await client.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    return base64Encode(bytes);
  }

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

  IV _createIV(String strIv) {
    var iv = sha256
        .convert(utf8.encode(strIv))
        .toString()
        .substring(0, 16); // Consider the first 16 bytes of all 64 bytes
    return IV.fromUtf8(iv.toString());
  }

  Encrypter _createEncrypter(String strPwd) {
    var key = sha256.convert(utf8.encode(strPwd)).toString().substring(0, 32);
    Key keyObj = Key.fromUtf8(key.toString());
    return Encrypter(AES(keyObj));
  }

  String encryption(String payload, String strPwd) {
    String strIv = 'SuperSecretBLOCK';
    IV ivObj = _createIV(strIv);
    final encrypter = _createEncrypter(strPwd);
    final encrypted = encrypter.encrypt(payload, iv: ivObj);
    return encrypted.base64;
  }

  String decryption(String payload, String strPwd) {
    String strIv = 'SuperSecretBLOCK';
    IV ivObj = _createIV(strIv);
    final encrypter = _createEncrypter(strPwd);
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
    final base16 = encryption(data, password);
    return file.writeAsString(base16);
  }
}
