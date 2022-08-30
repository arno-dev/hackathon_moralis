// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:math';
import 'package:basic_utils/basic_utils.dart';
import 'package:web3dart/web3dart.dart';
import 'package:encrypt/encrypt.dart';

import 'package:flutter_test/flutter_test.dart';

class WalletGenerator {
  Future<List<String>> generateWallet() async {
// Or generate a new key randomly
    var rng = Random.secure();

    EthPrivateKey credentials = EthPrivateKey.createRandom(rng);
    final publicKey = await credentials.extractAddress();
    String privateKey = credentials.privateKeyInt.toString();

    return [publicKey.hex, privateKey];
  }
}

class Codable {
  String encryptionRsa(String publicKey, String content) {
    String pem =
        '-----BEGIN RSA PUBLIC KEY-----\n$publicKey\n-----END RSA PUBLIC KEY-----';
    RSAPublicKey public = CryptoUtils.rsaPublicKeyFromPem(pem);
    return CryptoUtils.rsaEncrypt(content, public);
  }

  String decryptionRsa(String privateKey, String content) {
    String pem =
        '-----BEGIN RSA PRIVATE KEY-----\n$privateKey\n-----END RSA PRIVATE KEY-----';
    RSAPrivateKey private = CryptoUtils.rsaPrivateKeyFromPem(pem);
    return CryptoUtils.rsaDecrypt(content, private);
  }

  String encryptionAes(String plainText, String password) {
    // final key = Key.fromUtf8(password);
    final key = Key.fromUtf8('my 32 length key................');
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  String decryptionAes(Encrypted encrypted, String password) {
    // final key = Key.fromUtf8(password);
    final key = Key.fromUtf8('my 32 length key..............');
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key));
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }
}

void main() {
  test("Generate credential", () async {
    final WalletGenerator walletGenerator = WalletGenerator();
    
    // first index is publickey, last index is private key
    final keys = await walletGenerator.generateWallet();
    final test = EthPrivateKey.fromInt(BigInt.parse(keys.last));
    final public = await test.extractAddress();
   
    expect(keys.first, public.hex);
  });
}
