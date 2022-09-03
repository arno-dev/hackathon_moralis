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
    String mnemonic =
        "toward paper enemy brother man achieve coconut dad tent amateur advance copper";
    final eth = Eth();
    WalletCredential walletCredential = eth.getCredential(mnemonic);
    expect(actual, walletCredential.publicKey);
  });

  group("Encryption of IPFS", () {
    AsymmetricEncryption asymmetricEncryption = AsymmetricEncryption();
    const walletPrivateKey = "alkdjfj43iojklflkasdjlfksj";
    String encrypted = "";
    const message =
        "There is no conspiracy out there, but lack of the incentives to drive the people towards the answers.";

    // Generate Bob's private key, which must be kept secret
    final skbob = asymmetricEncryption
        .generatePrivateKeyFromWalletPrivate(walletPrivateKey);
    // Bob's public key can be given to anyone wishing to send
    // Bob an encrypted message
    final pkbob = skbob.publicKey;
    // Alice does the same and then Alice and Bob exchange public keys
    final skalice = PrivateKey.generate();
    final pkalice = skalice.publicKey;
    test("Encrypt IPFS key by pinenacl", () {
      String bobShareKey =
          asymmetricEncryption.encryptData(message, skbob, pkalice);
      encrypted = bobShareKey;
      expect(encrypted, bobShareKey);
    });

    test("Decrypt IPFS key by pinenacl", () {
      final decrypted =
          asymmetricEncryption.decryptData(encrypted, skalice, pkbob);
      expect(message, decrypted);
    });
  });

  group("Encrypt Content IPFS", () {
    String actual = "This is image base 64";
    String password =
        "passwordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpassword";
    final fileHandler = FileHandler();
    String encryptedImage = "";
    test("Start Encrypt Content", () {
      final encryptImage = fileHandler.encryption(actual, password);
      encryptedImage = encryptImage;
      expect(encryptedImage, encryptImage);
    });

    test("Get Content from IPFS", () {
      final baseImage = fileHandler.decryption(encryptedImage, password);
      expect(actual, baseImage);
    });
  });
}
