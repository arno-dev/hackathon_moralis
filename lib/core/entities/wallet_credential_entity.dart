import 'package:equatable/equatable.dart';

class WalletCredentialEntity extends Equatable {
  final String privateKeyEntity;
  final String publicKeyEntity;
  final String addressEntity;

 const  WalletCredentialEntity(this.privateKeyEntity, this.publicKeyEntity, this.addressEntity);
 
  @override
  List<Object?> get props => [privateKeyEntity, publicKeyEntity, addressEntity];
}