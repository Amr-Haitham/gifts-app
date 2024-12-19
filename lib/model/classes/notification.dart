
import 'package:json_annotation/json_annotation.dart';
part 'notification.g.dart';




@JsonSerializable()
class Notification {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;

  Notification(
      {required this.id,
      required this.title,
      required this.body,
      required this.createdAt});

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json); 

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
