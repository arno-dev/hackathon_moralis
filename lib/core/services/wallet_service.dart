import 'dart:convert';
import 'dart:typed_data';

import 'package:bip32/bip32.dart';
import 'package:hackathon_moralis/core/models/wallet_credential.dart';
import 'package:pointycastle/export.dart'
    show ECCurve_secp256k1, ECPoint, KeccakDigest;
import 'package:convert/convert.dart' show hex;

import 'package:bip39/bip39.dart' as bip39;
import 'package:web3dart/web3dart.dart';

class WalletService {
  WalletCredential getCredentialFromPrivate(String privateHex) {
    final ethPrivateKey = EthPrivateKey.fromHex(privateHex);
    final privateKey = hex.encode(ethPrivateKey.privateKey);
    final publicKeyBytes = ethPrivateKey.publicKey.getEncoded(true);
    final publicKey = hex.encode(publicKeyBytes);
    final address = ethereumAddressFromPublicKey(publicKeyBytes);
    return WalletCredential(privateKey, publicKey, address);
  }
  WalletCredential getCredential(String mnemonic) {
    final seedBytes = bip39.mnemonicToSeed(mnemonic);
    BIP32 node = BIP32.fromSeed(seedBytes);
    BIP32 child = node.derivePath("m/44'/60'/0'/0/0");
    final privateKey = hex.encode((child.privateKey ?? Uint8List(0)).toList());
    final publicKey = hex.encode(child.publicKey);
    final address = ethereumAddressFromPublicKey(child.publicKey);
    return WalletCredential(privateKey, publicKey, address);
  }

  String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  /// Derives an Ethereum address from a given public key.
  String ethereumAddressFromPublicKey(Uint8List publicKey) {
    final decompressedPubKey = decompressPublicKey(publicKey);
    final hash = KeccakDigest(256).process(decompressedPubKey.sublist(1));
    final address = hash.sublist(12, 32);

    return checksumEthereumAddress(hex.encode(address));
  }

  /// Converts an Ethereum address to a checksummed address (EIP-55).
  String checksumEthereumAddress(String address) {
    if (!isValidFormat(address)) {
      throw ArgumentError.value(address, "address", "invalid address");
    }

    final addr = strip0x(address).toLowerCase();
    final hash = ascii.encode(hex.encode(
      KeccakDigest(256).process(ascii.encode(addr)),
    ));

    var newAddr = "0x";

    for (var i = 0; i < addr.length; i++) {
      if (hash[i] >= 56) {
        newAddr += addr[i].toUpperCase();
      } else {
        newAddr += addr[i];
      }
    }

    return newAddr;
  }

  /// Returns whether a given Ethereum address is valid.
  bool isValidEthereumAddress(String address) {
    if (!isValidFormat(address)) {
      return false;
    }

    final addr = strip0x(address);
    // if all lowercase or all uppercase, as in checksum is not present
    if (RegExp(r"^[0-9a-f]{40}$").hasMatch(addr) ||
        RegExp(r"^[0-9A-F]{40}$").hasMatch(addr)) {
      return true;
    }

    String checksumAddress;
    try {
      checksumAddress = checksumEthereumAddress(address);
    } catch (err) {
      return false;
    }

    return addr == checksumAddress.substring(2);
  }

  String strip0x(String address) {
    if (address.startsWith("0x") || address.startsWith("0X")) {
      return address.substring(2);
    }
    return address;
  }

  bool isValidFormat(String address) {
    return RegExp(r"^[0-9a-fA-F]{40}$").hasMatch(strip0x(address));
  }

  Uint8List decompressPublicKey(Uint8List publicKey) {
    final length = publicKey.length;
    final firstByte = publicKey[0];

    if ((length != 33 && length != 65) || firstByte < 2 || firstByte > 4) {
      throw ArgumentError.value(publicKey, "publicKey", "invalid public key");
    }

    final ECPoint? ecPublicKey =
        ECCurve_secp256k1().curve.decodePoint(publicKey);
    return ecPublicKey!.getEncoded(false);
  }
}
