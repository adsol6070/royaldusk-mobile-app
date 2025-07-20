// models/wishlist_check_response.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:royaldusk_mobile_app/models/wishlist_item.dart';

part 'wishlist_check_response.g.dart';  

@JsonSerializable()
class WishlistCheckResponse {
  final bool inWishlist;
  final WishlistItem? item;

  const WishlistCheckResponse({
    required this.inWishlist,
    this.item,
  });

  factory WishlistCheckResponse.fromJson(Map<String, dynamic> json) =>
      _$WishlistCheckResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WishlistCheckResponseToJson(this);
}