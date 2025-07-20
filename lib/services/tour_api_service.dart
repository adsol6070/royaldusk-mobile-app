// lib/services/tour_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:royaldusk_mobile_app/models/tour.dart';

class TourApiService {
  static const String baseUrl = 'https://api.royaldusk.com';
  static const String tourEndpoint = '/tour-service/api/tours';

  // Private constructor for singleton pattern
  TourApiService._internal();
  static final TourApiService _instance = TourApiService._internal();
  factory TourApiService() => _instance;

  // Get all tours
  Future<List<Tour>> getTours() async {
    try {
      final url = Uri.parse('$baseUrl$tourEndpoint');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          final List<dynamic> toursData = jsonResponse['data'];
          return toursData.map((tourJson) => Tour.fromJson(tourJson)).toList();
        } else {
          throw Exception(
              'API returned unsuccessful response: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load tours. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching tours: $e');
    }
  }

  // Get tour by ID
  Future<Tour?> getTourById(String id) async {
    try {
      final tours = await getTours();
      return tours.firstWhere(
        (tour) => tour.id == id,
        orElse: () => throw Exception('Tour not found'),
      );
    } catch (e) {
      throw Exception('Error fetching tour by ID: $e');
    }
  }

  // Get tour by slug
  Future<Tour?> getTourBySlug(String slug) async {
    try {
      final tours = await getTours();
      return tours.firstWhere(
        (tour) => tour.slug == slug,
        orElse: () => throw Exception('Tour not found'),
      );
    } catch (e) {
      throw Exception('Error fetching tour by slug: $e');
    }
  }

  // Filter tours by category
  Future<List<Tour>> getToursByCategory(String category) async {
    try {
      final tours = await getTours();
      if (category.toLowerCase() == 'all') {
        return tours;
      }
      return tours
          .where((tour) =>
              tour.category.name.toLowerCase() == category.toLowerCase())
          .toList();
    } catch (e) {
      throw Exception('Error filtering tours by category: $e');
    }
  }

  // Filter tours by location
  Future<List<Tour>> getToursByLocation(String location) async {
    try {
      final tours = await getTours();
      if (location.toLowerCase() == 'all') {
        return tours;
      }
      return tours
          .where((tour) =>
              tour.location.name.toLowerCase() == location.toLowerCase())
          .toList();
    } catch (e) {
      throw Exception('Error filtering tours by location: $e');
    }
  }

  // Filter tours by availability
  Future<List<Tour>> getToursByAvailability(String availability) async {
    try {
      final tours = await getTours();
      if (availability.toLowerCase() == 'all') {
        return tours;
      }
      return tours
          .where((tour) =>
              tour.tourAvailability.toLowerCase() == availability.toLowerCase())
          .toList();
    } catch (e) {
      throw Exception('Error filtering tours by availability: $e');
    }
  }

  // Get available tours only
  // Future<List<Tour>> getAvailableTours() async {
  //   try {
  //     final tours = await getTours();
  //     return tours.where((tour) => tour.isAvailable).toList();
  //   } catch (e) {
  //     throw Exception('Error fetching available tours: $e');
  //   }
  // }

  // Get featured tours (Popular and Top tagged tours)
  Future<List<Tour>> getFeaturedTours({int limit = 5}) async {
    try {
      final tours = await getTours();
      final featuredTours = tours
          .where((tour) =>
              tour.tag.toLowerCase() == 'popular' ||
              tour.tag.toLowerCase() == 'top')
          .toList();

      // Sort by tag priority (Popular first, then Top)
      featuredTours.sort((a, b) {
        if (a.tag.toLowerCase() == 'popular' &&
            b.tag.toLowerCase() != 'popular') return -1;
        if (b.tag.toLowerCase() == 'popular' &&
            a.tag.toLowerCase() != 'popular') return 1;
        if (a.tag.toLowerCase() == 'top' && b.tag.toLowerCase() != 'top')
          return -1;
        if (b.tag.toLowerCase() == 'top' && a.tag.toLowerCase() != 'top')
          return 1;
        return 0;
      });

      return featuredTours.take(limit).toList();
    } catch (e) {
      throw Exception('Error fetching featured tours: $e');
    }
  }

  // Search tours by name, location, or description
  Future<List<Tour>> searchTours(String query) async {
    try {
      final tours = await getTours();
      final lowercaseQuery = query.toLowerCase();

      return tours
          .where((tour) =>
              tour.name.toLowerCase().contains(lowercaseQuery) ||
              tour.location.name.toLowerCase().contains(lowercaseQuery) ||
              tour.description.toLowerCase().contains(lowercaseQuery) ||
              tour.category.name.toLowerCase().contains(lowercaseQuery))
          .toList();
    } catch (e) {
      throw Exception('Error searching tours: $e');
    }
  }

  // Advanced search with multiple filters
  Future<List<Tour>> advancedSearchTours({
    String? query,
    String? category,
    String? location,
    String? availability,
    double? minPrice,
    double? maxPrice,
    String? tag,
  }) async {
    try {
      List<Tour> tours = await getTours();

      // Apply text search filter
      if (query != null && query.isNotEmpty) {
        final lowercaseQuery = query.toLowerCase();
        tours = tours
            .where((tour) =>
                tour.name.toLowerCase().contains(lowercaseQuery) ||
                tour.location.name.toLowerCase().contains(lowercaseQuery) ||
                tour.description.toLowerCase().contains(lowercaseQuery) ||
                tour.category.name.toLowerCase().contains(lowercaseQuery))
            .toList();
      }

      // Apply category filter
      if (category != null && category.toLowerCase() != 'all') {
        tours = tours
            .where((tour) =>
                tour.category.name.toLowerCase() == category.toLowerCase())
            .toList();
      }

      // Apply location filter
      if (location != null && location.toLowerCase() != 'all') {
        tours = tours
            .where((tour) =>
                tour.location.name.toLowerCase() == location.toLowerCase())
            .toList();
      }

      // Apply availability filter
      if (availability != null && availability.toLowerCase() != 'all') {
        tours = tours
            .where((tour) =>
                tour.tourAvailability.toLowerCase() ==
                availability.toLowerCase())
            .toList();
      }

      // Apply price range filter
      if (minPrice != null) {
        tours = tours.where((tour) => tour.price >= minPrice).toList();
      }
      if (maxPrice != null) {
        tours = tours.where((tour) => tour.price <= maxPrice).toList();
      }

      // Apply tag filter
      if (tag != null && tag.toLowerCase() != 'all') {
        tours = tours
            .where((tour) => tour.tag.toLowerCase() == tag.toLowerCase())
            .toList();
      }

      return tours;
    } catch (e) {
      throw Exception('Error performing advanced search: $e');
    }
  }

  // Get unique categories
  Future<List<String>> getCategories() async {
    try {
      final tours = await getTours();
      final categories =
          tours.map((tour) => tour.category.name).toSet().toList();
      categories.sort();
      return ['All', ...categories];
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Get unique locations
  Future<List<String>> getLocations() async {
    try {
      final tours = await getTours();
      final locations =
          tours.map((tour) => tour.location.name).toSet().toList();
      locations.sort();
      return ['All', ...locations];
    } catch (e) {
      throw Exception('Error fetching locations: $e');
    }
  }

  // Get unique tags
  Future<List<String>> getTags() async {
    try {
      final tours = await getTours();
      final tags = tours
          .map((tour) => tour.tag)
          .where((tag) => tag.isNotEmpty)
          .toSet()
          .toList();
      tags.sort();
      return ['All', ...tags];
    } catch (e) {
      throw Exception('Error fetching tags: $e');
    }
  }

  // Get unique availability statuses
  // Future<List<String>> getAvailabilityStatuses() async {
  //   try {
  //     final tours = await getTours();
  //     final statuses = tours
  //         .map((tour) => tour.displayAvailability)
  //         .toSet()
  //         .toList();
  //     statuses.sort();
  //     return ['All', ...statuses];
  //   } catch (e) {
  //     throw Exception('Error fetching availability statuses: $e');
  //   }
  // }

  // Get price range (min and max)
  Future<Map<String, double>> getPriceRange() async {
    try {
      final tours = await getTours();
      if (tours.isEmpty) {
        return {'min': 0.0, 'max': 0.0};
      }

      double minPrice = tours.first.price;
      double maxPrice = tours.first.price;

      for (final tour in tours) {
        if (tour.price < minPrice) minPrice = tour.price;
        if (tour.price > maxPrice) maxPrice = tour.price;
      }

      return {'min': minPrice, 'max': maxPrice};
    } catch (e) {
      throw Exception('Error fetching price range: $e');
    }
  }

  // Sort tours
  // List<Tour> sortTours(List<Tour> tours, String sortBy) {
  //   final List<Tour> sortedTours = List.from(tours);

  //   switch (sortBy) {
  //     case 'Price: Low to High':
  //       sortedTours.sort((a, b) => a.price.compareTo(b.price));
  //       break;
  //     case 'Price: High to Low':
  //       sortedTours.sort((a, b) => b.price.compareTo(a.price));
  //       break;
  //     case 'Name A-Z':
  //       sortedTours.sort((a, b) => a.name.compareTo(b.name));
  //       break;
  //     case 'Name Z-A':
  //       sortedTours.sort((a, b) => b.name.compareTo(a.name));
  //       break;
  //     case 'Newest First':
  //       sortedTours.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  //       break;
  //     case 'Oldest First':
  //       sortedTours.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  //       break;
  //     case 'Recently Updated':
  //       sortedTours.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  //       break;
  //     case 'Popular':
  //       sortedTours.sort((a, b) {
  //         // Sort by tag (Popular first, then Top), then by availability
  //         if (a.tag.toLowerCase() == 'popular' && b.tag.toLowerCase() != 'popular') return -1;
  //         if (b.tag.toLowerCase() == 'popular' && a.tag.toLowerCase() != 'popular') return 1;
  //         if (a.tag.toLowerCase() == 'top' && b.tag.toLowerCase() != 'top') return -1;
  //         if (b.tag.toLowerCase() == 'top' && a.tag.toLowerCase() != 'top') return 1;
  //         // If tags are equal, sort by availability (Available first)
  //         if (a.isAvailable && !b.isAvailable) return -1;
  //         if (b.isAvailable && !a.isAvailable) return 1;
  //         return 0;
  //       });
  //       break;
  //     case 'Location A-Z':
  //       sortedTours.sort((a, b) => a.location.name.compareTo(b.location.name));
  //       break;
  //     case 'Location Z-A':
  //       sortedTours.sort((a, b) => b.location.name.compareTo(a.location.name));
  //       break;
  //     case 'Category A-Z':
  //       sortedTours.sort((a, b) => a.category.name.compareTo(b.category.name));
  //       break;
  //     case 'Category Z-A':
  //       sortedTours.sort((a, b) => b.category.name.compareTo(a.category.name));
  //       break;
  //     case 'Available First':
  //       sortedTours.sort((a, b) {
  //         if (a.isAvailable && !b.isAvailable) return -1;
  //         if (b.isAvailable && !a.isAvailable) return 1;
  //         return 0;
  //       });
  //       break;
  //     default:
  //       // Default sorting by Popular
  //       sortedTours.sort((a, b) {
  //         if (a.tag.toLowerCase() == 'popular' && b.tag.toLowerCase() != 'popular') return -1;
  //         if (b.tag.toLowerCase() == 'popular' && a.tag.toLowerCase() != 'popular') return 1;
  //         if (a.tag.toLowerCase() == 'top' && b.tag.toLowerCase() != 'top') return -1;
  //         if (b.tag.toLowerCase() == 'top' && a.tag.toLowerCase() != 'top') return 1;
  //         if (a.isAvailable && !b.isAvailable) return -1;
  //         if (b.isAvailable && !a.isAvailable) return 1;
  //         return 0;
  //       });
  //   }

  //   return sortedTours;
  // }

  // Get tour statistics
  // Future<Map<String, dynamic>> getTourStatistics() async {
  //   try {
  //     final tours = await getTours();

  //     final totalTours = tours.length;
  //     final availableTours = tours.where((tour) => tour.isAvailable).length;
  //     final comingSoonTours = tours.where((tour) => tour.isComingSoon).length;
  //     final popularTours = tours.where((tour) => tour.tag.toLowerCase() == 'popular').length;
  //     final topTours = tours.where((tour) => tour.tag.toLowerCase() == 'top').length;

  //     final priceRange = await getPriceRange();
  //     final avgPrice = tours.isEmpty ? 0.0 : tours.map((tour) => tour.price).reduce((a, b) => a + b) / tours.length;

  //     final categoriesCount = tours.map((tour) => tour.category.name).toSet().length;
  //     final locationsCount = tours.map((tour) => tour.location.name).toSet().length;

  //     return {
  //       'total': totalTours,
  //       'available': availableTours,
  //       'comingSoon': comingSoonTours,
  //       'popular': popularTours,
  //       'top': topTours,
  //       'categories': categoriesCount,
  //       'locations': locationsCount,
  //       'minPrice': priceRange['min'],
  //       'maxPrice': priceRange['max'],
  //       'avgPrice': avgPrice,
  //       'availabilityRate': totalTours > 0 ? (availableTours / totalTours * 100).toStringAsFixed(1) : '0.0',
  //     };
  //   } catch (e) {
  //     throw Exception('Error fetching tour statistics: $e');
  //   }
  // }

  // Get tours by multiple IDs
  Future<List<Tour>> getToursByIds(List<String> ids) async {
    try {
      final tours = await getTours();
      return tours.where((tour) => ids.contains(tour.id)).toList();
    } catch (e) {
      throw Exception('Error fetching tours by IDs: $e');
    }
  }

  // Get related tours (same category or location, excluding current tour)
  Future<List<Tour>> getRelatedTours(String tourId, {int limit = 5}) async {
    try {
      final tours = await getTours();
      final currentTour = tours.firstWhere((tour) => tour.id == tourId);

      // Get tours in same category or location, excluding current tour
      final relatedTours = tours
          .where((tour) =>
              tour.id != tourId &&
              (tour.category.id == currentTour.category.id ||
                  tour.location.id == currentTour.location.id))
          .toList();

      // Sort by relevance (same category first, then same location)
      relatedTours.sort((a, b) {
        if (a.category.id == currentTour.category.id &&
            b.category.id != currentTour.category.id) return -1;
        if (b.category.id == currentTour.category.id &&
            a.category.id != currentTour.category.id) return 1;
        if (a.location.id == currentTour.location.id &&
            b.location.id != currentTour.location.id) return -1;
        if (b.location.id == currentTour.location.id &&
            a.location.id != currentTour.location.id) return 1;
        return 0;
      });

      return relatedTours.take(limit).toList();
    } catch (e) {
      throw Exception('Error fetching related tours: $e');
    }
  }
}
