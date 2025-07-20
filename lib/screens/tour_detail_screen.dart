import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:royaldusk_mobile_app/constants/app_colors.dart';
import 'package:royaldusk_mobile_app/models/tour.dart';
import 'package:royaldusk_mobile_app/screens/booking_form_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class TourDetailScreen extends StatefulWidget {
  final Tour tour;

  const TourDetailScreen({
    super.key,
    required this.tour,
  });

  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late TabController _tabController;

  // Contact information
  static const String bookingPhoneNumber = '+91-98761-49140';
  static const String bookingEmail = 'go@royaldusk.com';
  static const String whatsappNumber = '+919876149140';

  // Mock data for tabs since Tour model doesn't have these fields
  final List<Map<String, String>> _tourHighlights = [
    {
      'title': 'Professional Guide',
      'description': 'Expert local guide with extensive knowledge of the area'
    },
    {
      'title': 'Small Groups',
      'description': 'Maximum 12 participants for personalized experience'
    },
    {
      'title': 'Photography',
      'description': 'Perfect spots for memorable photos and scenic views'
    },
    {
      'title': 'Cultural Insights',
      'description': 'Learn about local culture, history, and traditions'
    },
  ];

  final List<String> _tourInclusions = [
    'Professional tour guide',
    'Transportation in air-conditioned vehicle',
    'Entry tickets to attractions',
    'Refreshments during the tour',
    'Photo opportunities',
    'Cultural presentations',
    'Safety equipment',
    'Insurance coverage',
  ];

  final List<String> _tourExclusions = [
    'Personal expenses',
    'Gratuities for guide',
    'Meals (unless specified)',
    'Shopping purchases',
    'Additional activities',
    'Hotel pickup/drop-off',
    'Travel insurance',
    'Camera fees at monuments',
  ];

  final Map<String, String> _tourPolicies = {
    'Booking Policy':
        'Advance booking required. Confirmation within 24 hours. Valid photo ID required for all participants.',
    'Cancellation Policy':
        'Free cancellation up to 24 hours before tour start. 50% refund for cancellations within 24 hours. No refund for no-shows.',
    'Age Requirements':
        'Suitable for ages 8 and above. Children must be accompanied by adults. Senior-friendly tour options available.',
    'Weather Policy':
        'Tours operate in most weather conditions. In case of extreme weather, tours may be rescheduled or refunded.',
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _tabController = TabController(length: 4, vsync: this);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Helper methods to get tour-specific information
  String get _tourDuration {
    // For tours, duration is typically in hours
    return '4-6 hours'; // Default duration for tours
  }

  String get _tourRating {
    // Generate a rating based on tour name hash for consistency
    final hash = widget.tour.name.hashCode.abs();
    final rating = 4.0 + (hash % 10) / 10.0;
    return rating.toStringAsFixed(1);
  }

  int get _reviewCount {
    // Generate review count based on tour ID hash
    final hash = widget.tour.id.hashCode.abs();
    return 50 + (hash % 150); // Between 50-200 reviews
  }

  String get _groupSize {
    return 'Max 12 people';
  }

  String get _meetingPoint {
    return 'Central meeting point in ${widget.tour.location.name}';
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

  Future<void> _sendEmail(
      String tourName, String price, String currency) async {
    final subject = 'Tour Booking Inquiry: $tourName';
    final body =
        'Dear Royal Dusk Tours,\n\nI am interested in booking the "$tourName" tour ($currency $price /person).\n\nPlease provide me with:\n- Available time slots\n- Meeting point details\n- What to bring\n- Booking confirmation process\n\nThank you!\n\nBest regards';

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

  Future<void> _openWhatsAppWithTour(
      String tourName, String price, String currency) async {
    final message =
        'Hi! I\'m interested in booking the "$tourName" tour ($currency $price /person). Could you please provide available time slots and help me with the booking?';
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
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Get in touch with us to book your perfect tour:',
                style: TextStyle(fontSize: 14, color: AppColors.mediumGray),
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
                  _sendEmail('General Inquiry', '', '');
                },
              ),
              const SizedBox(height: 16),
              _buildContactOption(
                icon: Icons.chat,
                title: 'WhatsApp',
                subtitle: 'Chat with us instantly',
                onTap: () {
                  Navigator.pop(context);
                  _openWhatsAppWithTour('General Inquiry', '', '');
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
              child: Icon(icon, color: AppColors.primaryOrange, size: 20),
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
            const Icon(Icons.arrow_forward_ios,
                size: 14, color: AppColors.mediumGray),
          ],
        ),
      ),
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
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _animationController,
                  child: Column(
                    children: [
                      _buildTourHeader(),
                      _buildTabBar(),
                      _buildTabContent(),
                      _buildBookingSection(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(Icons.share, color: Colors.white, size: 20),
            onPressed: () {
              // Share functionality
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.tour.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.lightOrange,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.tour,
                        size: 64,
                        color: AppColors.primaryOrange,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Tour Image',
                        style: TextStyle(
                          color: AppColors.primaryOrange,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
            // Tag badge
            if (widget.tour.tag.isNotEmpty)
              Positioned(
                top: 60,
                left: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: widget.tour.tag.toLowerCase() == 'popular'
                        ? Colors.red
                        : Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.tour.tag,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            // Availability badge
            // Positioned(
            //   top: 60,
            //   right: 16,
            //   child: Container(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            //     decoration: BoxDecoration(
            //       // color: widget.tour.isAvailable ? Colors.green : Colors.orange,
            //       color: Colors.green,
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //     child: Text(
            //       widget.tour.displayAvailability,
            //       style: const TextStyle(
            //         color: Colors.white,
            //         fontSize: 12,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //   ),
            // ),
            // Location
            Positioned(
              bottom: 20,
              left: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on,
                        color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      widget.tour.location.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
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

  Widget _buildTourHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.tour.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGray,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.lightOrange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star,
                        color: AppColors.primaryOrange, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      _tourRating,
                      style: const TextStyle(
                        color: AppColors.primaryOrange,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      ' ($_reviewCount)',
                      style: const TextStyle(
                        color: AppColors.mediumGray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(
                icon: Icons.schedule,
                text: _tourDuration,
              ),
              const SizedBox(width: 12),
              _buildInfoChip(
                icon: Icons.group,
                text: _groupSize,
              ),
              const SizedBox(width: 12),
              _buildInfoChip(
                icon: Icons.category,
                text: widget.tour.category.name,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.tour.description,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.mediumGray,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lightOrange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    color: AppColors.primaryOrange, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Meeting Point: $_meetingPoint',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.darkGray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.mediumGray),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.mediumGray,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primaryOrange,
        unselectedLabelColor: AppColors.mediumGray,
        indicatorColor: AppColors.primaryOrange,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Highlights'),
          Tab(text: 'Inclusions'),
          Tab(text: 'Policies'),
          Tab(text: 'Schedule'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return Container(
      height: 400,
      color: Colors.white,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildHighlightsTab(),
          _buildInclusionsTab(),
          _buildPoliciesTab(),
          _buildScheduleTab(),
        ],
      ),
    );
  }

  Widget _buildHighlightsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _tourHighlights.length,
      itemBuilder: (context, index) {
        final highlight = _tourHighlights[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      highlight['title']!.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                highlight['description']!,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.mediumGray,
                  height: 1.4,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInclusionsTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What\'s Included',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 16),
          ..._tourInclusions.map((inclusion) => _buildInclusionItem(
                icon: Icons.check_circle,
                text: inclusion,
                isIncluded: true,
              )),
          const SizedBox(height: 24),
          const Text(
            'What\'s Not Included',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 16),
          ..._tourExclusions.map((exclusion) => _buildInclusionItem(
                icon: Icons.cancel,
                text: exclusion,
                isIncluded: false,
              )),
        ],
      ),
    );
  }

  Widget _buildInclusionItem({
    required IconData icon,
    required String text,
    required bool isIncluded,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isIncluded ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text.toUpperCase(),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.darkGray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoliciesTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: _tourPolicies.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildPolicyItem(
              title: entry.key,
              content: entry.value,
              icon: _getPolicyIcon(entry.key),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPolicyItem({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primaryOrange),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.mediumGray,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Time Slots',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 16),
          _buildTimeSlot(
            time: '09:00 AM - 01:00 PM',
            description: 'Morning tour with cooler temperatures',
            isAvailable: true,
          ),
          const SizedBox(height: 12),
          _buildTimeSlot(
            time: '02:00 PM - 06:00 PM',
            description: 'Afternoon tour with vibrant lighting',
            isAvailable: true,
          ),
          const SizedBox(height: 12),
          _buildTimeSlot(
            time: '06:30 PM - 10:30 PM',
            description: 'Evening tour with sunset views',
            // isAvailable: widget.tour.isAvailable,
            isAvailable: true,
          ),
          const SizedBox(height: 24),
          const Text(
            'Important Notes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 16),
          _buildImportantNote(
            icon: Icons.schedule,
            text: 'Please arrive 15 minutes before tour start time',
          ),
          _buildImportantNote(
            icon: Icons.phone,
            text: 'Contact us for private group arrangements',
          ),
          _buildImportantNote(
            icon: Icons.wb_sunny,
            text: 'Tours operate in most weather conditions',
          ),
          _buildImportantNote(
            icon: Icons.camera_alt,
            text: 'Photography is allowed and encouraged',
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlot({
    required String time,
    required String description,
    required bool isAvailable,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAvailable ? Colors.white : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAvailable ? AppColors.primaryOrange : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isAvailable ? AppColors.lightOrange : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.access_time,
              color: isAvailable ? AppColors.primaryOrange : Colors.grey[500],
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isAvailable ? AppColors.darkGray : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        isAvailable ? AppColors.mediumGray : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isAvailable ? Colors.green : Colors.grey[400],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isAvailable ? 'Available' : 'Full',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantNote({
    required IconData icon,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryOrange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.darkGray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPolicyIcon(String policyType) {
    switch (policyType.toLowerCase()) {
      case 'booking policy':
        return Icons.book_online;
      case 'cancellation policy':
        return Icons.cancel_schedule_send;
      case 'age requirements':
        return Icons.people;
      case 'weather policy':
        return Icons.wb_sunny;
      default:
        return Icons.policy;
    }
  }

  Widget _buildBookingSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Starting from',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.mediumGray,
                      ),
                    ),
                    Text(
                      'AED ${widget.tour.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                    const Text(
                      '/person',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.mediumGray,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BookingFormScreen.fromTour(tour: widget.tour),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  // backgroundColor: widget.tour.isAvailable
                  //     ? AppColors.primaryOrange
                  //     : Colors.grey[400],
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.tour, size: 20),
                    SizedBox(width: 8),
                    Text(
                      // widget.tour.isAvailable ? 'Book Tour' : 'Not Available',
                      'Book Tour',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _makePhoneCall,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primaryOrange),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone,
                          color: AppColors.primaryOrange, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Call',
                        style: TextStyle(
                          color: AppColors.primaryOrange,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _openWhatsAppWithTour(
                    widget.tour.name,
                    widget.tour.price.toString(),
                    'AED',
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat, color: Colors.green, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'WhatsApp',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(Icons.verified_user,
                        color: AppColors.primaryOrange, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Why Choose Royal Dusk Tours?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildBenefitItem(
                  icon: Icons.person,
                  text: 'Expert Local Guides',
                ),
                _buildBenefitItem(
                  icon: Icons.group,
                  text: 'Small Group Experience',
                ),
                _buildBenefitItem(
                  icon: Icons.schedule,
                  text: 'Flexible Timing',
                ),
                _buildBenefitItem(
                  icon: Icons.verified,
                  text: 'Licensed & Insured',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primaryOrange),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.mediumGray,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
