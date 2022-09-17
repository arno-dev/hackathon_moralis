import 'package:d_box/core/models/wallet_credential.dart';
import 'package:d_box/core/services/asymmetic_encryption.dart';
import 'package:d_box/core/services/wallet_service.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:pinenacl/api/authenticated_encryption.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([http.Client, FilePicker, ImagePicker])
void main() {
  group("flow of authentication", () {
    const actual = "0xFE2b19a3545f25420E3a5DAdf11b5582b5B3aBA8";
    late String mnemonic;
    late WalletService walletService;
    late String privateKey;
    late String wrongPrivateKey;
    setUpAll(() {
      walletService = WalletService();
      // wallet1 private key a221d61e1b8565b31e70a59d847fdf5c562298b866582b369e7ecbb4da275ac3
      // wallet1 address 0x219F0E14E0E4Cfb1f3a8eA54c0D1CCeD55ED7b7B
      privateKey =
          "1ca5e91ac36132867c3092f68fa794c19721f166c3188aa23fa739e5d30b71bf";
      wrongPrivateKey = "34850934dfs859085as90384905890f38590fsedf38";
      mnemonic =
          "toward paper enemy brother man achieve coconut dad tent amateur advance copper";
    });

    test("User puts a random private key", () {
      try {
        walletService.getCredentialFromPrivate(wrongPrivateKey);
      } on FormatException catch (e) {
        expect(e.message, "Invalid input length, must be even.",
            reason: "The private is in wrong format.");
      }
    });
    test("Get credential from private key", () {
      final credential = walletService.getCredentialFromPrivate(privateKey);
      expect(actual, credential.address);
    });

    test("Get credential by mnemonic", () async {
      WalletCredential walletCredential = walletService.getCredential(mnemonic);
      expect(actual, walletCredential.address);
    });
  });

  group("Entire flow of sharing encrypted IPFS file and decryption", () {
    late AsymmetricEncryption asymmetricEncryption;
    late String mnemonic1;
    late String mnemonic2;
    late String mnemonic3;
    final walletService = WalletService();
    late WalletCredential walletCredential1;
    late WalletCredential walletCredential2;
    late WalletCredential walletCredential3 =
        walletService.getCredential(mnemonic3);
    late PrivateKey skWallet1;
    late PrivateKey skWallet2;
    late PrivateKey skWallet3;

    setUpAll(() {
      asymmetricEncryption = AsymmetricEncryption();
      // Generate two wallet
      mnemonic1 =
          "toward paper enemy brother man achieve coconut dad tent amateur advance copper";
      mnemonic2 =
          "copper paper enemy brother man achieve coconut dad tent amateur advance toward";
      mnemonic3 =
          "copper paper enemy man brother achieve coconut dad tent amateur advance toward";
      walletCredential1 = walletService.getCredential(mnemonic1);
      walletCredential2 = walletService.getCredential(mnemonic2);
      walletCredential3 = walletService.getCredential(mnemonic3);

      // Generate a private key as it will be used as IPFS key from Wallet 1
      skWallet1 = asymmetricEncryption
          .generatePrivateKeyFromWalletPrivate(walletCredential1.privateKey);

      // Generate a private key as it will be used as IPFS key from Wallet 2
      skWallet2 = asymmetricEncryption
          .generatePrivateKeyFromWalletPrivate(walletCredential2.privateKey);

      // Generate a private key as it will be used as IPFS key from Wallet 3
      skWallet3 = asymmetricEncryption
          .generatePrivateKeyFromWalletPrivate(walletCredential3.privateKey);

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

      test("Encrypting IPFS file by assymetric key", () {
        // file as base64
        String fileContent = "a file content";

        // in case you don't want to share image to other
        String myEncryptedContent = asymmetricEncryption.encryptData(
            fileContent, skWallet1, skWallet1.publicKey);

        String decipherContent = asymmetricEncryption.decryptData(
            myEncryptedContent, skWallet1, skWallet1.publicKey);

        expect(decipherContent, fileContent,
            reason: "You should get a raw content");

        // if other user try to access
        try {
          asymmetricEncryption.decryptData(
              myEncryptedContent, skWallet3, skWallet1.publicKey);
        } catch (e) {
          expect(e,
              "The message is forged or malformed or the shared secret is invalid",
              reason:
                  "Wallet 3 shouldn't be able to decipher the secret message");
        }

        // in case you want to share content to wallet2
        String wallet2EncryptedContent = asymmetricEncryption.encryptData(
            fileContent, skWallet1, skWallet2.publicKey);

        String wallet2DecipherContent = asymmetricEncryption.decryptData(
            wallet2EncryptedContent, skWallet2, skWallet1.publicKey);

        expect(wallet2DecipherContent, fileContent,
            reason: "You should get a raw content");
        // if other user try to access
        try {
          asymmetricEncryption.decryptData(
              wallet2EncryptedContent, skWallet3, skWallet1.publicKey);
        } catch (e) {
          expect(e,
              "The message is forged or malformed or the shared secret is invalid",
              reason:
                  "Wallet 3 shouldn't be able to decipher the secret message");
        }
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
    });
  });
}
