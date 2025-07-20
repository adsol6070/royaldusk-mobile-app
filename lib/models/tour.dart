import 'package:json_annotation/json_annotation.dart';

part 'tour.g.dart';

@JsonSerializable(explicitToJson: true)
class Tour {
  final String id;
  final String name;
  final String slug;
  final String description;

  @JsonKey(fromJson: Tour._parsePrice, toJson: Tour._priceToJson)
  final double price;

  final String tourAvailability;
  final String tag;
  final String imageUrl;
  final String categoryId;
  final String locationId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final TourCategory category;
  final TourLocation location;

  Tour({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    required this.tourAvailability,
    required this.tag,
    required this.imageUrl,
    required this.categoryId,
    required this.locationId,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.location,
  });

  factory Tour.fromJson(Map<String, dynamic> json) => _$TourFromJson(json);
  Map<String, dynamic> toJson() => _$TourToJson(this);

  static double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is double) return price;
    if (price is int) return price.toDouble();
    if (price is String) {
      try {
        return double.parse(price);
      } catch (_) {
        return 0.0;
      }
    }
    return 0.0;
  }

  static dynamic _priceToJson(double price) => price;
}

@JsonSerializable()
class TourCategory {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  TourCategory({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TourCategory.fromJson(Map<String, dynamic> json) =>
      _$TourCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$TourCategoryToJson(this);
}

@JsonSerializable()
class TourLocation {
  final String id;
  final String name;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  TourLocation({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TourLocation.fromJson(Map<String, dynamic> json) =>
      _$TourLocationFromJson(json);
  Map<String, dynamic> toJson() => _$TourLocationToJson(this);
}
