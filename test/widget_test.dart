// ignore_for_file: depend_on_referenced_packages

import 'dart:math';
import 'package:bip32/bip32.dart';
import 'package:flutter/foundation.dart';
import 'package:hackathon_moralis/utilities/eth.dart';
import 'package:hackathon_moralis/utilities/file_handler.dart';
import 'package:web3dart/web3dart.dart';
import 'package:bip39/bip39.dart' as bip39;
import "package:crypto/crypto.dart" show sha256;
import "package:convert/convert.dart";

import 'package:pinenacl/x25519.dart' show Box, PrivateKey, EncryptedMessage;
import 'package:pinenacl/api.dart';
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

void main() {
  test("Generate credential", () async {
    final WalletGenerator walletGenerator = WalletGenerator();

    // first index is publickey, last index is private key
    final keys = await walletGenerator.generateWallet();
    final test = EthPrivateKey.fromInt(BigInt.parse(keys.last));
    final public = await test.extractAddress();

    expect(keys.first, public.hex);
  });

  test("Get private and public key by bip32", () async {
    const actual = "0xFE2b19a3545f25420E3a5DAdf11b5582b5B3aBA8";
    final eth = Eth();
    final seedBytes = bip39.mnemonicToSeed(
        "toward paper enemy brother man achieve coconut dad tent amateur advance copper");
    BIP32 node = BIP32.fromSeed(seedBytes);
    BIP32 child = node.derivePath("m/44'/60'/0'/0/0");
    debugPrint("private key: ${hex.encode(child.privateKey!.toList())}");
    debugPrint("public key: ${hex.encode(child.publicKey)}");
    debugPrint("address: ${eth.ethereumAddressFromPublicKey(child.publicKey)}");
    expect(actual, eth.ethereumAddressFromPublicKey(child.publicKey));
  });

  test("Encrypt ipfs key by pinenacl", () async {
    debugPrint('\n### Public Key Encryption - Box Example ###\n');
    final seedBytes = bip39.mnemonicToSeed(
        "toward paper enemy brother man achieve coconut dad tent amateur advance copper");
    final digest = sha256.convert(seedBytes.toList());
    // Generate Bob's private key, which must be kept secret
    final skbob = PrivateKey.fromSeed(Uint8List.fromList(digest.bytes));

    // Bob's public key can be given to anyone wishing to send
    // Bob an encrypted message
    final pkbob = skbob.publicKey;

    // Alice does the same and then Alice and Bob exchange public keys
    final skalice = PrivateKey.generate();

    final pkalice = skalice.publicKey;

    // Bob wishes to send Alice an encrypted message so Bob must make a Box with
    // his private key and Alice's public key
    final bobBox = Box(myPrivateKey: skbob, theirPublicKey: pkalice);

    // This is our message to send, it must be a bytestring as Box will treat it
    // as just a binary blob of data.
    const message =
        "There is no conspiracy out there, but lack of the incentives to drive the people towards the answers.";

    // TweetNaCl can automatically generate a random nonce for us, making the encryption very simple:
    // Encrypt our message, it will be exactly 40 bytes longer than the
    // original message as it stores authentication information and the
    // nonce alongside it.
    final encryptedAsList =
        bobBox.encrypt(Uint8List.fromList(message.codeUnits)).sublist(0);

    // Finally, the message is decrypted (regardless of how the nonce was generated):
    // Alice creates a second box with her private key to decrypt the message
    final aliceBox = Box(myPrivateKey: skalice, theirPublicKey: pkbob);

    // Decrypt our message, an exception will be raised if the encryption was
    // tampered with or there was otherwise an error.
    final decrypted = aliceBox
        .decrypt(EncryptedMessage.fromList(encryptedAsList.asTypedList));
    debugPrint(String.fromCharCodes(decrypted));
    final predictMessage = String.fromCharCodes(decrypted);
    expect(message, predictMessage);
  });

  test("Encrypt file", () async {
    String actual = "This is image base 64";
    final fileHandler = FileHandler();
    final encryptImage = fileHandler.encryption(actual, "passwordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpassword");
    debugPrint(encryptImage);
    final baseImage = fileHandler.decryption(encryptImage, "passwordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpassword");
    debugPrint(baseImage);
    expect(actual, baseImage);
  });
}
