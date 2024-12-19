import 'package:json_annotation/json_annotation.dart';
part 'gift.g.dart';

enum GiftStatus { pledged, unpledged, done }



@JsonSerializable()
class Gift {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final GiftStatus status;
  final String eventId;
  final String? imageUrl;

  Gift({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.status,
    required this.eventId,
    required this.imageUrl
  });
      Map<String, dynamic> toJson() => _$GiftToJson(this);
  factory Gift.fromJson(Map<String, dynamic> json) => _$GiftFromJson(json);


}