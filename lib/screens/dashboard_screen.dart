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

  // Helper method to get responsive values
  bool get isTablet {
    return MediaQuery.of(context).size.width >= 768;
  }

  double get screenWidth {
    return MediaQuery.of(context).size.width;
  }

  int get crossAxisCount {
    if (screenWidth >= 1200) return 4; // Large tablets/desktop
    if (screenWidth >= 768) return 3; // iPad
    return 2; // Mobile
  }

  double get horizontalPadding {
    if (screenWidth >= 1200) return 40;
    if (screenWidth >= 768) return 32;
    return 20;
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
                SizedBox(
                    height:
                        isTablet ? 120 : 100), // Bottom padding for navigation
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
      expandedHeight: isTablet ? 220 : 180,
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
              padding: EdgeInsets.all(horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        width: isTablet ? 50 : 40,
                        height: isTablet ? 50 : 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(isTablet ? 25 : 20),
                        ),
                        child: Icon(
                          Icons.account_circle,
                          color: AppColors.primaryOrange,
                          size: isTablet ? 30 : 24,
                        ),
                      ),
                      SizedBox(width: isTablet ? 16 : 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back!',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: isTablet ? 16 : 14,
                              ),
                            ),
                            Text(
                              'Explorer',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isTablet ? 22 : 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildHeaderIconButton(
                          Icons.notifications_outlined, () {}),
                      SizedBox(width: isTablet ? 12 : 8),
                      _buildHeaderIconButton(
                          Icons.shopping_cart_outlined, _navigateToCart),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      title: Text(
        'Royal Dusk Tours',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: isTablet ? 24 : 20,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeaderIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(isTablet ? 14 : 12),
      ),
      child: IconButton(
        icon: Icon(icon),
        color: Colors.white,
        iconSize: isTablet ? 26 : 22,
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildSearchWidget() {
    return Container(
      margin: EdgeInsets.all(horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
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
            padding: EdgeInsets.all(isTablet ? 32 : 24),
            child: Column(
              children: [
                Text(
                  'Find Your Perfect Trip',
                  style: TextStyle(
                    fontSize: isTablet ? 26 : 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGray,
                  ),
                ),
                SizedBox(height: isTablet ? 12 : 8),
                Text(
                  'Search across our comprehensive travel services',
                  style: TextStyle(
                    color: AppColors.mediumGray,
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
                SizedBox(height: isTablet ? 32 : 24),
                _buildServiceTabs(),
                SizedBox(height: isTablet ? 32 : 24),
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
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
      ),
      padding: EdgeInsets.all(isTablet ? 6 : 4),
      child: isTablet
          ? Row(
              children: services.asMap().entries.map((entry) {
                return Expanded(
                    child: _buildServiceTab(entry.key, entry.value));
              }).toList(),
            )
          : Row(
              children: services.asMap().entries.map((entry) {
                return Expanded(
                    child: _buildServiceTab(entry.key, entry.value));
              }).toList(),
            ),
    );
  }

  Widget _buildServiceTab(int index, Map<String, dynamic> service) {
    final isSelected = _selectedServiceIndex == index;
    final isAvailable = service['available'] as bool;

    return GestureDetector(
      onTap: isAvailable
          ? () {
              setState(() {
                _selectedServiceIndex = index;
              });
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryOrange.withValues(alpha: 0.3),
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
              size: isTablet ? 26 : 20,
            ),
            SizedBox(height: isTablet ? 6 : 4),
            Text(
              service['title'] as String,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : isAvailable
                        ? AppColors.mediumGray
                        : AppColors.mediumGray.withValues(alpha: 0.5),
                fontWeight: FontWeight.w500,
                fontSize: isTablet ? 14 : 12,
              ),
            ),
            if (!isAvailable)
              Container(
                margin: EdgeInsets.only(top: isTablet ? 4 : 2),
                padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 8 : 6, vertical: isTablet ? 2 : 1),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Soon',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 10 : 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'e.g. Manali, Adventure tours, Beach holidays...',
                hintStyle: TextStyle(
                    color: AppColors.mediumGray, fontSize: isTablet ? 16 : 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 20 : 16,
                  vertical: isTablet ? 16 : 12,
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
            margin: EdgeInsets.all(isTablet ? 6 : 4),
            child: ElevatedButton(
              onPressed: () {
                // Handle search
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24 : 20,
                  vertical: isTablet ? 16 : 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search, size: isTablet ? 20 : 16),
                  SizedBox(width: isTablet ? 6 : 4),
                  Text(
                    'Search',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: isTablet ? 16 : 14,
                    ),
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
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Complete Travel Solutions',
            style: TextStyle(
              fontSize: isTablet ? 26 : 20,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Text(
            'Discover our comprehensive range of travel services',
            style: TextStyle(
              color: AppColors.mediumGray,
              fontSize: isTablet ? 16 : 14,
            ),
          ),
          SizedBox(height: isTablet ? 28 : 20),
          GridView.count(
            crossAxisCount: crossAxisCount,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: isTablet ? 1.1 : 1.2,
            crossAxisSpacing: isTablet ? 20 : 16,
            mainAxisSpacing: isTablet ? 20 : 16,
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
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
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
        padding: EdgeInsets.all(isTablet ? 20 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: isTablet ? 50 : 40,
                  height: isTablet ? 50 : 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: available
                          ? [AppColors.primaryOrange, AppColors.secondaryOrange]
                          : [AppColors.mediumGray, AppColors.mediumGray],
                    ),
                    borderRadius: BorderRadius.circular(isTablet ? 14 : 10),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: isTablet ? 26 : 20,
                  ),
                ),
                if (!available)
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 8 : 6,
                        vertical: isTablet ? 3 : 2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Soon',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 11 : 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: isTablet ? 12 : 8),
            Text(
              title,
              style: TextStyle(
                fontSize: isTablet ? 18 : 14,
                fontWeight: FontWeight.w600,
                color: available ? AppColors.darkGray : AppColors.mediumGray,
              ),
            ),
            SizedBox(height: isTablet ? 4 : 2),
            Expanded(
              child: Text(
                description,
                style: TextStyle(
                  color: AppColors.mediumGray,
                  fontSize: isTablet ? 14 : 11,
                  height: 1.2,
                ),
                maxLines: isTablet ? 3 : 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: isTablet ? 12 : 8),
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
                        fontSize: isTablet ? 18 : 14,
                        fontWeight: FontWeight.bold,
                        color: available
                            ? AppColors.primaryOrange
                            : AppColors.mediumGray,
                      ),
                    ),
                    Text(
                      statLabel,
                      style: TextStyle(
                        fontSize: isTablet ? 12 : 9,
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
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      margin: EdgeInsets.only(top: isTablet ? 40 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Destinations',
                style: TextStyle(
                  fontSize: isTablet ? 26 : 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGray,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontWeight: FontWeight.w500,
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 20 : 16),
          SizedBox(
            height: isTablet ? 200 : 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final destination = destinations[index];
                return Container(
                  width: isTablet ? 180 : 140,
                  margin: EdgeInsets.only(right: isTablet ? 20 : 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
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
                          bottom: isTablet ? 20 : 16,
                          left: isTablet ? 20 : 16,
                          right: isTablet ? 20 : 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                destination['name'] as String,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isTablet ? 20 : 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: isTablet ? 6 : 4),
                              Text(
                                destination['packages'] as String,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: isTablet ? 14 : 12,
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
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      margin: EdgeInsets.only(top: isTablet ? 40 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Packages',
                style: TextStyle(
                  fontSize: isTablet ? 26 : 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGray,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/packages');
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontWeight: FontWeight.w500,
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 20 : 16),
          SizedBox(
            height: isTablet ? 340 : 280,
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
      width: isTablet ? 280 : 240,
      margin: EdgeInsets.only(right: isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                height: isTablet ? 160 : 120,
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isTablet ? 20 : 16),
                    topRight: Radius.circular(isTablet ? 20 : 16),
                  ),
                ),
              ),
              Positioned(
                top: isTablet ? 12 : 8,
                right: isTablet ? 12 : 8,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 8 : 6, vertical: isTablet ? 3 : 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Available',
                    style: TextStyle(
                      color: const Color(0xFF059669),
                      fontSize: isTablet ? 11 : 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: isTablet ? 12 : 8,
                left: isTablet ? 12 : 8,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 8 : 6, vertical: isTablet ? 3 : 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: isTablet ? 14 : 10,
                      ),
                      SizedBox(width: isTablet ? 4 : 2),
                      Text(
                        package['location'] as String,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 12 : 9,
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
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 16 : 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 8 : 6,
                            vertical: isTablet ? 3 : 2),
                        decoration: BoxDecoration(
                          color: AppColors.lightOrange,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time,
                              size: isTablet ? 12 : 8,
                              color: AppColors.primaryOrange,
                            ),
                            SizedBox(width: isTablet ? 4 : 2),
                            Text(
                              package['duration'] as String,
                              style: TextStyle(
                                color: AppColors.primaryOrange,
                                fontSize: isTablet ? 12 : 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: AppColors.primaryOrange,
                            size: isTablet ? 16 : 12,
                          ),
                          SizedBox(width: isTablet ? 4 : 2),
                          Text(
                            package['rating'] as String,
                            style: TextStyle(
                              color: AppColors.primaryOrange,
                              fontSize: isTablet ? 14 : 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 10 : 6),
                  Text(
                    package['name'] as String,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGray,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            package['price'] as String,
                            style: TextStyle(
                              fontSize: isTablet ? 18 : 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGray,
                            ),
                          ),
                          Text(
                            '/person',
                            style: TextStyle(
                              fontSize: isTablet ? 12 : 9,
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
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 16 : 10,
                            vertical: isTablet ? 10 : 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size(0, isTablet ? 36 : 28),
                        ),
                        child: Text(
                          'Add to Cart',
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 11,
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
      padding: EdgeInsets.all(horizontalPadding),
      margin: EdgeInsets.only(top: isTablet ? 32 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: isTablet ? 26 : 20,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          SizedBox(height: isTablet ? 20 : 16),
          isTablet
              ? Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionCard(
                        icon: Icons.support_agent,
                        title: '24/7 Support',
                        subtitle: 'Get help anytime',
                        color: AppColors.primaryOrange,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildQuickActionCard(
                        icon: Icons.favorite_outline,
                        title: 'Wishlist',
                        subtitle: 'Saved packages',
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildQuickActionCard(
                        icon: Icons.local_offer,
                        title: 'Special Offers',
                        subtitle: 'Limited time deals',
                        color: Colors.green,
                      ),
                    ),
                    if (screenWidth >= 1200) ...[
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildQuickActionCard(
                          icon: Icons.map,
                          title: 'Travel Guide',
                          subtitle: 'Destination tips',
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ],
                )
              : Column(
                  children: [
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
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionCard(
                            icon: Icons.local_offer,
                            title: 'Special Offers',
                            subtitle: 'Limited time deals',
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildQuickActionCard(
                            icon: Icons.map,
                            title: 'Travel Guide',
                            subtitle: 'Destination tips',
                            color: Colors.blue,
                          ),
                        ),
                      ],
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
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
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
            width: isTablet ? 50 : 40,
            height: isTablet ? 50 : 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(isTablet ? 14 : 10),
            ),
            child: Icon(
              icon,
              color: color,
              size: isTablet ? 26 : 20,
            ),
          ),
          SizedBox(height: isTablet ? 16 : 12),
          Text(
            title,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          SizedBox(height: isTablet ? 6 : 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: isTablet ? 14 : 12,
              color: AppColors.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    // On tablets, we can show a more compact bottom navigation
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isTablet ? 24 : 20),
          topRight: Radius.circular(isTablet ? 24 : 20),
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
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isTablet ? 24 : 20),
          topRight: Radius.circular(isTablet ? 24 : 20),
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
          selectedLabelStyle: TextStyle(
            fontSize: isTablet ? 14 : 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: isTablet ? 14 : 12,
            fontWeight: FontWeight.w500,
          ),
          elevation: 0,
          iconSize: isTablet ? 28 : 24,
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
