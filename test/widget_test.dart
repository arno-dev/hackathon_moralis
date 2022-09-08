import 'package:hackathon_moralis/models/wallet_credential.dart';

import 'package:hackathon_moralis/utilities/asymmetic_encryption.dart';
import 'package:hackathon_moralis/utilities/eth.dart';
import 'package:hackathon_moralis/utilities/file_handler.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:pinenacl/api/authenticated_encryption.dart';

void main() {
  group("flow of authentication", () {
    const actual = "0xFE2b19a3545f25420E3a5DAdf11b5582b5B3aBA8";
    late String mnemonic;
    late Eth eth;
    late String privateKey;
    late String wrongPrivateKey;
    setUpAll(() {
      eth = Eth();
      privateKey =
          "1ca5e91ac36132867c3092f68fa794c19721f166c3188aa23fa739e5d30b71bf";
      wrongPrivateKey = "34850934dfs859085as90384905890f38590fsedf38";
      mnemonic =
          "toward paper enemy brother man achieve coconut dad tent amateur advance copper";
    });

    test("User puts a random private key", () {
      try {
        eth.getCredentialFromPrivate(wrongPrivateKey);
      } on FormatException catch (e) {
        expect(e.message, "Invalid input length, must be even.",
            reason: "The private is in wrong format.");
      }
    });
    test("Get credential from private key", () {
      final credential = eth.getCredentialFromPrivate(privateKey);
      expect(actual, credential.address);
    });

    test("Get credential by mnemonic", () async {
      WalletCredential walletCredential = eth.getCredential(mnemonic);
      expect(actual, walletCredential.address);
    });
  });

  group("Entire flow of sharing encrypted IPFS file and decryption", () {
    late AsymmetricEncryption asymmetricEncryption;
    late String mnemonic1;
    late String mnemonic2;
    late String mnemonic3;
    final eth = Eth();
    late WalletCredential walletCredential1;
    late WalletCredential walletCredential2;
    late WalletCredential walletCredential3 = eth.getCredential(mnemonic3);
    late PrivateKey skWallet1;
    late PrivateKey skWallet2;
    late PrivateKey skWallet3;
    late FileHandler fileHandler;

    setUpAll(() {
      asymmetricEncryption = AsymmetricEncryption();
      // Generate two wallet
      mnemonic1 =
          "toward paper enemy brother man achieve coconut dad tent amateur advance copper";
      mnemonic2 =
          "copper paper enemy brother man achieve coconut dad tent amateur advance toward";
      mnemonic3 =
          "copper paper enemy man brother achieve coconut dad tent amateur advance toward";
      walletCredential1 = eth.getCredential(mnemonic1);
      walletCredential2 = eth.getCredential(mnemonic2);
      walletCredential3 = eth.getCredential(mnemonic3);

      // Generate a private key as it will be used as IPFS key from Wallet 1
      skWallet1 = asymmetricEncryption
          .generatePrivateKeyFromWalletPrivate(walletCredential1.privateKey);

      // Generate a private key as it will be used as IPFS key from Wallet 2
      skWallet2 = asymmetricEncryption
          .generatePrivateKeyFromWalletPrivate(walletCredential2.privateKey);

      // Generate a private key as it will be used as IPFS key from Wallet 3
      skWallet3 = asymmetricEncryption
          .generatePrivateKeyFromWalletPrivate(walletCredential3.privateKey);

      // For handling file
      fileHandler = FileHandler();
    });

    group("Test integrity of the keys", () {
      setUpAll(() {});
      test("if address are expected from mneumonics", () {
        expect("0xFE2b19a3545f25420E3a5DAdf11b5582b5B3aBA8",
            walletCredential1.address);
        expect("0xAf306F6998FA805797FE60901D3358f18eBA58BC",
            walletCredential2.address);
        expect("0xd477b5E16473793909DD84f559e17a794060e644",
            walletCredential3.address);
      });

      test("Sharing key from wallet 1 to wallet 2", () {
        String secretMessageFromOnetoTwo = "Secret message from Wallet 1 to 2";
        String encryptedMessageFromOnetoTwo = asymmetricEncryption.encryptData(
            secretMessageFromOnetoTwo, skWallet1, skWallet2.publicKey);

        String decipherMessageWithWalletOne = asymmetricEncryption.decryptData(
            encryptedMessageFromOnetoTwo, skWallet2, skWallet1.publicKey);

        expect(decipherMessageWithWalletOne, secretMessageFromOnetoTwo,
            reason: "Wallet 2 should be able to decipher secret message");

        try {
          asymmetricEncryption.decryptData(
              encryptedMessageFromOnetoTwo, skWallet2, skWallet3.publicKey);
        } catch (e) {
          expect(e,
              "The message is forged or malformed or the shared secret is invalid",
              reason:
                  "Wallet 3 shouldn't be able to decipher the secret message");
        }
      });

      test("Encrypting IPFS file", () {
        String actual = "This is image base 64";
        String secretMessageFromOnetoTwo = "Secret message from Wallet 1 to 2";

        // This will be shared / retrieved along the future encrypted IPFS File
        String encryptedMessageFromOnetoTwo = asymmetricEncryption.encryptData(
            secretMessageFromOnetoTwo, skWallet1, skWallet2.publicKey);

        fileHandler = FileHandler();
        final encryptImage =
            fileHandler.encryption(actual, secretMessageFromOnetoTwo);

        expect(encryptImage.compareTo(actual) != 0, true,
            reason: "encrypted image and base image should be different now");

        // We can share the 'encryptedMessageFromOnetoTwo' safely, but only the destination public address can decipher
        String decipherMessageFromOnetoTwo = asymmetricEncryption.decryptData(
            encryptedMessageFromOnetoTwo, skWallet1, skWallet2.publicKey);

        expect(decipherMessageFromOnetoTwo, secretMessageFromOnetoTwo,
            reason: "decrypted key and secret message should be the same");

        final baseImage =
            fileHandler.decryption(encryptImage, decipherMessageFromOnetoTwo);
        expect(actual, baseImage);
      });
    });
  });
}
