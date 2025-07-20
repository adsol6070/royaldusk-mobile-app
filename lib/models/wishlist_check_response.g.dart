// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_check_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistCheckResponse _$WishlistCheckResponseFromJson(
        Map<String, dynamic> json) =>
    WishlistCheckResponse(
      inWishlist: json['inWishlist'] as bool,
      item: json['item'] == null
          ? null
          : WishlistItem.fromJson(json['item'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WishlistCheckResponseToJson(
        WishlistCheckResponse instance) =>
    <String, dynamic>{
      'inWishlist': instance.inWishlist,
      'item': instance.item,
    };
