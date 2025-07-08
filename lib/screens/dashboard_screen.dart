import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:royaldusk_mobile_app/constants/app_colors.dart';
import 'package:royaldusk_mobile_app/models/package.dart';
import 'package:royaldusk_mobile_app/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatefulWidget {
  final bool showAppBar;
  const DashboardScreen({super.key, this.showAppBar = true});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  final ApiService _apiService = ApiService();

  int _selectedServiceIndex = 0;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;
  List<Package> allPackages = [];
  List<Package> featuredPackages = [];

  // Contact information
  static const String bookingPhoneNumber = '+91-98761-49140';
  static const String bookingEmail = 'go@royaldusk.com';
  static const String whatsappNumber = '+919876149140';

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadPackages();
  }

  Future<void> _loadPackages() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Load packages from API
      final packages = await _apiService.getPackages();

      setState(() {
        allPackages = packages;
        // Get first 5 packages as featured packages
        featuredPackages = packages.take(5).toList();
        _isLoading = false;
      });

      _animationController.forward();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _refreshPackages() async {
    await _loadPackages();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToPackageDetail(Package package) {
    Navigator.pushNamed(
      context,
      '/package-detail',
      arguments: {'package': package},
    );
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

  // Contact methods
  Future<void> _makePhoneCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: bookingPhoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      _showContactDialog();
    }
  }

  Future<void> _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: bookingEmail,
      query: 'subject=Package Booking Inquiry',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      _showContactDialog();
    }
  }

  Future<void> _openWhatsApp() async {
    final Uri whatsappUri = Uri.parse(
        'https://wa.me/$whatsappNumber?text=Hi, I would like to inquire about your travel packages.');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      _showContactDialog();
    }
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(
                Icons.contact_phone,
                color: AppColors.primaryOrange,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Contact Us',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Get in touch with us to book your perfect trip:',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.mediumGray,
                ),
              ),
              const SizedBox(height: 20),
              _buildContactOption(
                icon: Icons.phone,
                title: 'Call Us',
                subtitle: bookingPhoneNumber,
                onTap: () {
                  Navigator.pop(context);
                  _makePhoneCall();
                },
              ),
              const SizedBox(height: 16),
              _buildContactOption(
                icon: Icons.email,
                title: 'Email Us',
                subtitle: bookingEmail,
                onTap: () {
                  Navigator.pop(context);
                  _sendEmail();
                },
              ),
              const SizedBox(height: 16),
              _buildContactOption(
                icon: Icons.chat,
                title: 'WhatsApp',
                subtitle: 'Chat with us instantly',
                onTap: () {
                  Navigator.pop(context);
                  _openWhatsApp();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Close',
                style: TextStyle(color: AppColors.mediumGray),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.lightOrange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryOrange,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mediumGray,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.mediumGray,
            ),
          ],
        ),
      ),
    );
  }

  void _performSearch() {
    if (_searchQuery.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a search term'),
          backgroundColor: AppColors.primaryOrange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    // Navigate to packages screen with search query
    Navigator.pushNamed(
      context,
      '/packages',
      arguments: {'searchQuery': _searchQuery},
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryOrange,
      ),
    );
  }

  Widget _buildErrorState() {
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
                Icons.error_outline,
                size: 40,
                color: AppColors.primaryOrange,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Unable to load packages',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'An unexpected error occurred',
              style: const TextStyle(
                color: AppColors.mediumGray,
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _refreshPackages,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: RefreshIndicator(
        onRefresh: _refreshPackages,
        color: AppColors.primaryOrange,
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildSearchWidget(),
                  _buildServicesSection(),
                  _buildPopularDestinations(),
                  if (_isLoading)
                    Padding(
                      padding: EdgeInsets.all(horizontalPadding),
                      child: _buildLoadingState(),
                    )
                  else if (_errorMessage != null)
                    Padding(
                      padding: EdgeInsets.all(horizontalPadding),
                      child: _buildErrorState(),
                    )
                  else
                    _buildFeaturedPackages(),
                  _buildQuickActions(),
                  SizedBox(
                      height: isTablet
                          ? 120
                          : 100), // Bottom padding for navigation
                ],
              ),
            ),
          ],
        ),
      ),
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
                      _buildHeaderIconButton(Icons.phone, _makePhoneCall),
                      SizedBox(width: isTablet ? 12 : 8),
                      _buildHeaderIconButton(Icons.chat, _openWhatsApp),
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
                hintText: 'e.g. Dubai, Adventure tours, Beach holidays...',
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
              onSubmitted: (value) {
                _performSearch();
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(isTablet ? 6 : 4),
            child: ElevatedButton(
              onPressed: _performSearch,
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
                stat: '${allPackages.length}+',
                statLabel: 'Packages',
                onTap: () => Navigator.pushNamed(context, '/packages'),
              ),
              _buildServiceCard(
                icon: Icons.flight,
                title: 'Flight Booking',
                description: 'Book flights at competitive prices',
                available: false,
                stat: 'Soon',
                statLabel: 'Airlines',
                onTap: () => _showContactDialog(),
              ),
              _buildServiceCard(
                icon: Icons.hotel,
                title: 'Hotel Reservations',
                description: 'Find hotels with exclusive discounts',
                available: false,
                stat: 'Soon',
                statLabel: 'Properties',
                onTap: () => _showContactDialog(),
              ),
              _buildServiceCard(
                icon: Icons.tour,
                title: 'Custom Tours',
                description: 'Personalized tour experiences',
                available: false,
                stat: 'Soon',
                statLabel: 'Experiences',
                onTap: () => _showContactDialog(),
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
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                            ? [
                                AppColors.primaryOrange,
                                AppColors.secondaryOrange
                              ]
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
      ),
    );
  }

  Widget _buildPopularDestinations() {
    // Get unique destinations from packages
    Map<String, List<Package>> destinationGroups = {};
    for (var package in allPackages) {
      String destination = package.location.name;
      if (!destinationGroups.containsKey(destination)) {
        destinationGroups[destination] = [];
      }
      destinationGroups[destination]!.add(package);
    }

    // Convert to list and take top 4 destinations by package count
    List<MapEntry<String, List<Package>>> destinations =
        destinationGroups.entries.toList();
    destinations.sort((a, b) => b.value.length.compareTo(a.value.length));
    destinations = destinations.take(4).toList();

    if (destinations.isEmpty) {
      return const SizedBox.shrink(); // Don't show section if no destinations
    }

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
            ],
          ),
          SizedBox(height: isTablet ? 20 : 16),
          SizedBox(
            height: isTablet ? 200 : 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final entry = destinations[index];
                final destinationName = entry.key;
                final packageCount = entry.value.length;
                final firstPackage = entry.value.first;

                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/packages',
                    arguments: {'searchQuery': destinationName},
                  ),
                  child: Container(
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
                          // Background Image
                          Positioned.fill(
                            child: Image.network(
                              firstPackage.location.imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Container(
                                  color: AppColors.lightOrange,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                      strokeWidth: 2,
                                      color: AppColors.primaryOrange,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppColors.lightOrange,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: AppColors.primaryOrange,
                                        size: isTablet ? 32 : 24,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Image not available',
                                        style: TextStyle(
                                          color: AppColors.primaryOrange,
                                          fontSize: isTablet ? 12 : 10,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          // Gradient Overlay
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    AppColors.darkGray.withValues(alpha: 0.7),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Text Content
                          Positioned(
                            bottom: isTablet ? 20 : 16,
                            left: isTablet ? 20 : 16,
                            right: isTablet ? 20 : 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  destinationName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isTablet ? 20 : 16,
                                    fontWeight: FontWeight.w600,
                                    shadows: [
                                      Shadow(
                                        offset: const Offset(0, 1),
                                        blurRadius: 3,
                                        color:
                                            Colors.black.withValues(alpha: 0.5),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: isTablet ? 6 : 4),
                                Text(
                                  '$packageCount package${packageCount > 1 ? 's' : ''}',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: isTablet ? 14 : 12,
                                    shadows: [
                                      Shadow(
                                        offset: const Offset(0, 1),
                                        blurRadius: 3,
                                        color:
                                            Colors.black.withValues(alpha: 0.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
    if (featuredPackages.isEmpty) {
      return const SizedBox.shrink(); // Don't show section if no packages
    }

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
                onPressed: () => Navigator.pushNamed(context, '/packages'),
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
              itemCount: featuredPackages.length,
              itemBuilder: (context, index) {
                return _buildPackageCard(featuredPackages[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageCard(Package package) {
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
              // Background Image
              Container(
                height: isTablet ? 160 : 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isTablet ? 20 : 16),
                    topRight: Radius.circular(isTablet ? 20 : 16),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isTablet ? 20 : 16),
                    topRight: Radius.circular(isTablet ? 20 : 16),
                  ),
                  child: Image.network(
                    package.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Container(
                        color: AppColors.primaryOrange.withValues(alpha: 0.2),
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.primaryOrange.withValues(alpha: 0.2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported_outlined,
                              color: AppColors.primaryOrange,
                              size: isTablet ? 32 : 24,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Image not available',
                              style: TextStyle(
                                color: AppColors.primaryOrange,
                                fontSize: isTablet ? 12 : 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Tag Badge
              if (package.tag.isNotEmpty)
                Positioned(
                  top: isTablet ? 12 : 8,
                  left: isTablet ? 12 : 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 8 : 6,
                        vertical: isTablet ? 3 : 2),
                    decoration: BoxDecoration(
                      color:
                          package.tag == 'Popular' ? Colors.red : Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      package.tag,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 11 : 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              // Available Badge
              Positioned(
                top: isTablet ? 12 : 8,
                right: isTablet ? 12 : 8,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 8 : 6, vertical: isTablet ? 3 : 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    package.availability,
                    style: TextStyle(
                      color: const Color(0xFF059669),
                      fontSize: isTablet ? 11 : 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // Location Badge
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
                        package.location.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 12 : 9,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                              color: Colors.black.withValues(alpha: 0.5),
                            ),
                          ],
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
                              '${package.duration} days',
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
                            '5',
                            style: TextStyle(
                              color: AppColors.primaryOrange,
                              fontSize: isTablet ? 14 : 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            ' (${package.review})',
                            style: TextStyle(
                              color: AppColors.mediumGray,
                              fontSize: isTablet ? 12 : 9,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 10 : 6),
                  Text(
                    package.name,
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
                            '${package.currency} ${package.price}',
                            style: TextStyle(
                              fontSize: isTablet ? 18 : 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryOrange,
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
                        onPressed: () => _navigateToPackageDetail(package),
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
                          'Book Now',
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
                        onTap: _showContactDialog,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildQuickActionCard(
                        icon: Icons.phone,
                        title: 'Call Us',
                        subtitle: bookingPhoneNumber,
                        color: Colors.green,
                        onTap: _makePhoneCall,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildQuickActionCard(
                        icon: Icons.chat,
                        title: 'WhatsApp',
                        subtitle: 'Chat instantly',
                        color: Colors.green,
                        onTap: _openWhatsApp,
                      ),
                    ),
                    if (screenWidth >= 1200) ...[
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildQuickActionCard(
                          icon: Icons.email,
                          title: 'Email Us',
                          subtitle: 'Send inquiry',
                          color: Colors.blue,
                          onTap: _sendEmail,
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
                            onTap: _showContactDialog,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildQuickActionCard(
                            icon: Icons.phone,
                            title: 'Call Us',
                            subtitle: bookingPhoneNumber,
                            color: Colors.green,
                            onTap: _makePhoneCall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionCard(
                            icon: Icons.chat,
                            title: 'WhatsApp',
                            subtitle: 'Chat instantly',
                            color: Colors.green,
                            onTap: _openWhatsApp,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildQuickActionCard(
                            icon: Icons.email,
                            title: 'Email Us',
                            subtitle: 'Send inquiry',
                            color: Colors.blue,
                            onTap: _sendEmail,
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
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
