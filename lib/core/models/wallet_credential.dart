import 'package:json_annotation/json_annotation.dart';

import '../entities/wallet_credential_entity.dart';
part 'wallet_credential.g.dart';
@JsonSerializable()
class WalletCredential extends WalletCredentialEntity {
  final String privateKey;
  final String publicKey;
  final String address;
  const WalletCredential(this.privateKey, this.publicKey, this.address) :
   super(privateKey , publicKey, address);

    factory WalletCredential.fromJson(Map<String, dynamic> json) =>
      _$WalletCredentialFromJson(json);
  Map<String, dynamic> toJson() => _$WalletCredentialToJson(this);
}