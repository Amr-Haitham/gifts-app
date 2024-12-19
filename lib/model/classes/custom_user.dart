import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
part 'custom_user.g.dart';

@JsonSerializable()
class CustomUser {
  String id;
  String name;
  String email;
  String phoneNumber;
  String? imageUrl;
  DateTime joinDate;
  String? fcmToken;
  CustomUser(
      {required this.id,
      required this.joinDate,
      required this.name,
      required this.email,
      required this.phoneNumber,
      required this.imageUrl,
      required this.fcmToken});

  Map<String, dynamic> toJson() => _$CustomUserToJson(this);

  factory CustomUser.fromJson(Map<String, dynamic> json) =>
      _$CustomUserFromJson(json);
}
