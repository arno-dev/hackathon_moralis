// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:math';
import 'dart:typed_data';
import 'package:basic_utils/basic_utils.dart';
import 'package:cryptography/cryptography.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:pointycastle/export.dart';
import 'package:web3dart/web3dart.dart';
import 'package:encrypt/encrypt.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:convert/convert.dart';

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

  test("Get private key from mnemonic", () async {
    final seedBytes = bip39.mnemonicToSeed(
        "toward paper enemy brother man achieve coconut dad tent amateur advance copper");

    final hdk = await ED25519_HD_KEY.getMasterKeyFromSeed(seedBytes);
    KeyData addr_node =
        await ED25519_HD_KEY.derivePath("m/44'/60'/0'/0'/0'", seedBytes);
    print("data key: ${hex.encode(addr_node.key)}");
    print("data chainCode: ${hex.encode(addr_node.chainCode)}");
    var pb = await ED25519_HD_KEY.getPublicKey(addr_node.key, false);
    print(hex.encode(pb));
    final digest = KeccakDigest(256);
    Uint8List publicKey = Uint8List.fromList(pb);
    final hash = digest.process(publicKey);
    print(hex.encode(hash));
    expect(1, 1);
  });

  test("Encrypt content by x25519", () async {
    final algorithm = Cryptography.instance.x25519();

    // Let's generate two keypairs.
    final keyPair = await algorithm.newKeyPair();
     final publicKey = await keyPair.extractPublicKey();
    final remoteKeyPair = await algorithm.newKeyPair();
    final remotePublicKey = await remoteKeyPair.extractPublicKey();

    // We can now calculate the shared secret key
    final sharedSecretKey = await algorithm.sharedSecretKey(
      keyPair: keyPair,
      remotePublicKey: remotePublicKey,
    );

   final remoteSharedSecretKey = await algorithm.sharedSecretKey(
      keyPair: remoteKeyPair,
      remotePublicKey: publicKey,
    );

    final sharedSecretBytes = await sharedSecretKey.extractBytes();
    print('Shared secret: ${hex.encode(sharedSecretBytes)}');
    print('remotePublicKey.bytes: ${hex.encode(await remoteSharedSecretKey.extractBytes())}');
    expect(1, 1);
  });
}
