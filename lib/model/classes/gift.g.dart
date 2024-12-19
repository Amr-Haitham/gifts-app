// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gift _$GiftFromJson(Map<String, dynamic> json) => Gift(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      status: $enumDecode(_$GiftStatusEnumMap, json['status']),
      eventId: json['eventId'] as String,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$GiftToJson(Gift instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'price': instance.price,
      'status': _$GiftStatusEnumMap[instance.status]!,
      'eventId': instance.eventId,
      'imageUrl': instance.imageUrl,
    };

const _$GiftStatusEnumMap = {
  GiftStatus.pledged: 'pledged',
  GiftStatus.unpledged: 'unpledged',
  GiftStatus.done: 'done',
};
