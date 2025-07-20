// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_to_wishlist_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddToWishlistRequest _$AddToWishlistRequestFromJson(
        Map<String, dynamic> json) =>
    AddToWishlistRequest(
      itemType: $enumDecode(_$WishlistItemTypeEnumMap, json['itemType']),
      packageId: json['packageId'] as String?,
      tourId: json['tourId'] as String?,
      notes: json['notes'] as String?,
      priority:
          $enumDecodeNullable(_$WishlistPriorityEnumMap, json['priority']),
    );

Map<String, dynamic> _$AddToWishlistRequestToJson(
        AddToWishlistRequest instance) =>
    <String, dynamic>{
      'itemType': _$WishlistItemTypeEnumMap[instance.itemType]!,
      'packageId': instance.packageId,
      'tourId': instance.tourId,
      'notes': instance.notes,
      'priority': _$WishlistPriorityEnumMap[instance.priority],
    };

const _$WishlistItemTypeEnumMap = {
  WishlistItemType.Package: 'Package',
  WishlistItemType.Tour: 'Tour',
};

const _$WishlistPriorityEnumMap = {
  WishlistPriority.Low: 'Low',
  WishlistPriority.Medium: 'Medium',
  WishlistPriority.High: 'High',
};
