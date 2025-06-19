// lib/app/enums/package_types.dart
enum PackageType { all, popular, top }

extension PackageTypeExtension on PackageType {
  String get displayName {
    switch (this) {
      case PackageType.all:
        return 'All Packages';
      case PackageType.popular:
        return 'Popular Packages';
      case PackageType.top:
        return 'Top Packages';
    }
  }

  String get routeTag {
    switch (this) {
      case PackageType.all:
        return 'travel_all_packages';
      case PackageType.popular:
        return 'travel_popular_packages';
      case PackageType.top:
        return 'travel_top_packages';
    }
  }
}
