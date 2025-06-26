import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:royaldusk_mobile_app/constants/app_colors.dart';
import 'package:royaldusk_mobile_app/services/auth_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentIndex = 0;
  int _selectedServiceIndex = 0;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToCart() {
    Navigator.pushNamed(context, '/cart');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildSearchWidget(),
                _buildServicesSection(),
                _buildPopularDestinations(),
                _buildFeaturedPackages(),
                _buildQuickActions(),
                const SizedBox(height: 100), // Bottom padding for navigation
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primaryOrange,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primaryOrange, AppColors.secondaryOrange],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.account_circle,
                          color: AppColors.primaryOrange,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back!',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Explorer',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.notifications_outlined),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.shopping_cart_outlined),
                          color: Colors.white,
                          onPressed: () {
                            _navigateToCart();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      title: const Text(
        'Royal Dusk Tours',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildSearchWidget() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withValues(alpha: 0.12),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text(
                  'Find Your Perfect Trip',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGray,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Search across our comprehensive travel services',
                  style: TextStyle(
                    color: AppColors.mediumGray,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                _buildServiceTabs(),
                const SizedBox(height: 24),
                _buildSearchField(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTabs() {
    final services = [
      {'icon': Icons.route, 'title': 'Packages', 'available': true},
      {'icon': Icons.flight, 'title': 'Flights', 'available': false},
      {'icon': Icons.hotel, 'title': 'Hotels', 'available': false},
      {'icon': Icons.tour, 'title': 'Tours', 'available': false},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightOrange,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: services.asMap().entries.map((entry) {
          final index = entry.key;
          final service = entry.value;
          final isSelected = _selectedServiceIndex == index;
          final isAvailable = service['available'] as bool;

          return Expanded(
            child: GestureDetector(
              onTap: isAvailable
                  ? () {
                      setState(() {
                        _selectedServiceIndex = index;
                      });
                    }
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color:
                      isSelected ? AppColors.primaryOrange : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color:
                                AppColors.primaryOrange.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Icon(
                      service['icon'] as IconData,
                      color: isSelected
                          ? Colors.white
                          : isAvailable
                              ? AppColors.mediumGray
                              : AppColors.mediumGray.withValues(alpha: 0.5),
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service['title'] as String,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : isAvailable
                                ? AppColors.mediumGray
                                : AppColors.mediumGray.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    if (!isAvailable)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Soon',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'e.g. Manali, Adventure tours, Beach holidays...',
                hintStyle: TextStyle(color: AppColors.mediumGray, fontSize: 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(4),
            child: ElevatedButton(
              onPressed: () {
                // Handle search
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Search',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Complete Travel Solutions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Discover our comprehensive range of travel services',
            style: TextStyle(
              color: AppColors.mediumGray,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildServiceCard(
                icon: Icons.route,
                title: 'Travel Packages',
                description: 'Complete tour packages with accommodation',
                available: true,
                stat: '120+',
                statLabel: 'Packages',
              ),
              _buildServiceCard(
                icon: Icons.flight,
                title: 'Flight Booking',
                description: 'Book flights at competitive prices',
                available: false,
                stat: 'Soon',
                statLabel: 'Airlines',
              ),
              _buildServiceCard(
                icon: Icons.hotel,
                title: 'Hotel Reservations',
                description: 'Find hotels with exclusive discounts',
                available: false,
                stat: 'Soon',
                statLabel: 'Properties',
              ),
              _buildServiceCard(
                icon: Icons.tour,
                title: 'Custom Tours',
                description: 'Personalized tour experiences',
                available: false,
                stat: 'Soon',
                statLabel: 'Experiences',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required String description,
    required bool available,
    required String stat,
    required String statLabel,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: available ? Colors.white : Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: available
            ? [
                BoxShadow(
                  color: AppColors.primaryOrange.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12), // Reduced from 16 to 12
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Important: prevents overflow
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40, // Reduced from 48 to 40
                  height: 40, // Reduced from 48 to 40
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: available
                          ? [AppColors.primaryOrange, AppColors.secondaryOrange]
                          : [AppColors.mediumGray, AppColors.mediumGray],
                    ),
                    borderRadius:
                        BorderRadius.circular(10), // Reduced from 12 to 10
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20, // Reduced from 24 to 20
                  ),
                ),
                if (!available)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2), // Reduced padding
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Soon',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9, // Reduced from 10 to 9
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8), // Reduced from 12 to 8
            Text(
              title,
              style: TextStyle(
                fontSize: 14, // Reduced from 16 to 14
                fontWeight: FontWeight.w600,
                color: available ? AppColors.darkGray : AppColors.mediumGray,
              ),
            ),
            const SizedBox(height: 2), // Reduced from 4 to 2
            Expanded(
              // Wrap description in Expanded
              child: Text(
                description,
                style: const TextStyle(
                  color: AppColors.mediumGray,
                  fontSize: 11, // Reduced from 12 to 11
                  height: 1.2, // Reduced line height
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8), // Fixed spacing instead of Spacer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      stat,
                      style: TextStyle(
                        fontSize: 14, // Reduced from 16 to 14
                        fontWeight: FontWeight.bold,
                        color: available
                            ? AppColors.primaryOrange
                            : AppColors.mediumGray,
                      ),
                    ),
                    Text(
                      statLabel,
                      style: const TextStyle(
                        fontSize: 9, // Reduced from 10 to 9
                        color: AppColors.mediumGray,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularDestinations() {
    final destinations = [
      {
        'name': 'Manali',
        'packages': '15 packages',
        'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
      },
      {
        'name': 'Goa',
        'packages': '12 packages',
        'image': 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2',
      },
      {
        'name': 'Kerala',
        'packages': '18 packages',
        'image': 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944',
      },
      {
        'name': 'Rajasthan',
        'packages': '22 packages',
        'image': 'https://images.unsplash.com/photo-1477587458883-47145ed94245',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Popular Destinations',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGray,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final destination = destinations[index];
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.primaryOrange.withValues(alpha: 0.2),
                                AppColors.darkGray.withValues(alpha: 0.8),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                destination['name'] as String,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                destination['packages'] as String,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedPackages() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Featured Packages',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGray,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/packages');
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildPackageCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageCard(int index) {
    final packages = [
      {
        'name': 'Manali Adventure Tour',
        'location': 'Manali, HP',
        'duration': '5 Days',
        'price': '₹15,999',
        'rating': '4.5',
      },
      {
        'name': 'Goa Beach Paradise',
        'location': 'Goa',
        'duration': '4 Days',
        'price': '₹12,999',
        'rating': '4.8',
      },
      {
        'name': 'Kerala Backwaters',
        'location': 'Kerala',
        'duration': '6 Days',
        'price': '₹18,999',
        'rating': '4.6',
      },
    ];

    final package = packages[index % packages.length];

    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Prevents overflow
        children: [
          Stack(
            children: [
              Container(
                height: 120, // Reduced from 140 to 120
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withValues(alpha: 0.2),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
              ),
              Positioned(
                top: 8, // Reduced from 12 to 8
                right: 8, // Reduced from 12 to 8
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2), // Reduced padding
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Available',
                    style: TextStyle(
                      color: Color(0xFF059669),
                      fontSize: 9, // Reduced from 10 to 9
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8, // Reduced from 12 to 8
                left: 8, // Reduced from 12 to 8
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2), // Reduced padding
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 10, // Reduced from 12 to 10
                      ),
                      const SizedBox(width: 2), // Reduced from 4 to 2
                      Text(
                        package['location'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9, // Reduced from 10 to 9
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            // Wrap the bottom section in Expanded
            child: Padding(
              padding: const EdgeInsets.all(12), // Reduced from 16 to 12
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2), // Reduced padding
                        decoration: BoxDecoration(
                          color: AppColors.lightOrange,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 8, // Reduced from 10 to 8
                              color: AppColors.primaryOrange,
                            ),
                            const SizedBox(width: 2), // Reduced from 4 to 2
                            Text(
                              package['duration'] as String,
                              style: const TextStyle(
                                color: AppColors.primaryOrange,
                                fontSize: 9, // Reduced from 10 to 9
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.primaryOrange,
                            size: 12, // Reduced from 14 to 12
                          ),
                          const SizedBox(width: 2), // Reduced from 4 to 2
                          Text(
                            package['rating'] as String,
                            style: const TextStyle(
                              color: AppColors.primaryOrange,
                              fontSize: 11, // Reduced from 12 to 11
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6), // Reduced from 8 to 6
                  Text(
                    package['name'] as String,
                    style: const TextStyle(
                      fontSize: 13, // Reduced from 14 to 13
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGray,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(), // Use Spacer to push bottom content down
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            package['price'] as String,
                            style: const TextStyle(
                              fontSize: 14, // Reduced from 16 to 14
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGray,
                            ),
                          ),
                          const Text(
                            '/person',
                            style: TextStyle(
                              fontSize: 9, // Reduced from 10 to 9
                              color: AppColors.mediumGray,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10, // Reduced from 12 to 10
                            vertical: 6, // Reduced from 8 to 6
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          minimumSize:
                              const Size(0, 28), // Reduced from 32 to 28
                        ),
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(
                            fontSize: 11, // Reduced from 12 to 11
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

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.support_agent,
                  title: '24/7 Support',
                  subtitle: 'Get help anytime',
                  color: AppColors.primaryOrange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.favorite_outline,
                  title: 'Wishlist',
                  subtitle: 'Saved packages',
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });

            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/home');
                break;
              case 1:
                Navigator.pushNamed(context, '/explore');
                break;
              case 2:
                Navigator.pushNamed(context, '/bookings');
                break;
              case 3:
                Navigator.pushNamed(context, '/wishlist');
                break;
              case 4:
                Navigator.pushNamed(context, '/profile');
                break;
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primaryOrange,
          unselectedItemColor: AppColors.mediumGray,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          elevation: 0,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Explore',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number_outlined),
              activeIcon: Icon(Icons.confirmation_number),
              label: 'Bookings',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: AuthService.isSignedIn
                  ? const Icon(Icons.person_outline)
                  : const Icon(Icons.login),
              activeIcon: AuthService.isSignedIn
                  ? const Icon(Icons.person)
                  : const Icon(Icons.login),
              label: AuthService.isSignedIn ? 'Profile' : 'Sign In',
            ),
          ],
        ),
      ),
    );
  }
}
