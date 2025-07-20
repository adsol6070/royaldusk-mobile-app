// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_count.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistCount _$WishlistCountFromJson(Map<String, dynamic> json) =>
    WishlistCount(
      total: (json['total'] as num).toInt(),
      packages: (json['packages'] as num).toInt(),
      tours: (json['tours'] as num).toInt(),
      byPriority: WishlistPriorityCount.fromJson(
          json['byPriority'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WishlistCountToJson(WishlistCount instance) =>
    <String, dynamic>{
      'total': instance.total,
      'packages': instance.packages,
      'tours': instance.tours,
      'byPriority': instance.byPriority,
    };

WishlistPriorityCount _$WishlistPriorityCountFromJson(
        Map<String, dynamic> json) =>
    WishlistPriorityCount(
      low: (json['low'] as num).toInt(),
      medium: (json['medium'] as num).toInt(),
      high: (json['high'] as num).toInt(),
    );

Map<String, dynamic> _$WishlistPriorityCountToJson(
        WishlistPriorityCount instance) =>
    <String, dynamic>{
      'low': instance.low,
      'medium': instance.medium,
      'high': instance.high,
    };
