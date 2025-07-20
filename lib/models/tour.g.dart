// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tour _$TourFromJson(Map<String, dynamic> json) => Tour(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String,
      price: Tour._parsePrice(json['price']),
      tourAvailability: json['tourAvailability'] as String,
      tag: json['tag'] as String,
      imageUrl: json['imageUrl'] as String,
      categoryId: json['categoryId'] as String,
      locationId: json['locationId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      category: TourCategory.fromJson(json['category'] as Map<String, dynamic>),
      location: TourLocation.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TourToJson(Tour instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'price': Tour._priceToJson(instance.price),
      'tourAvailability': instance.tourAvailability,
      'tag': instance.tag,
      'imageUrl': instance.imageUrl,
      'categoryId': instance.categoryId,
      'locationId': instance.locationId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'category': instance.category.toJson(),
      'location': instance.location.toJson(),
    };

TourCategory _$TourCategoryFromJson(Map<String, dynamic> json) => TourCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TourCategoryToJson(TourCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

TourLocation _$TourLocationFromJson(Map<String, dynamic> json) => TourLocation(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TourLocationToJson(TourLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
