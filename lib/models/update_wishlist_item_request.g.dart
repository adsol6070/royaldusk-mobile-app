// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_wishlist_item_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateWishlistItemRequest _$UpdateWishlistItemRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateWishlistItemRequest(
      notes: json['notes'] as String?,
      priority:
          $enumDecodeNullable(_$WishlistPriorityEnumMap, json['priority']),
      isNotified: json['isNotified'] as bool?,
    );

Map<String, dynamic> _$UpdateWishlistItemRequestToJson(
        UpdateWishlistItemRequest instance) =>
    <String, dynamic>{
      'notes': instance.notes,
      'priority': _$WishlistPriorityEnumMap[instance.priority],
      'isNotified': instance.isNotified,
    };

const _$WishlistPriorityEnumMap = {
  WishlistPriority.Low: 'Low',
  WishlistPriority.Medium: 'Medium',
  WishlistPriority.High: 'High',
};
