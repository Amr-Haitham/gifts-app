// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      id: json['id'] as String,
      name: json['name'] as String,
      date: timestampFromJson(json['date'] as Timestamp),
      location: json['location'] as String,
      description: json['description'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'date': timestampToJson(instance.date),
      'location': instance.location,
      'description': instance.description,
      'userId': instance.userId,
    };
