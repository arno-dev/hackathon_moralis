import '../../domain/entities/alerts_payload.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alerts_payload_model.g.dart';
@JsonSerializable()
class AlertsPayloadModel extends AlertsPayload {
  final String origin;
  final String ipfsKey;
  final String? cid;
  final String? link;
  final String? createdAt;
  const AlertsPayloadModel({required this.origin, required this.ipfsKey,this.cid,this.link,this.createdAt})
      : super(origin, ipfsKey,cid,link,createdAt);
  factory AlertsPayloadModel.fromJson(Map<String, dynamic> json) =>
      _$AlertsPayloadModelFromJson(json);
  Map<String, dynamic> toJson() => _$AlertsPayloadModelToJson(this);
}
