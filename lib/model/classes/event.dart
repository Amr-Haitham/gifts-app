import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

Timestamp timestampToJson(Timestamp dateTime) => dateTime;
Timestamp timestampFromJson(Timestamp dateTime) => dateTime;

@JsonSerializable()
class Event {
  final String id;
  final String name;
  @JsonKey(
    fromJson: timestampFromJson,
    toJson: timestampToJson
  )
  final Timestamp date;
  final String location;
  final String description;
  final String userId;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.description,
    required this.userId,
  });

    Map<String, dynamic> toJson() => _$EventToJson(this);

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
