import 'package:flutter/foundation.dart';

import 'package:hackathon_moralis/models/wallet_credential.dart';

import 'package:hackathon_moralis/utilities/asymmetic_encryption.dart';
import 'package:hackathon_moralis/utilities/eth.dart';
import 'package:hackathon_moralis/utilities/file_handler.dart';

import 'package:pinenacl/x25519.dart' show PrivateKey;

import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Get credential by bip32", () async {
    const actual = "0xFE2b19a3545f25420E3a5DAdf11b5582b5B3aBA8";
    final eth = Eth();
    WalletCredential walletCredential = eth.getCredential(
        "toward paper enemy brother man achieve coconut dad tent amateur advance copper");
    expect(actual, walletCredential.publicKey);
  });

  test("Encrypt ipfs key by pinenacl", () async {
    debugPrint('\n### Public Key Encryption - Box Example ###\n');
    AsymmetricEncryption asymmetricEncryption = AsymmetricEncryption();
    const message =
        "There is no conspiracy out there, but lack of the incentives to drive the people towards the answers.";
    // Generate Bob's private key, which must be kept secret
    final skbob =
        asymmetricEncryption.generatePrivateKeyFromWalletPrivate("test");
    // Bob's public key can be given to anyone wishing to send
    // Bob an encrypted message
    final pkbob = skbob.publicKey;
    // Alice does the same and then Alice and Bob exchange public keys
    final skalice = PrivateKey.generate();
    final pkalice = skalice.publicKey;
    String encrypted =
        asymmetricEncryption.encryptData(message, skbob, pkalice);
    // Decrypt our message, an exception will be raised if the encryption was
    // tampered with or there was otherwise an error.
    final decrypted =
        asymmetricEncryption.decryptData(encrypted, skalice, pkbob);
    expect(message, decrypted);
  });

  test("Encrypt file", () async {
    String actual = "This is image base 64";
    final fileHandler = FileHandler();
    final encryptImage = fileHandler.encryption(actual,
        "passwordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpassword");
    debugPrint(encryptImage);
    final baseImage = fileHandler.decryption(encryptImage,
        "passwordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpassword");
    debugPrint(baseImage);
    expect(actual, baseImage);
  });
}
