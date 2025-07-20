// models/wishlist_item.dart
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:royaldusk_mobile_app/models/package.dart';
import 'package:royaldusk_mobile_app/models/tour.dart';

part 'wishlist_item.g.dart';

@JsonSerializable()
class WishlistItem extends Equatable {
  final String id;
  final String userId;
  final WishlistItemType itemType;
  final String? packageId;
  final String? tourId;
  final String? notes;
  final WishlistPriority priority;
  final bool isNotified;
  final int notificationsSent;
  final DateTime? lastViewedAt;
  final double? priceWhenAdded;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Related objects (populated from includes)
  final Package? package;
  final Tour? tour;

  const WishlistItem({
    required this.id,
    required this.userId,
    required this.itemType,
    this.packageId,
    this.tourId,
    this.notes,
    required this.priority,
    required this.isNotified,
    required this.notificationsSent,
    this.lastViewedAt,
    this.priceWhenAdded,
    required this.createdAt,
    required this.updatedAt,
    this.package,
    this.tour,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) =>
      _$WishlistItemFromJson(json);

  Map<String, dynamic> toJson() => _$WishlistItemToJson(this);

  // Computed properties
  String get itemName {
    if (itemType == WishlistItemType.Package && package != null) {
      return package!.name;
    } else if (itemType == WishlistItemType.Tour && tour != null) {
      return tour!.name;
    }
    return 'Unknown Item';
  }

  String get itemImageUrl {
    if (itemType == WishlistItemType.Package && package != null) {
      return package!.imageUrl;
    } else if (itemType == WishlistItemType.Tour && tour != null) {
      return tour!.imageUrl;
    }
    return '';
  }

  double get currentPrice {
    if (itemType == WishlistItemType.Package && package != null) {
      return package!.price;
    } else if (itemType == WishlistItemType.Tour && tour != null) {
      return tour!.price.toDouble();
    }
    return 0.0;
  }

  String get currency {
    if (itemType == WishlistItemType.Package && package != null) {
      return package!.currency;
    }
    return 'AED'; // Default currency
  }

  String get locationName {
    if (itemType == WishlistItemType.Package && package != null) {
      return package!.location.name;
    } else if (itemType == WishlistItemType.Tour && tour != null) {
      return tour!.location.name;
    }
    return '';
  }

  String get categoryName {
    if (itemType == WishlistItemType.Package && package != null) {
      return package!.category.name;
    } else if (itemType == WishlistItemType.Tour && tour != null) {
      return tour!.category.name;
    }
    return '';
  }

  // bool get isAvailable {
  //   if (itemType == WishlistItemType.Package && package != null) {
  //     return package!.availability == Availability.Available;
  //   } else if (itemType == WishlistItemType.Tour && tour != null) {
  //     return tour!.tourAvailability == TourAvailability.Available;
  //   }
  //   return false;
  // }

  bool get hasPriceDrop {
    if (priceWhenAdded != null) {
      return currentPrice < priceWhenAdded!;
    }
    return false;
  }

  double get savingsAmount {
    if (priceWhenAdded != null && hasPriceDrop) {
      return priceWhenAdded! - currentPrice;
    }
    return 0.0;
  }

  // Create a copy with updated fields
  WishlistItem copyWith({
    String? id,
    String? userId,
    WishlistItemType? itemType,
    String? packageId,
    String? tourId,
    String? notes,
    WishlistPriority? priority,
    bool? isNotified,
    int? notificationsSent,
    DateTime? lastViewedAt,
    double? priceWhenAdded,
    DateTime? createdAt,
    DateTime? updatedAt,
    Package? package,
    Tour? tour,
  }) {
    return WishlistItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      itemType: itemType ?? this.itemType,
      packageId: packageId ?? this.packageId,
      tourId: tourId ?? this.tourId,
      notes: notes ?? this.notes,
      priority: priority ?? this.priority,
      isNotified: isNotified ?? this.isNotified,
      notificationsSent: notificationsSent ?? this.notificationsSent,
      lastViewedAt: lastViewedAt ?? this.lastViewedAt,
      priceWhenAdded: priceWhenAdded ?? this.priceWhenAdded,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      package: package ?? this.package,
      tour: tour ?? this.tour,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        itemType,
        packageId,
        tourId,
        notes,
        priority,
        isNotified,
        notificationsSent,
        lastViewedAt,
        priceWhenAdded,
        createdAt,
        updatedAt,
        package,
        tour,
      ];
}

// Enums
@JsonEnum()
enum WishlistItemType {
  @JsonValue('Package')
  Package,
  @JsonValue('Tour')
  Tour,
}

@JsonEnum()
enum WishlistPriority {
  @JsonValue('Low')
  Low,
  @JsonValue('Medium')
  Medium,
  @JsonValue('High')
  High,
}

// Extension for display purposes
extension WishlistItemTypeExtension on WishlistItemType {
  String get displayName {
    switch (this) {
      case WishlistItemType.Package:
        return 'Package';
      case WishlistItemType.Tour:
        return 'Tour';
    }
  }

  String get icon {
    switch (this) {
      case WishlistItemType.Package:
        return '📦';
      case WishlistItemType.Tour:
        return '🎯';
    }
  }
}

extension WishlistPriorityExtension on WishlistPriority {
  String get displayName {
    switch (this) {
      case WishlistPriority.Low:
        return 'Low';
      case WishlistPriority.Medium:
        return 'Medium';
      case WishlistPriority.High:
        return 'High';
    }
  }

  int get sortOrder {
    switch (this) {
      case WishlistPriority.High:
        return 3;
      case WishlistPriority.Medium:
        return 2;
      case WishlistPriority.Low:
        return 1;
    }
  }

  Color get color {
    switch (this) {
      case WishlistPriority.High:
        return Colors.red;
      case WishlistPriority.Medium:
        return Colors.orange;
      case WishlistPriority.Low:
        return Colors.green;
    }
  }
}
