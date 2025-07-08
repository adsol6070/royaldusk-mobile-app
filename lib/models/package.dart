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

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      review: json['review'],
      currency: json['currency'],
      importantInfo: json['importantInfo'],
      locationId: json['locationId'],
      price: json['price'].toDouble(),
      duration: json['duration'],
      availability: json['availability'],
      hotels: json['hotels'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      categoryID: json['categoryID'],
      policyID: json['policyID'],
      tag: json['tag'],
      category: Category.fromJson(json['category']),
      location: Location.fromJson(json['location']),
      features: (json['features'] as List)
          .map((feature) => Feature.fromJson(feature))
          .toList(),
      itineraries: (json['itineraries'] as List)
          .map((itinerary) => Itinerary.fromJson(itinerary))
          .toList(),
      policy: Policy.fromJson(json['policy']),
      inclusions: (json['inclusions'] as List)
          .map((inclusion) => Inclusion.fromJson(inclusion))
          .toList(),
      exclusions: (json['exclusions'] as List)
          .map((exclusion) => Exclusion.fromJson(exclusion))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'review': review,
      'currency': currency,
      'importantInfo': importantInfo,
      'locationId': locationId,
      'price': price,
      'duration': duration,
      'availability': availability,
      'hotels': hotels,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'categoryID': categoryID,
      'policyID': policyID,
      'tag': tag,
      'category': category.toJson(),
      'location': location.toJson(),
      'features': features.map((feature) => feature.toJson()).toList(),
      'itineraries':
          itineraries.map((itinerary) => itinerary.toJson()).toList(),
      'policy': policy.toJson(),
      'inclusions': inclusions.map((inclusion) => inclusion.toJson()).toList(),
      'exclusions': exclusions.map((exclusion) => exclusion.toJson()).toList(),
    };
  }
}

class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

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

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class Feature {
  final String id;
  final String name;

  Feature({
    required this.id,
    required this.name,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Itinerary {
  final String id;
  final String title;
  final String description;

  Itinerary({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
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

  factory Policy.fromJson(Map<String, dynamic> json) {
    return Policy(
      id: json['id'],
      bookingPolicy: json['bookingPolicy'],
      cancellationPolicy: json['cancellationPolicy'],
      paymentTerms: json['paymentTerms'],
      visaDetail: json['visaDetail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingPolicy': bookingPolicy,
      'cancellationPolicy': cancellationPolicy,
      'paymentTerms': paymentTerms,
      'visaDetail': visaDetail,
    };
  }
}

class Inclusion {
  final String id;
  final String name;

  Inclusion({
    required this.id,
    required this.name,
  });

  factory Inclusion.fromJson(Map<String, dynamic> json) {
    return Inclusion(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Exclusion {
  final String id;
  final String name;

  Exclusion({
    required this.id,
    required this.name,
  });

  factory Exclusion.fromJson(Map<String, dynamic> json) {
    return Exclusion(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
