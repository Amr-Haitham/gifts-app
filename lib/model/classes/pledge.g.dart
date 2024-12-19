// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pledge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pledge _$PledgeFromJson(Map<String, dynamic> json) => Pledge(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      userId: json['userId'] as String,
      giftId: json['giftId'] as String,
      isFulfilled: json['isFulfilled'] as bool,
      giftOwnerId: json['giftOwnerId'] as String,
    );

Map<String, dynamic> _$PledgeToJson(Pledge instance) => <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'userId': instance.userId,
      'giftId': instance.giftId,
      'giftOwnerId': instance.giftOwnerId,
      'isFulfilled': instance.isFulfilled,
    };
