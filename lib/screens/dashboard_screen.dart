import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:royaldusk_mobile_app/constants/app_colors.dart';
import 'package:royaldusk_mobile_app/models/package.dart';
import 'package:royaldusk_mobile_app/models/tour.dart';
import 'package:royaldusk_mobile_app/services/package_api_service.dart';
import 'package:royaldusk_mobile_app/services/tour_api_service.dart';
import 'package:url_launcher/url_launcher.dart';

enum ServiceType {
  packages('Packages', 'Travel Packages',
      'Complete tour packages with accommodation'),
  flights('Flights', 'Flight Booking', 'Book flights at competitive prices'),
  hotels(
      'Hotels', 'Hotel Reservations', 'Find hotels with exclusive discounts'),
  tours('Tours', 'Custom Tours', 'Personalized tour experiences');

  const ServiceType(this.displayName, this.title, this.description);

  final String displayName;
  final String title;
  final String description;
}

abstract class DisplayableItem {
  String get id;
  String get name;
  String get imageUrl;
  String get locationName;
  String get locationImageUrl;
  String get tag;
  String get availability;
  double get price;
  String get currency;
  int get duration;
  int get review;
  String get durationLabel;
  String get priceLabel;
}

class PackageDisplayItem implements DisplayableItem {
  final Package package;

  PackageDisplayItem(this.package);

  @override
  String get id => package.id;

  @override
  String get name => package.name;

  @override
  String get imageUrl => package.imageUrl;

  @override
  String get locationName => package.location.name;

  @override
  String get locationImageUrl => package.location.imageUrl;

  @override
  String get tag => package.tag;

  @override
  String get availability => package.availability;

  @override
  double get price => package.price;

  @override
  String get currency => package.currency;

  @override
  int get duration => package.duration;

  @override
  int get review => package.review;

  @override
  String get durationLabel => '${package.duration} days';

  @override
  String get priceLabel => '/person';
}

class TourDisplayItem implements DisplayableItem {
  final Tour tour;

  TourDisplayItem(this.tour);

  @override
  String get id => tour.id;

  @override
  String get name => tour.name;

  @override
  String get imageUrl => tour.imageUrl;

  @override
  String get locationName => tour.location.name;

  @override
  String get locationImageUrl => tour.location.imageUrl;

  @override
  String get tag => tour.tag;

  @override
  String get availability => tour.tourAvailability;

  @override
  double get price => tour.price;

  @override
  String get currency => 'INR'; // Default currency for tours

  @override
  int get duration => 4; // Default tour duration in hours

  @override
  int get review => 25; // Default review count for tours

  @override
  String get durationLabel => '4 hours'; // Tours are typically in hours

  @override
  String get priceLabel => '/person';
}

class ServiceConfig {
  final ServiceType type;
  final IconData icon;
  final bool isAvailable;
  final String searchPlaceholder;
  final String featuredSectionTitle;
  final String destinationSectionTitle;
  final String routeName;

  const ServiceConfig({
    required this.type,
    required this.icon,
    required this.isAvailable,
    required this.searchPlaceholder,
    required this.featuredSectionTitle,
    required this.destinationSectionTitle,
    required this.routeName,
  });
}

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
  final PackageApiService _packageService = PackageApiService();
  final TourApiService _tourService = TourApiService();

  int _selectedServiceIndex = 0;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;
  List<Package> _allPackages = [];
  List<Tour> _allTours = [];
  // List<Package> featuredPackages = [];
  List<DisplayableItem> _currentFeaturedItems = [];
  Map<String, List<DisplayableItem>> _destinationGroups = {};
  // List<Package> featuredItems = [];

  // Contact information
  static const String bookingPhoneNumber = '+91-98761-49140';
  static const String bookingEmail = 'go@royaldusk.com';
  static const String whatsappNumber = '+919876149140';

  // Service configurations
  late final List<ServiceConfig> _serviceConfigs;

  @override
  void initState() {
    super.initState();
    _initializeServiceConfigs();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    // _loadPackages();
    _loadData();
  }

  void _initializeServiceConfigs() {
    _serviceConfigs = [
      const ServiceConfig(
        type: ServiceType.packages,
        icon: Icons.route,
        isAvailable: true,
        searchPlaceholder: 'e.g. Dubai, Beach holidays, Adventure packages...',
        featuredSectionTitle: 'Featured Packages',
        destinationSectionTitle: 'Popular Destinations',
        routeName: '/packages',
      ),
      const ServiceConfig(
        type: ServiceType.flights,
        icon: Icons.flight,
        isAvailable: false,
        searchPlaceholder: 'e.g. Mumbai to Dubai, Delhi to Paris...',
        featuredSectionTitle: 'Featured Flights',
        destinationSectionTitle: 'Popular Routes',
        routeName: '/flights',
      ),
      const ServiceConfig(
        type: ServiceType.hotels,
        icon: Icons.hotel,
        isAvailable: false,
        searchPlaceholder: 'e.g. Hotels in Dubai, Luxury resorts...',
        featuredSectionTitle: 'Featured Hotels',
        destinationSectionTitle: 'Top Hotel Destinations',
        routeName: '/hotels',
      ),
      const ServiceConfig(
        type: ServiceType.tours,
        icon: Icons.tour,
        isAvailable: true,
        searchPlaceholder:
            'e.g. City tours, Adventure tours, Cultural experiences...',
        featuredSectionTitle: 'Featured Tours',
        destinationSectionTitle: 'Popular Tour Destinations',
        routeName: '/tours',
      ),
    ];
  }

  ServiceConfig get _currentServiceConfig =>
      _serviceConfigs[_selectedServiceIndex];

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Load data based on selected service
      switch (_currentServiceConfig.type) {
        case ServiceType.packages:
          await _loadPackages();
          break;
        case ServiceType.tours:
          await _loadTours();
          break;
        case ServiceType.flights:
          await _loadFlights();
          break;
        case ServiceType.hotels:
          await _loadHotels();
          break;
      }

      _updateFeaturedItemsAndDestinations();
      _animationController.forward();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _loadPackages() async {
    final packages = await _packageService.getPackages();
    setState(() {
      _allPackages = packages;
      // Get first 5 packages as featured packages
      // featuredPackages = packages.take(5).toList();
      _isLoading = false;
    });
    _animationController.forward();
  }

  Future<void> _loadTours() async {
    final tours = await _tourService.getTours();
    setState(() {
      _allTours = tours;
      _isLoading = false;
    });
  }

  Future<void> _loadFlights() async {
    // TODO: Implement flights API call when available
    setState(() {
      // allPackages = [];
      // featuredItems = [];
      _isLoading = false;
    });
  }

  Future<void> _loadHotels() async {
    // TODO: Implement hotels API call when available
    setState(() {
      // allPackages = [];
      // featuredItems = [];
      _isLoading = false;
    });
  }

  void _updateFeaturedItemsAndDestinations() {
    List<DisplayableItem> allItems = [];
    Map<String, List<DisplayableItem>> destinationGroups = {};

    switch (_currentServiceConfig.type) {
      case ServiceType.packages:
        allItems = _allPackages.map((p) => PackageDisplayItem(p)).toList();
        break;
      case ServiceType.tours:
        allItems = _allTours.map((t) => TourDisplayItem(t)).toList();
        break;
      case ServiceType.flights:
      case ServiceType.hotels:
        allItems = []; // Empty for unavailable services
        break;
    }

    // Group by destination
    for (var item in allItems) {
      String destination = item.locationName;
      if (!destinationGroups.containsKey(destination)) {
        destinationGroups[destination] = [];
      }
      destinationGroups[destination]!.add(item);
    }

    setState(() {
      _currentFeaturedItems = allItems.take(5).toList();
      _destinationGroups = destinationGroups;
    });
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  void _onServiceTabChanged(int index) {
    if (_selectedServiceIndex != index) {
      setState(() {
        _selectedServiceIndex = index;
        _searchController.clear();
        _searchQuery = '';
      });

      // Load data for the new service
      _loadData();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToItemDetail(DisplayableItem item) {
    // Navigate based on service type
    switch (_currentServiceConfig.type) {
      case ServiceType.packages:
        final packageItem = item as PackageDisplayItem;
        Navigator.pushNamed(
          context,
          '/package-detail',
          arguments: {'package': packageItem.package},
        );
        break;
      case ServiceType.tours:
        final tourItem = item as TourDisplayItem;
        Navigator.pushNamed(
          context,
          '/tour-detail',
          arguments: {'tour': tourItem.tour},
        );
        break;
      case ServiceType.flights:
        // Handle flight selection
        _showContactDialog();
        break;
      case ServiceType.hotels:
        // Handle hotel selection
        _showContactDialog();
        break;
    }
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

    // Navigate to appropriate screen with search query
    Navigator.pushNamed(
      context,
      _currentServiceConfig.routeName,
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
              // onPressed: _refreshPackages,
              onPressed: _refreshData,
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
        // onRefresh: _refreshPackages,
        onRefresh: _refreshData,
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
                    _buildFeaturedItems(),
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
                  'Find Your Perfect ${_currentServiceConfig.type.displayName}',
                  style: TextStyle(
                    fontSize: isTablet ? 26 : 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGray,
                  ),
                ),
                SizedBox(height: isTablet ? 12 : 8),
                Text(
                  'Search across our comprehensive ${_currentServiceConfig.type.displayName.toLowerCase()} services',
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightOrange,
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
      ),
      padding: EdgeInsets.all(isTablet ? 6 : 4),
      child: Row(
        children: _serviceConfigs.asMap().entries.map((entry) {
          return Expanded(
            child: _buildServiceTab(entry.key, entry.value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildServiceTab(int index, ServiceConfig config) {
    final isSelected = _selectedServiceIndex == index;
    final isAvailable = config.isAvailable;

    return GestureDetector(
      onTap: isAvailable ? () => _onServiceTabChanged(index) : null,
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
              config.icon,
              color: isSelected
                  ? Colors.white
                  : isAvailable
                      ? AppColors.mediumGray
                      : AppColors.mediumGray.withValues(alpha: 0.5),
              size: isTablet ? 26 : 20,
            ),
            SizedBox(height: isTablet ? 6 : 4),
            Text(
              config.type.displayName,
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
                hintText: _currentServiceConfig.searchPlaceholder,
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
            children: _serviceConfigs.map((config) {
              return _buildServiceCard(
                icon: config.icon,
                title: config.type.title,
                description: config.type.description,
                available: config.isAvailable,
                stat: config.isAvailable
                    ? '${_getItemCountForService(config.type)}+'
                    : 'Soon',
                statLabel: config.type.displayName,
                onTap: config.isAvailable
                    ? () => Navigator.pushNamed(context, config.routeName)
                    : () => _showContactDialog(),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  int _getItemCountForService(ServiceType serviceType) {
    switch (serviceType) {
      case ServiceType.packages:
        return _allPackages.length;
      case ServiceType.tours:
        return _allTours.length;
      case ServiceType.flights:
      case ServiceType.hotels:
        return 0;
    }
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
    // Convert to list and take top 4 destinations by item count
    List<MapEntry<String, List<DisplayableItem>>> destinations =
        _destinationGroups.entries.toList();
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
                _currentServiceConfig.destinationSectionTitle,
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
                final itemCount = entry.value.length;
                final firstItem = entry.value.first;

                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    _currentServiceConfig.routeName,
                    arguments: {
                      'searchQuery': destinationName,
                      'serviceType': _currentServiceConfig.type.name,
                    },
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
                              firstItem.locationImageUrl,
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
                                  '$itemCount ${_currentServiceConfig.type.displayName.toLowerCase()}${itemCount > 1 ? '' : ''}',
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

  Widget _buildFeaturedItems() {
    if (_currentFeaturedItems.isEmpty) {
      return const SizedBox.shrink(); // Don't show section if no items
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
                _currentServiceConfig.featuredSectionTitle,
                style: TextStyle(
                  fontSize: isTablet ? 26 : 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGray,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(
                    context, _currentServiceConfig.routeName),
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
              itemCount: _currentFeaturedItems.length,
              itemBuilder: (context, index) {
                return _buildItemCard(_currentFeaturedItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(DisplayableItem item) {
    // Get service-specific labels
    String actionButtonText;

    switch (_currentServiceConfig.type) {
      case ServiceType.packages:
        actionButtonText = 'Book Now';
        break;
      case ServiceType.tours:
        actionButtonText = 'Book Tour';
        break;
      case ServiceType.flights:
        actionButtonText = 'Book Flight';
        break;
      case ServiceType.hotels:
        actionButtonText = 'Book Hotel';
        break;
    }

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
                    item.imageUrl,
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
              if (item.tag.isNotEmpty)
                Positioned(
                  top: isTablet ? 12 : 8,
                  left: isTablet ? 12 : 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 8 : 6,
                        vertical: isTablet ? 3 : 2),
                    decoration: BoxDecoration(
                      color: item.tag == 'Popular' ? Colors.red : Colors.blue,
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
                      item.tag,
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
                    item.availability,
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
                        item.locationName,
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
                              _currentServiceConfig.type == ServiceType.tours
                                  ? Icons.schedule
                                  : Icons.access_time,
                              size: isTablet ? 12 : 8,
                              color: AppColors.primaryOrange,
                            ),
                            SizedBox(width: isTablet ? 4 : 2),
                            Text(
                              item.durationLabel,
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
                            ' (${item.review})',
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
                    item.name,
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
                            '${item.currency} ${item.price}',
                            style: TextStyle(
                              fontSize: isTablet ? 18 : 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryOrange,
                            ),
                          ),
                          Text(
                            item.priceLabel,
                            style: TextStyle(
                              fontSize: isTablet ? 12 : 9,
                              color: AppColors.mediumGray,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => _navigateToItemDetail(item),
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
                          actionButtonText,
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
