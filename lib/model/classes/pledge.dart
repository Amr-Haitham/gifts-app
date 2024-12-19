import 'package:json_annotation/json_annotation.dart';
part 'pledge.g.dart';

@JsonSerializable()
class Pledge {
  String id;
  String eventId;
  String userId;
  String giftId;
  String giftOwnerId;
  bool isFulfilled;
  Pledge({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.giftId,
    required this.isFulfilled,
    required this.giftOwnerId,
  });

  factory Pledge.fromJson(Map<String, dynamic> json) => _$PledgeFromJson(json);

  Map<String, dynamic> toJson() => _$PledgeToJson(this);
}
