// models/wishlist_count.dart
import 'package:json_annotation/json_annotation.dart';

part 'wishlist_count.g.dart'; 

@JsonSerializable()
class WishlistCount {
  final int total;
  final int packages;
  final int tours;
  final WishlistPriorityCount byPriority;

  const WishlistCount({
    required this.total,
    required this.packages,
    required this.tours,
    required this.byPriority,
  });

  factory WishlistCount.fromJson(Map<String, dynamic> json) =>
      _$WishlistCountFromJson(json);

  Map<String, dynamic> toJson() => _$WishlistCountToJson(this);
}

@JsonSerializable()
class WishlistPriorityCount {
  final int low;
  final int medium;
  final int high;

  const WishlistPriorityCount({
    required this.low,
    required this.medium,
    required this.high,
  });

  factory WishlistPriorityCount.fromJson(Map<String, dynamic> json) =>
      _$WishlistPriorityCountFromJson(json);

  Map<String, dynamic> toJson() => _$WishlistPriorityCountToJson(this);
}
