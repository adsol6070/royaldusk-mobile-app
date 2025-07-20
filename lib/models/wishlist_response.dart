// models/wishlist_response.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:royaldusk_mobile_app/models/wishlist_item.dart';

part 'wishlist_response.g.dart'; 

@JsonSerializable()
class WishlistResponse {
  final List<WishlistItem> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const WishlistResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory WishlistResponse.fromJson(Map<String, dynamic> json) =>
      _$WishlistResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WishlistResponseToJson(this);
}
