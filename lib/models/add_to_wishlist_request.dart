// models/add_to_wishlist_request.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:royaldusk_mobile_app/models/wishlist_item.dart';

part 'add_to_wishlist_request.g.dart';

@JsonSerializable()
class AddToWishlistRequest {
  final WishlistItemType itemType;
  final String? packageId;
  final String? tourId;
  final String? notes;
  final WishlistPriority? priority;

  const AddToWishlistRequest({
    required this.itemType,
    this.packageId,
    this.tourId,
    this.notes,
    this.priority,
  });

  factory AddToWishlistRequest.forPackage({
    required String packageId,
    String? notes,
    WishlistPriority? priority,
  }) {
    return AddToWishlistRequest(
      itemType: WishlistItemType.Package,
      packageId: packageId,
      notes: notes,
      priority: priority ?? WishlistPriority.Medium,
    );
  }

  factory AddToWishlistRequest.forTour({
    required String tourId,
    String? notes,
    WishlistPriority? priority,
  }) {
    return AddToWishlistRequest(
      itemType: WishlistItemType.Tour,
      tourId: tourId,
      notes: notes,
      priority: priority ?? WishlistPriority.Medium,
    );
  }

  factory AddToWishlistRequest.fromJson(Map<String, dynamic> json) =>
      _$AddToWishlistRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddToWishlistRequestToJson(this);
}
