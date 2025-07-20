// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistResponse _$WishlistResponseFromJson(Map<String, dynamic> json) =>
    WishlistResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => WishlistItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );

Map<String, dynamic> _$WishlistResponseToJson(WishlistResponse instance) =>
    <String, dynamic>{
      'items': instance.items,
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
      'totalPages': instance.totalPages,
    };
