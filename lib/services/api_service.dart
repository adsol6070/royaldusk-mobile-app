// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:royaldusk_mobile_app/models/package.dart';

class ApiService {
  static const String baseUrl = 'https://api.royaldusk.com';
  static const String packageEndpoint = '/package-service/api/package';

  // Private constructor for singleton pattern
  ApiService._internal();
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  // Get all packages
  Future<List<Package>> getPackages() async {
    try {
      final url = Uri.parse('$baseUrl$packageEndpoint');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          final List<dynamic> packagesData = jsonResponse['data'];
          return packagesData
              .map((packageJson) => Package.fromJson(packageJson))
              .toList();
        } else {
          throw Exception(
              'API returned unsuccessful response: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load packages. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching packages: $e');
    }
  }

  // Get package by ID
  Future<Package?> getPackageById(String id) async {
    try {
      final packages = await getPackages();
      return packages.firstWhere(
        (package) => package.id == id,
        orElse: () => throw Exception('Package not found'),
      );
    } catch (e) {
      throw Exception('Error fetching package by ID: $e');
    }
  }

  // Filter packages by category
  Future<List<Package>> getPackagesByCategory(String category) async {
    try {
      final packages = await getPackages();
      if (category.toLowerCase() == 'all') {
        return packages;
      }
      return packages
          .where((package) =>
              package.category.name.toLowerCase() == category.toLowerCase())
          .toList();
    } catch (e) {
      throw Exception('Error filtering packages by category: $e');
    }
  }

  // Search packages by name or location
  Future<List<Package>> searchPackages(String query) async {
    try {
      final packages = await getPackages();
      final lowercaseQuery = query.toLowerCase();

      return packages
          .where((package) =>
              package.name.toLowerCase().contains(lowercaseQuery) ||
              package.location.name.toLowerCase().contains(lowercaseQuery) ||
              package.description.toLowerCase().contains(lowercaseQuery))
          .toList();
    } catch (e) {
      throw Exception('Error searching packages: $e');
    }
  }

  // Get unique categories
  Future<List<String>> getCategories() async {
    try {
      final packages = await getPackages();
      final categories =
          packages.map((package) => package.category.name).toSet().toList();
      categories.sort();
      return ['All', ...categories];
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Sort packages
  List<Package> sortPackages(List<Package> packages, String sortBy) {
    final List<Package> sortedPackages = List.from(packages);

    switch (sortBy) {
      case 'Price: Low to High':
        sortedPackages.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        sortedPackages.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Duration':
        sortedPackages.sort((a, b) => a.duration.compareTo(b.duration));
        break;
      case 'Popular':
        sortedPackages.sort((a, b) {
          // Sort by tag (Popular first), then by review count
          if (a.tag == 'Popular' && b.tag != 'Popular') return -1;
          if (b.tag == 'Popular' && a.tag != 'Popular') return 1;
          return b.review.compareTo(a.review);
        });
        break;
      case 'Rating':
        sortedPackages.sort((a, b) => b.review.compareTo(a.review));
        break;
      default:
        // Default sorting by Popular
        sortedPackages.sort((a, b) {
          if (a.tag == 'Popular' && b.tag != 'Popular') return -1;
          if (b.tag == 'Popular' && a.tag != 'Popular') return 1;
          return b.review.compareTo(a.review);
        });
    }

    return sortedPackages;
  }
}
