// models/update_wishlist_item_request.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:royaldusk_mobile_app/models/wishlist_item.dart';

part 'update_wishlist_item_request.g.dart';  

@JsonSerializable()
class UpdateWishlistItemRequest {
  final String? notes;
  final WishlistPriority? priority;
  final bool? isNotified;

  const UpdateWishlistItemRequest({
    this.notes,
    this.priority,
    this.isNotified,
  });

  factory UpdateWishlistItemRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateWishlistItemRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateWishlistItemRequestToJson(this);
}