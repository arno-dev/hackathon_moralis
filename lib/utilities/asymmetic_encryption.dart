import 'package:bip39/bip39.dart' as bip39;
import "package:crypto/crypto.dart" show sha256;

import 'package:pinenacl/x25519.dart' show Box, PrivateKey, EncryptedMessage;
import 'package:pinenacl/api.dart';
import 'package:convert/convert.dart';



class AsymmetricEncryption {
  /// this method will convert
  PrivateKey generatePrivateKeyFromSeed(String mnemonic) {
    final seedBytes = bip39.mnemonicToSeed(mnemonic);
    final digest = sha256.convert(seedBytes.toList());
    // Generate private key, which must be kept secret
    final privateKey = PrivateKey.fromSeed(Uint8List.fromList(digest.bytes));
    return privateKey;
  }

  /// this method will create encryption private key from user's walletPrivateKey
  PrivateKey generatePrivateKeyFromWalletPrivate(String walletPrivateKey) {
    final seedBytes = walletPrivateKey.codeUnits;
    final digest = sha256.convert(seedBytes);
    // Generate private key, which must be kept secret
    final privateKey = PrivateKey.fromSeed(Uint8List.fromList(digest.bytes));
    return privateKey;
  }

  /// encryptData is message that will encrypt.
  /// sourcePrivateKey is your private to encrypt message.
  /// destinationPublic is other user publickey that you want to send to.
  /// this method will return the hex that come from encrypt message
  String encryptData(String data, AsymmetricPrivateKey sourcePrivateKey,
      AsymmetricPublicKey destinationPublic) {
    final box =
        Box(myPrivateKey: sourcePrivateKey, theirPublicKey: destinationPublic);
    final encryptedAsList =
        box.encrypt(Uint8List.fromList(data.codeUnits)).sublist(0);
    Uint8List uint8list = encryptedAsList.asTypedList;
    return hex.encode(uint8list.toList());
  }

  /// encryptData is shared string from owner data
  /// sourcePrivateKey is your private to decrypt message
  /// destinationPublic is owner public
  /// this method will return real message
  String decryptData(String encryptData, AsymmetricPrivateKey sourcePrivateKey,
      AsymmetricPublicKey destinationPublic) {
    final box =
        Box(myPrivateKey: sourcePrivateKey, theirPublicKey: destinationPublic);
    final decrypted = box.decrypt(
        EncryptedMessage.fromList(Uint8List.fromList(hex.decode(encryptData))));
    final predictMessage = String.fromCharCodes(decrypted);
    return predictMessage;
  }
}
