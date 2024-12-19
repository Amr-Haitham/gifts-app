// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friend _$FriendFromJson(Map<String, dynamic> json) => Friend(
      userId: json['userId'] as String,
      id: json['id'] as String,
      friendId: json['friendId'] as String,
    );

Map<String, dynamic> _$FriendToJson(Friend instance) => <String, dynamic>{
      'userId': instance.userId,
      'friendId': instance.friendId,
      'id': instance.id,
    };
