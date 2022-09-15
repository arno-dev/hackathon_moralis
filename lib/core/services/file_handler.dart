import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

import '../../features/home/data/models/params/upload_image_param/image_param.dart';

@lazySingleton
class FileHandler {
  final FilePicker filePicker;
  final http.Client client;
  final ImagePicker imagePicker;

  FileHandler(this.filePicker, this.client, this.imagePicker);

  Future<void> getPreviewFile(String base64String, String filename) async {
    Directory dir = await getTemporaryDirectory();
    dir.deleteSync(recursive: true);
    dir.create();
    File file = File('${dir.path}/$filename');
    Uint8List bytes = base64Decode(base64String);
    await file.writeAsBytes(bytes);
    OpenFilex.open(file.path);
  }

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

  Future<List<ImageParam>> getMultiFiles(
      {List<String>? allowedExtensions}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: allowedExtensions == null ? FileType.any : FileType.custom,
      allowedExtensions: allowedExtensions,
    );
    List<ImageParam> files = [];
    if (result != null) {
      for (var path in result.paths) {
        if (path != null) {
          final imageBase64 = await _convertFileToBase64(File(path));
          files.add(
            ImageParam(
              content: imageBase64,
              path: path.split("/").last,
            ),
          );
        }
      }
    }
    return files;
  }

  Future<List<ImageParam>> takePhoto() async {
    List<ImageParam> response = [];
    final XFile? pickedFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 100.w,
      maxHeight: 100.h,
      imageQuality: 50,
    );

    String? path = pickedFile?.path;
    if (path != null) {
      File file = File(path);
      List<int> imageBytes = await file.readAsBytes();
      String imageBase64 = base64Encode(imageBytes);
      ImageParam imageParam =
          ImageParam(path: path.split("/").last, content: imageBase64);
      response.add(imageParam);
      return response;
    }
    return response;
  }

  // Return size of file in MB form
  double getFileSizeInMb(File file, int decimals) {
    int sizeInBytes = file.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    return sizeInMb;
  }

  Future<String> _convertFileToBase64(File file) async {
    List<int> imageBytes = await file.readAsBytes();
    return base64Encode(imageBytes);
  }

  Future<String> networkFileToBase64(String imageUrl) async {
    http.Response response = await client.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    return base64Encode(bytes);
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
}
