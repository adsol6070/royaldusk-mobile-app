import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:royaldusk_mobile_app/constants/app_colors.dart';
import 'package:royaldusk_mobile_app/models/package.dart';

class PackageListScreen extends StatefulWidget {
  const PackageListScreen({super.key});

  @override
  State<PackageListScreen> createState() => _PackageListScreenState();
}

class _PackageListScreenState extends State<PackageListScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'All';
  String _selectedSortBy = 'Popular';
  String _searchQuery = '';
  bool _isListView = false;

  final List<String> categories = [
    'All',
    'Adventure',
    'Beach',
    'Mountain',
    'Cultural',
    'Luxury',
    'Family'
  ];

  final List<String> sortOptions = [
    'Popular',
    'Price: Low to High',
    'Price: High to Low',
    'Duration',
    'Rating'
  ];

  // Sample package data - replace with your actual data
  final List<Package> allPackages = [
    Package(
      id: '1',
      name: 'Manali Adventure Tour',
      location: 'Manali, Himachal Pradesh',
      duration: '5 Days',
      price: 15999,
      originalPrice: 19999,
      rating: 4.5,
      reviewCount: 128,
      imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
      category: 'Adventure',
      isPopular: true,
      description:
          'Experience thrilling adventures in the scenic mountains of Manali',
      highlights: ['River Rafting', 'Paragliding', 'Trekking', 'Local Cuisine'],
    ),
    Package(
      id: '2',
      name: 'Goa Beach Paradise',
      location: 'Goa',
      duration: '4 Days',
      price: 12999,
      originalPrice: 15999,
      rating: 4.8,
      reviewCount: 89,
      imageUrl: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2',
      category: 'Beach',
      isPopular: true,
      description: 'Relax on pristine beaches and enjoy vibrant nightlife',
      highlights: ['Beach Resort', 'Water Sports', 'Casino', 'Sunset Cruise'],
    ),
    Package(
      id: '3',
      name: 'Kerala Backwaters',
      location: 'Kerala',
      duration: '6 Days',
      price: 18999,
      originalPrice: 22999,
      rating: 4.6,
      reviewCount: 156,
      imageUrl: 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944',
      category: 'Cultural',
      isPopular: false,
      description:
          'Cruise through serene backwaters and experience local culture',
      highlights: [
        'Houseboat Stay',
        'Ayurveda Spa',
        'Spice Gardens',
        'Traditional Dance'
      ],
    ),
    Package(
      id: '4',
      name: 'Rajasthan Royal Heritage',
      location: 'Rajasthan',
      duration: '7 Days',
      price: 24999,
      originalPrice: 29999,
      rating: 4.7,
      reviewCount: 203,
      imageUrl: 'https://images.unsplash.com/photo-1477587458883-47145ed94245',
      category: 'Cultural',
      isPopular: true,
      description: 'Explore magnificent palaces and desert landscapes',
      highlights: [
        'Palace Hotels',
        'Camel Safari',
        'Folk Music',
        'Desert Camping'
      ],
    ),
    Package(
      id: '5',
      name: 'Shimla Hill Station',
      location: 'Shimla, Himachal Pradesh',
      duration: '3 Days',
      price: 9999,
      originalPrice: 12999,
      rating: 4.3,
      reviewCount: 67,
      imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
      category: 'Mountain',
      isPopular: false,
      description: 'Escape to the cool mountains and colonial charm',
      highlights: ['Toy Train', 'Mall Road', 'Jakhu Temple', 'Pine Forests'],
    ),
    Package(
      id: '6',
      name: 'Luxury Mumbai Experience',
      location: 'Mumbai, Maharashtra',
      duration: '4 Days',
      price: 35999,
      originalPrice: 39999,
      rating: 4.9,
      reviewCount: 45,
      imageUrl: 'https://images.unsplash.com/photo-1567157577867-05ccb1388e66',
      category: 'Luxury',
      isPopular: false,
      description: 'Experience the financial capital in ultimate luxury',
      highlights: [
        '5-Star Hotels',
        'Fine Dining',
        'Bollywood Tour',
        'Private Transfer'
      ],
    ),
  ];

  List<Package> get filteredPackages {
    List<Package> filtered = allPackages;

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered =
          filtered.where((p) => p.category == _selectedCategory).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.location.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Sort packages
    switch (_selectedSortBy) {
      case 'Price: Low to High':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Duration':
        filtered.sort((a, b) => a.duration.compareTo(b.duration));
        break;
      default: // Popular
        filtered.sort((a, b) => b.isPopular ? 1 : -1);
    }

    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(
            child: _buildPackagesList(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios,
            color: AppColors.darkGray, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        children: [
          const Text(
            'Travel Packages',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          Text(
            '${filteredPackages.length} packages available',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.mediumGray,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            _isListView ? Icons.grid_view : Icons.view_list,
            color: AppColors.primaryOrange,
            size: 24,
          ),
          onPressed: () {
            setState(() {
              _isListView = !_isListView;
            });
          },
        ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: const Color(0xFFF1F5F9),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search packages, destinations...',
                hintStyle: TextStyle(color: AppColors.mediumGray, fontSize: 14),
                prefixIcon:
                    Icon(Icons.search, color: AppColors.mediumGray, size: 20),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Filter chips
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = _selectedCategory == category;
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(
                            category,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.mediumGray,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          backgroundColor: AppColors.lightGray,
                          selectedColor: AppColors.primaryOrange,
                          checkmarkColor: Colors.white,
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primaryOrange
                                : const Color(0xFFE5E7EB),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Sort dropdown
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: _selectedSortBy,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.sort,
                      color: AppColors.mediumGray, size: 18),
                  style:
                      const TextStyle(fontSize: 12, color: AppColors.darkGray),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  items: sortOptions.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(
                        option,
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSortBy = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPackagesList() {
    if (filteredPackages.isEmpty) {
      return _buildEmptyState();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _animationController,
          child: _isListView ? _buildListView() : _buildGridView(),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.lightOrange,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.search_off,
                size: 40,
                color: AppColors.primaryOrange,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No packages found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting your search or filters\nto find what you\'re looking for',
              style: TextStyle(
                color: AppColors.mediumGray,
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedCategory = 'All';
                  _searchQuery = '';
                  _searchController.clear();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: filteredPackages.length,
        itemBuilder: (context, index) {
          return _buildPackageGridCard(filteredPackages[index]);
        },
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredPackages.length,
      itemBuilder: (context, index) {
        return _buildPackageListCard(filteredPackages[index]);
      },
    );
  }

  Widget _buildPackageGridCard(Package package) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.lightOrange,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(package.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Popular badge
              if (package.isPopular)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Popular',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              // Discount badge
              if (package.originalPrice > package.price)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${(((package.originalPrice - package.price) / package.originalPrice) * 100).round()}% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              // Location badge
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 8,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        package.location.split(',').first,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Content section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating and duration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.lightOrange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.access_time,
                                size: 8, color: AppColors.primaryOrange),
                            const SizedBox(width: 2),
                            Text(
                              package.duration,
                              style: const TextStyle(
                                color: AppColors.primaryOrange,
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: AppColors.primaryOrange, size: 10),
                          const SizedBox(width: 2),
                          Text(
                            '${package.rating}',
                            style: const TextStyle(
                              color: AppColors.primaryOrange,
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            ' (${package.reviewCount})',
                            style: const TextStyle(
                              color: AppColors.mediumGray,
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Package name
                  Text(
                    package.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGray,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  // Price and button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (package.originalPrice > package.price)
                            Text(
                              'AED ${package.originalPrice}',
                              style: const TextStyle(
                                fontSize: 9,
                                color: AppColors.mediumGray,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Text(
                            'AED ${package.price}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryOrange,
                            ),
                          ),
                          const Text(
                            '/person',
                            style: TextStyle(
                              fontSize: 8,
                              color: AppColors.mediumGray,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Add to cart functionality
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          minimumSize: const Size(0, 24),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageListCard(Package package) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image section
          Stack(
            children: [
              Container(
                width: 120,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.lightOrange,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(package.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (package.isPopular)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Popular',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 7,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Content section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          package.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkGray,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: AppColors.primaryOrange, size: 12),
                          const SizedBox(width: 2),
                          Text(
                            '${package.rating}',
                            style: const TextStyle(
                              color: AppColors.primaryOrange,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 12, color: AppColors.mediumGray),
                      const SizedBox(width: 2),
                      Text(
                        package.location,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.mediumGray,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time,
                          size: 12, color: AppColors.mediumGray),
                      const SizedBox(width: 2),
                      Text(
                        package.duration,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.mediumGray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    package.description,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.mediumGray,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (package.originalPrice > package.price)
                            Text(
                              'AED ${package.originalPrice}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.mediumGray,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Text(
                            'AED ${package.price}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryOrange,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {Navigator.pushNamed(context, '/comingSoon');},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
