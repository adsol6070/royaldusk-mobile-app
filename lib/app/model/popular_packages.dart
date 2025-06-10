class PopularPackage {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String importantInfo;
  final String imageUrl;
  final double price;
  final String currency;
  final int review;
  final int duration;
  final String availability;
  final String hotels;
  final String tag;
  final Location location;
  // final Category category;
  final Policy policy;
  final List<FeatureItem> features;
  final List<ItineraryItem> itineraries;
  final List<InclusionExclusionItem> inclusions;
  final List<InclusionExclusionItem> exclusions;

  PopularPackage({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.importantInfo,
    required this.imageUrl,
    required this.price,
    required this.currency,
    required this.review,
    required this.duration,
    required this.availability,
    required this.hotels,
    required this.tag,
    required this.location,
    // required this.category,
    required this.policy,
    required this.features,
    required this.itineraries,
    required this.inclusions,
    required this.exclusions,
  });

  factory PopularPackage.fromJson(Map<String, dynamic> json) {
    return PopularPackage(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      importantInfo: json['importantInfo'],
      imageUrl: json['imageUrl'],
      price: (json['price'] as num).toDouble(),
      currency: json['currency'],
      review: json['review'],
      duration: json['duration'],
      availability: json['availability'],
      hotels: json['hotels'],
      tag: json['tag'],
      location: Location.fromJson(json['location']),
      // category: Category.fromJson(json['category']),
      policy: Policy.fromJson(json['policy']),
      features: (json['features'] as List)
          .map((f) => FeatureItem.fromJson(f))
          .toList(),
      itineraries: (json['itineraries'] as List)
          .map((i) => ItineraryItem.fromJson(i))
          .toList(),
      inclusions: (json['inclusions'] as List)
          .map((i) => InclusionExclusionItem.fromJson(i))
          .toList(),
      exclusions: (json['exclusions'] as List)
          .map((e) => InclusionExclusionItem.fromJson(e))
          .toList(),
    );
  }
}

class Location {
  final String id;
  final String name;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;

  Location({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json['id'],
        name: json['name'],
        imageUrl: json['imageUrl'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
      );
}

// class Category {
//   final String id;
//   final String name;

//   Category({
//     required this.id,
//     required this.name,
//   });

//   factory Category.fromJson(Map<String, dynamic> json) => Category(
//         id: json['id'],
//         name: json['name'],
//       );
// }

class FeatureItem {
  final String id;
  final String name;

  FeatureItem({required this.id, required this.name});

  factory FeatureItem.fromJson(Map<String, dynamic> json) =>
      FeatureItem(id: json['id'], name: json['name']);
}

class ItineraryItem {
  final String id;
  final String title;
  final String description;

  ItineraryItem({
    required this.id,
    required this.title,
    required this.description,
  });

  factory ItineraryItem.fromJson(Map<String, dynamic> json) => ItineraryItem(
        id: json['id'],
        title: json['title'],
        description: json['description'],
      );
}

class InclusionExclusionItem {
  final String id;
  final String name;

  InclusionExclusionItem({required this.id, required this.name});

  factory InclusionExclusionItem.fromJson(Map<String, dynamic> json) =>
      InclusionExclusionItem(
        id: json['id'],
        name: json['name'],
      );
}

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

  factory Policy.fromJson(Map<String, dynamic> json) => Policy(
        id: json['id'],
        bookingPolicy: json['bookingPolicy'],
        cancellationPolicy: json['cancellationPolicy'],
        paymentTerms: json['paymentTerms'],
        visaDetail: json['visaDetail'],
      );
}
