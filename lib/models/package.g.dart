// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Package _$PackageFromJson(Map<String, dynamic> json) => Package(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String,
      review: (json['review'] as num).toInt(),
      currency: json['currency'] as String,
      importantInfo: json['importantInfo'] as String,
      locationId: json['locationId'] as String,
      price: (json['price'] as num).toDouble(),
      duration: (json['duration'] as num).toInt(),
      availability: json['availability'] as String,
      hotels: json['hotels'] as String,
      imageUrl: json['imageUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      categoryID: json['categoryID'] as String,
      policyID: json['policyID'] as String,
      tag: json['tag'] as String,
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      features: (json['features'] as List<dynamic>)
          .map((e) => Feature.fromJson(e as Map<String, dynamic>))
          .toList(),
      itineraries: (json['itineraries'] as List<dynamic>)
          .map((e) => Itinerary.fromJson(e as Map<String, dynamic>))
          .toList(),
      policy: Policy.fromJson(json['policy'] as Map<String, dynamic>),
      inclusions: (json['inclusions'] as List<dynamic>)
          .map((e) => Inclusion.fromJson(e as Map<String, dynamic>))
          .toList(),
      exclusions: (json['exclusions'] as List<dynamic>)
          .map((e) => Exclusion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PackageToJson(Package instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'review': instance.review,
      'currency': instance.currency,
      'importantInfo': instance.importantInfo,
      'locationId': instance.locationId,
      'price': instance.price,
      'duration': instance.duration,
      'availability': instance.availability,
      'hotels': instance.hotels,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'categoryID': instance.categoryID,
      'policyID': instance.policyID,
      'tag': instance.tag,
      'category': instance.category.toJson(),
      'location': instance.location.toJson(),
      'features': instance.features.map((e) => e.toJson()).toList(),
      'itineraries': instance.itineraries.map((e) => e.toJson()).toList(),
      'policy': instance.policy.toJson(),
      'inclusions': instance.inclusions.map((e) => e.toJson()).toList(),
      'exclusions': instance.exclusions.map((e) => e.toJson()).toList(),
    };

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

Feature _$FeatureFromJson(Map<String, dynamic> json) => Feature(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$FeatureToJson(Feature instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

Itinerary _$ItineraryFromJson(Map<String, dynamic> json) => Itinerary(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$ItineraryToJson(Itinerary instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
    };

Policy _$PolicyFromJson(Map<String, dynamic> json) => Policy(
      id: json['id'] as String,
      bookingPolicy: json['bookingPolicy'] as String,
      cancellationPolicy: json['cancellationPolicy'] as String,
      paymentTerms: json['paymentTerms'] as String,
      visaDetail: json['visaDetail'] as String,
    );

Map<String, dynamic> _$PolicyToJson(Policy instance) => <String, dynamic>{
      'id': instance.id,
      'bookingPolicy': instance.bookingPolicy,
      'cancellationPolicy': instance.cancellationPolicy,
      'paymentTerms': instance.paymentTerms,
      'visaDetail': instance.visaDetail,
    };

Inclusion _$InclusionFromJson(Map<String, dynamic> json) => Inclusion(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$InclusionToJson(Inclusion instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

Exclusion _$ExclusionFromJson(Map<String, dynamic> json) => Exclusion(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ExclusionToJson(Exclusion instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
