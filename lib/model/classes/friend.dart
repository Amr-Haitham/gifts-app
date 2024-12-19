
import 'package:json_annotation/json_annotation.dart';
part 'friend.g.dart';
@JsonSerializable()
class Friend {
  final String userId;
  final String friendId;
  final String id;

  Friend({
    required this.userId,
    required this.id,
    required this.friendId,
  });

  // Convert Friend to Map
  Map<String, dynamic> toJson() => _$FriendToJson(this);

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);

}
