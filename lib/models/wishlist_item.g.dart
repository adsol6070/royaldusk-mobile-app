// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistItem _$WishlistItemFromJson(Map<String, dynamic> json) => WishlistItem(
      id: json['id'] as String,
      userId: json['userId'] as String,
      itemType: $enumDecode(_$WishlistItemTypeEnumMap, json['itemType']),
      packageId: json['packageId'] as String?,
      tourId: json['tourId'] as String?,
      notes: json['notes'] as String?,
      priority: $enumDecode(_$WishlistPriorityEnumMap, json['priority']),
      isNotified: json['isNotified'] as bool,
      notificationsSent: (json['notificationsSent'] as num).toInt(),
      lastViewedAt: json['lastViewedAt'] == null
          ? null
          : DateTime.parse(json['lastViewedAt'] as String),
      priceWhenAdded: (json['priceWhenAdded'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      package: json['package'] == null
          ? null
          : Package.fromJson(json['package'] as Map<String, dynamic>),
      tour: json['tour'] == null
          ? null
          : Tour.fromJson(json['tour'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WishlistItemToJson(WishlistItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'itemType': _$WishlistItemTypeEnumMap[instance.itemType]!,
      'packageId': instance.packageId,
      'tourId': instance.tourId,
      'notes': instance.notes,
      'priority': _$WishlistPriorityEnumMap[instance.priority]!,
      'isNotified': instance.isNotified,
      'notificationsSent': instance.notificationsSent,
      'lastViewedAt': instance.lastViewedAt?.toIso8601String(),
      'priceWhenAdded': instance.priceWhenAdded,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'package': instance.package,
      'tour': instance.tour,
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
