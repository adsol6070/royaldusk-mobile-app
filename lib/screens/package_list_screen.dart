import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:royaldusk_mobile_app/constants/app_colors.dart';
import 'package:royaldusk_mobile_app/models/package.dart';
import 'package:royaldusk_mobile_app/screens/package_detail_screen.dart';
import 'package:royaldusk_mobile_app/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PackageListScreen extends StatefulWidget {
  const PackageListScreen({super.key});

  @override
  State<PackageListScreen> createState() => _PackageListScreenState();
}

class _PackageListScreenState extends State<PackageListScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();

  String _selectedCategory = 'All';
  String _selectedSortBy = 'Popular';
  String _searchQuery = '';
  bool _isListView = false;
  bool _isLoading = true;
  String? _errorMessage;

  // Contact information
  static const String bookingPhoneNumber = '+91-98761-49140';
  static const String bookingEmail = 'go@royaldusk.com';
  static const String whatsappNumber = '+919876149140';

  List<String> categories = ['All'];
  final List<String> sortOptions = [
    'Popular',
    'Price: Low to High',
    'Price: High to Low',
    'Duration',
    'Rating'
  ];

  List<Package> allPackages = [];

  List<Package> get filteredPackages {
    List<Package> filtered = allPackages;

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((p) =>
              p.category.name.toLowerCase() == _selectedCategory.toLowerCase())
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.location.name
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              p.description.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Sort packages using ApiService method
    return _apiService.sortPackages(filtered, _selectedSortBy);
  }

  @override
  void initState() {
    super.initState();
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

      // Load packages
      final packages = await _apiService.getPackages();

      // Load categories
      final categoriesList = await _apiService.getCategories();

      setState(() {
        allPackages = packages;
        categories = categoriesList;
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

  // Contact methods
  Future<void> _makePhoneCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: bookingPhoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      _showContactDialog();
    }
  }

  Future<void> _sendEmail(String packageName, String price) async {
    final subject = 'Booking Inquiry: $packageName';
    final body =
        'Dear Royal Dusk Tours,\n\nI am interested in booking the "$packageName" package (AED $price /person).\n\nPlease provide me with:\n- Detailed itinerary\n- Available dates\n- Booking process\n- Payment options\n\nThank you!\n\nBest regards';

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

  Future<void> _openWhatsAppWithPackage(
      String packageName, String price) async {
    final message =
        'Hi! I\'m interested in booking the "$packageName" package (AED $price /person). Could you please provide more details and help me with the booking?';
    final Uri whatsappUri = Uri.parse(
        'https://wa.me/$whatsappNumber?text=${Uri.encodeComponent(message)}');
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
                  _sendEmail('General Inquiry', '');
                },
              ),
              const SizedBox(height: 16),
              _buildContactOption(
                icon: Icons.chat,
                title: 'WhatsApp',
                subtitle: 'Chat with us instantly',
                onTap: () {
                  Navigator.pop(context);
                  _openWhatsAppWithPackage('General Inquiry', '');
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

  void _showBookingDialog(Package package) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(
                Icons.card_travel,
                color: AppColors.primaryOrange,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
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
                      package.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkGray,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 12, color: AppColors.mediumGray),
                        const SizedBox(width: 4),
                        Text(
                          package.location.name,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.mediumGray,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.access_time,
                            size: 12, color: AppColors.mediumGray),
                        const SizedBox(width: 4),
                        Text(
                          '${package.duration} days',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.mediumGray,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${package.currency} ${package.price} /person',
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
                  _openWhatsAppWithPackage(
                      package.name, package.price.toString());
                },
              ),
              const SizedBox(height: 12),
              _buildBookingOption(
                icon: Icons.email,
                title: 'Email Inquiry',
                subtitle: 'Get detailed information',
                onTap: () {
                  Navigator.pop(context);
                  _sendEmail(package.name, package.price.toString());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: _buildAppBar(),
      body: _isLoading
          ? _buildLoadingState()
          : _errorMessage != null
              ? _buildErrorState()
              : Column(
                  children: [
                    _buildSearchAndFilters(),
                    Expanded(
                      child: _buildPackagesList(),
                    ),
                  ],
                ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primaryOrange,
          ),
          SizedBox(height: 16),
          Text(
            'Loading packages...',
            style: TextStyle(
              color: AppColors.mediumGray,
              fontSize: 16,
            ),
          ),
        ],
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
          if (!_isLoading)
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
        IconButton(
          icon: const Icon(
            Icons.phone,
            color: AppColors.primaryOrange,
            size: 22,
          ),
          onPressed: _makePhoneCall,
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
          child: RefreshIndicator(
            onRefresh: _refreshPackages,
            color: AppColors.primaryOrange,
            child: _isListView ? _buildListView() : _buildGridView(),
          ),
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
    return GestureDetector(
      onTap: () => _navigateToPackageDetail(package),
      child: Container(
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
                // Tag badge
                if (package.tag.isNotEmpty)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color:
                            package.tag == 'Popular' ? Colors.red : Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        package.tag,
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
                          package.location.name.split(',').first,
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
                                '${package.duration} days',
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
                            const Text(
                              "5",
                              style: TextStyle(
                                color: AppColors.primaryOrange,
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              ' (${package.review})',
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
                            Text(
                              '${package.currency} ${package.price}',
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
                          onPressed: () => _navigateToPackageDetail(package),
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
                            'Book',
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
      ),
    );
  }

  Widget _buildPackageListCard(Package package) {
    return GestureDetector(
      onTap: () => _navigateToPackageDetail(package),
      child: Container(
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
                if (package.tag.isNotEmpty)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color:
                            package.tag == 'Popular' ? Colors.red : Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        package.tag,
                        style: const TextStyle(
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
                            const Text(
                              "5",
                              style: TextStyle(
                                color: AppColors.primaryOrange,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              ' (${package.review})',
                              style: const TextStyle(
                                color: AppColors.mediumGray,
                                fontSize: 8,
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
                          package.location.name,
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
                          '${package.duration} days',
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
                        Text(
                          '${package.currency} ${package.price}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _navigateToPackageDetail(package),
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
                            'Book Now',
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
      ),
    );
  }
}
