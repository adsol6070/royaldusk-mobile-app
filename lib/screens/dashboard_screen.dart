import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:royaldusk_mobile_app/constants/app_colors.dart';
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
  int _selectedServiceIndex = 0;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Contact information
  static const String bookingPhoneNumber = '+91-98761-49140';
  static const String bookingEmail = 'go@royaldusk.com';
  static const String whatsappNumber =
      '+919876149140'; // Without dashes for WhatsApp

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
          title: Row(
            children: [
              Icon(
                Icons.contact_phone,
                color: AppColors.primaryOrange,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
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

  void _showBookingDialog(String packageName, String price) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(
                Icons.card_travel,
                color: AppColors.primaryOrange,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Book Package',
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lightOrange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Package: $packageName',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkGray,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Price: $price /person',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Choose your preferred booking method:',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.mediumGray,
                ),
              ),
              const SizedBox(height: 16),
              _buildBookingOption(
                icon: Icons.phone,
                title: 'Call to Book',
                subtitle: 'Speak with our travel experts',
                onTap: () {
                  Navigator.pop(context);
                  _makePhoneCall();
                },
              ),
              const SizedBox(height: 12),
              _buildBookingOption(
                icon: Icons.chat,
                title: 'WhatsApp Booking',
                subtitle: 'Quick booking via WhatsApp',
                onTap: () {
                  Navigator.pop(context);
                  _openWhatsAppWithPackage(packageName, price);
                },
              ),
              const SizedBox(height: 12),
              _buildBookingOption(
                icon: Icons.email,
                title: 'Email Inquiry',
                subtitle: 'Get detailed information',
                onTap: () {
                  Navigator.pop(context);
                  _sendEmailWithPackage(packageName, price);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.mediumGray),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBookingOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.lightOrange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryOrange,
                size: 18,
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
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGray,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.mediumGray,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: AppColors.mediumGray,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openWhatsAppWithPackage(
      String packageName, String price) async {
    final message =
        'Hi! I\'m interested in booking the "$packageName" package ($price /person). Could you please provide more details and help me with the booking?';
    final Uri whatsappUri = Uri.parse(
        'https://wa.me/$whatsappNumber?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      _showContactDialog();
    }
  }

  Future<void> _sendEmailWithPackage(String packageName, String price) async {
    final subject = 'Booking Inquiry: $packageName';
    final body =
        'Dear Royal Dusk Tours,\n\nI am interested in booking the "$packageName" package ($price /person).\n\nPlease provide me with:\n- Detailed itinerary\n- Available dates\n- Booking process\n- Payment options\n\nThank you!\n\nBest regards';

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: bookingEmail,
      query:
          'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      _showContactDialog();
    }
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

    // Show search results dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Search Results for "$_searchQuery"'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('We found several packages matching your search:'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lightOrange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Contact our travel experts to get personalized recommendations based on your search criteria.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.darkGray,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showContactDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Contact Us'),
            ),
          ],
        );
      },
    );
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
                stat: '120+',
                statLabel: 'Packages',
                onTap: () => _showContactDialog(),
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
    final destinations = [
      {
        'name': 'Manali',
        'packages': '15 packages',
        'image':
            'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      },
      {
        'name': 'Goa',
        'packages': '12 packages',
        'image':
            'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      },
      {
        'name': 'Kerala',
        'packages': '18 packages',
        'image':
            'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      },
      {
        'name': 'Rajasthan',
        'packages': '22 packages',
        'image':
            'https://images.unsplash.com/photo-1477587458883-47145ed94245?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
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
              // TextButton(
              //   onPressed: _showContactDialog,
              //   child: Text(
              //     'View All',
              //     style: TextStyle(
              //       color: AppColors.primaryOrange,
              //       fontWeight: FontWeight.w500,
              //       fontSize: isTablet ? 16 : 14,
              //     ),
              //   ),
              // ),
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
                return GestureDetector(
                  onTap: () => _showContactDialog(),
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
                              destination['image'] as String,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Container(
                                  color: Colors.grey[300],
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
                                  color: Colors.grey[300],
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.grey[600],
                                        size: isTablet ? 32 : 24,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Image not available',
                                        style: TextStyle(
                                          color: Colors.grey[600],
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
                                  destination['name'] as String,
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
                                  destination['packages'] as String,
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
                // onPressed: _showContactDialog,
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
        'image':
            'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
      },
      {
        'name': 'Goa Beach Paradise',
        'location': 'Goa',
        'duration': '4 Days',
        'price': '₹12,999',
        'rating': '4.8',
        'image':
            'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
      },
      {
        'name': 'Kerala Backwaters',
        'location': 'Kerala',
        'duration': '6 Days',
        'price': '₹18,999',
        'rating': '4.6',
        'image':
            'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
      },
      {
        'name': 'Rajasthan Heritage Tour',
        'location': 'Rajasthan',
        'duration': '7 Days',
        'price': '₹22,999',
        'rating': '4.7',
        'image':
            'https://images.unsplash.com/photo-1477587458883-47145ed94245?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
      },
      {
        'name': 'Himachal Hill Station',
        'location': 'Himachal Pradesh',
        'duration': '5 Days',
        'price': '₹16,999',
        'rating': '4.4',
        'image':
            'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=800&q=80',
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
                    package['image'] as String,
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
                    'Available',
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
                        package['location'] as String,
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
                        onPressed: () {
                          _showBookingDialog(
                            package['name'] as String,
                            package['price'] as String,
                          );
                        },
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
