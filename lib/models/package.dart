import 'package:json_annotation/json_annotation.dart';

part 'package.g.dart';

@JsonSerializable(explicitToJson: true)
class Package {
  final String id;
  final String name;
  final String slug;
  final String description;
  final int review;
  final String currency;
  final String importantInfo;
  final String locationId;
  final double price;
  final int duration;
  final String availability;
  final String hotels;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String categoryID;
  final String policyID;
  final String tag;
  final Category category;
  final Location location;
  final List<Feature> features;
  final List<Itinerary> itineraries;
  final Policy policy;
  final List<Inclusion> inclusions;
  final List<Exclusion> exclusions;

  Package({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.review,
    required this.currency,
    required this.importantInfo,
    required this.locationId,
    required this.price,
    required this.duration,
    required this.availability,
    required this.hotels,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryID,
    required this.policyID,
    required this.tag,
    required this.category,
    required this.location,
    required this.features,
    required this.itineraries,
    required this.policy,
    required this.inclusions,
    required this.exclusions,
  });

  factory Package.fromJson(Map<String, dynamic> json) =>
      _$PackageFromJson(json);
  Map<String, dynamic> toJson() => _$PackageToJson(this);
}

@JsonSerializable()
class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class Location {
  final String id;
  final String name;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Location({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

@JsonSerializable()
class Feature {
  final String id;
  final String name;

  Feature({required this.id, required this.name});

  factory Feature.fromJson(Map<String, dynamic> json) =>
      _$FeatureFromJson(json);
  Map<String, dynamic> toJson() => _$FeatureToJson(this);
}

@JsonSerializable()
class Itinerary {
  final String id;
  final String title;
  final String description;

  Itinerary({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) =>
      _$ItineraryFromJson(json);
  Map<String, dynamic> toJson() => _$ItineraryToJson(this);
}

@JsonSerializable()
class Policy {
  final String id;
  final String bookingPolicy;
  final String cancellationPolicy;
  final String paymentTerms;
  final String visaDetail;

  Policy({
    required this.id,
    required this.bookingPolicy,
    required this.cancellationPolicy,
    required this.paymentTerms,
    required this.visaDetail,
  });

  factory Policy.fromJson(Map<String, dynamic> json) => _$PolicyFromJson(json);
  Map<String, dynamic> toJson() => _$PolicyToJson(this);
}

@JsonSerializable()
class Inclusion {
  final String id;
  final String name;

  Inclusion({required this.id, required this.name});

  factory Inclusion.fromJson(Map<String, dynamic> json) =>
      _$InclusionFromJson(json);
  Map<String, dynamic> toJson() => _$InclusionToJson(this);
}

@JsonSerializable()
class Exclusion {
  final String id;
  final String name;

  Exclusion({required this.id, required this.name});

  factory Exclusion.fromJson(Map<String, dynamic> json) =>
      _$ExclusionFromJson(json);
  Map<String, dynamic> toJson() => _$ExclusionToJson(this);
}
