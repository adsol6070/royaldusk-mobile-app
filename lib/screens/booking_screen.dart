import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:royaldusk_mobile_app/constants/app_colors.dart';
import 'package:royaldusk_mobile_app/services/auth_service.dart';

// Booking Status Enum
enum BookingStatus {
  upcoming,
  ongoing,
  completed,
  cancelled,
}

// Booking Model
class Booking {
  final String id;
  final String packageName;
  final String location;
  final String duration;
  final double totalAmount;
  final DateTime bookingDate;
  final DateTime travelDate;
  final DateTime? endDate;
  final String imageUrl;
  final BookingStatus status;
  final int guests;
  final int rooms;
  final String bookingReference;
  final String contactName;
  final String contactEmail;
  final String contactPhone;

  Booking({
    required this.id,
    required this.packageName,
    required this.location,
    required this.duration,
    required this.totalAmount,
    required this.bookingDate,
    required this.travelDate,
    this.endDate,
    required this.imageUrl,
    required this.status,
    required this.guests,
    required this.rooms,
    required this.bookingReference,
    required this.contactName,
    required this.contactEmail,
    required this.contactPhone,
  });
}

// Bookings Service
class BookingsService {
  static final List<Booking> _bookings = [
    Booking(
      id: '1',
      packageName: 'Manali Adventure Tour',
      location: 'Manali, Himachal Pradesh',
      duration: '5 Days',
      totalAmount: 35998,
      bookingDate: DateTime.now().subtract(const Duration(days: 5)),
      travelDate: DateTime.now().add(const Duration(days: 15)),
      endDate: DateTime.now().add(const Duration(days: 20)),
      imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
      status: BookingStatus.upcoming,
      guests: 2,
      rooms: 1,
      bookingReference: 'TRV001234',
      contactName: 'John Doe',
      contactEmail: 'john.doe@email.com',
      contactPhone: '+971 50 123 4567',
    ),
    Booking(
      id: '2',
      packageName: 'Kerala Backwaters',
      location: 'Kerala',
      duration: '6 Days',
      totalAmount: 42999,
      bookingDate: DateTime.now().subtract(const Duration(days: 25)),
      travelDate: DateTime.now().subtract(const Duration(days: 5)),
      endDate: DateTime.now().add(const Duration(days: 1)),
      imageUrl: 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944',
      status: BookingStatus.ongoing,
      guests: 3,
      rooms: 2,
      bookingReference: 'TRV001235',
      contactName: 'John Doe',
      contactEmail: 'john.doe@email.com',
      contactPhone: '+971 50 123 4567',
    ),
    Booking(
      id: '3',
      packageName: 'Goa Beach Paradise',
      location: 'Goa',
      duration: '4 Days',
      totalAmount: 28999,
      bookingDate: DateTime.now().subtract(const Duration(days: 60)),
      travelDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now().subtract(const Duration(days: 26)),
      imageUrl: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2',
      status: BookingStatus.completed,
      guests: 2,
      rooms: 1,
      bookingReference: 'TRV001236',
      contactName: 'John Doe',
      contactEmail: 'john.doe@email.com',
      contactPhone: '+971 50 123 4567',
    ),
    Booking(
      id: '4',
      packageName: 'Dubai Desert Safari',
      location: 'Dubai, UAE',
      duration: '1 Day',
      totalAmount: 15999,
      bookingDate: DateTime.now().subtract(const Duration(days: 10)),
      travelDate: DateTime.now().subtract(const Duration(days: 2)),
      imageUrl: 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c',
      status: BookingStatus.cancelled,
      guests: 4,
      rooms: 1,
      bookingReference: 'TRV001237',
      contactName: 'John Doe',
      contactEmail: 'john.doe@email.com',
      contactPhone: '+971 50 123 4567',
    ),
  ];

  static List<Booking> get bookings => AuthService.isSignedIn ? _bookings : [];

  static List<Booking> getBookingsByStatus(BookingStatus status) {
    return _bookings.where((booking) => booking.status == status).toList();
  }

  static int get totalBookings => _bookings.length;
  static int get upcomingBookings =>
      getBookingsByStatus(BookingStatus.upcoming).length;
  static int get ongoingBookings =>
      getBookingsByStatus(BookingStatus.ongoing).length;
  static int get completedBookings =>
      getBookingsByStatus(BookingStatus.completed).length;
}

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: _buildAppBar(),
      body: !AuthService.isSignedIn
          ? _buildGuestView()
          : BookingsService.bookings.isEmpty
              ? _buildEmptyBookings()
              : _buildBookingsContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      automaticallyImplyLeading: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Bookings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.darkGray,
            ),
          ),
          if (AuthService.isSignedIn && BookingsService.bookings.isNotEmpty)
            Text(
              '${BookingsService.totalBookings} booking${BookingsService.totalBookings != 1 ? 's' : ''}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.mediumGray,
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
      actions: AuthService.isSignedIn
          ? [
              IconButton(
                icon: const Icon(Icons.search, color: AppColors.mediumGray),
                onPressed: () => _showSearchDialog(),
              ),
              IconButton(
                icon:
                    const Icon(Icons.filter_list, color: AppColors.mediumGray),
                onPressed: () => _showFilterDialog(),
              ),
              const SizedBox(width: 8),
            ]
          : null,
      bottom: AuthService.isSignedIn && BookingsService.bookings.isNotEmpty
          ? TabBar(
              controller: _tabController,
              labelColor: AppColors.primaryOrange,
              unselectedLabelColor: AppColors.mediumGray,
              indicatorColor: AppColors.primaryOrange,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              tabs: [
                Tab(
                  child:
                      _buildTabWithBadge('All', BookingsService.totalBookings),
                ),
                Tab(
                  child: _buildTabWithBadge(
                      'Upcoming', BookingsService.upcomingBookings),
                ),
                Tab(
                  child: _buildTabWithBadge(
                      'Ongoing', BookingsService.ongoingBookings),
                ),
                Tab(
                  child: _buildTabWithBadge(
                      'Past', BookingsService.completedBookings),
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildTabWithBadge(String title, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title),
        if (count > 0) ...[
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGuestView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryOrange.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryOrange.withValues(alpha: 0.2),
                          AppColors.lightOrange
                        ],
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.flight_takeoff,
                      size: 50,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Sign in to view your bookings',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Track your travel bookings, view details,\nand manage your trips all in one place',
                    style: TextStyle(
                      color: AppColors.mediumGray,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/profile'),
                      icon: const Icon(Icons.login, size: 18),
                      label: const Text('Sign In'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/packages'),
                    child: const Text(
                      'Browse Packages',
                      style: TextStyle(
                        color: AppColors.primaryOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _buildGuestFeatures(),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestFeatures() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What you can do with bookings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 16),
          _buildFeatureItem(
            Icons.confirmation_number_outlined,
            'Track Bookings',
            'View all your travel bookings in one place',
          ),
          _buildFeatureItem(
            Icons.schedule_outlined,
            'Trip Timeline',
            'See upcoming, ongoing, and past trips',
          ),
          _buildFeatureItem(
            Icons.receipt_long_outlined,
            'Booking Details',
            'Access confirmation numbers and receipts',
          ),
          _buildFeatureItem(
            Icons.support_agent_outlined,
            'Easy Support',
            'Get help with your bookings anytime',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
          const SizedBox(width: 16),
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
        ],
      ),
    );
  }

  Widget _buildEmptyBookings() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.lightOrange,
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.luggage,
                size: 60,
                color: AppColors.primaryOrange,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'No bookings yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your travel bookings will appear here.\nStart exploring amazing destinations!',
              style: TextStyle(
                color: AppColors.mediumGray,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/packages'),
                icon: const Icon(Icons.explore, size: 18),
                label: const Text('Explore Packages'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsContent() {
    return Column(
      children: [
        _buildQuickStats(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildBookingsList(BookingsService.bookings),
              _buildBookingsList(
                  BookingsService.getBookingsByStatus(BookingStatus.upcoming)),
              _buildBookingsList(
                  BookingsService.getBookingsByStatus(BookingStatus.ongoing)),
              _buildBookingsList([
                ...BookingsService.getBookingsByStatus(BookingStatus.completed),
                ...BookingsService.getBookingsByStatus(BookingStatus.cancelled),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Total Trips',
              '${BookingsService.totalBookings}',
              Icons.flight_takeoff,
              AppColors.primaryOrange,
            ),
          ),
          Container(width: 1, height: 40, color: const Color(0xFFE5E7EB)),
          Expanded(
            child: _buildStatItem(
              'Upcoming',
              '${BookingsService.upcomingBookings}',
              Icons.schedule,
              Colors.blue,
            ),
          ),
          Container(width: 1, height: 40, color: const Color(0xFFE5E7EB)),
          Expanded(
            child: _buildStatItem(
              'Completed',
              '${BookingsService.completedBookings}',
              Icons.check_circle,
              Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.mediumGray,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBookingsList(List<Booking> bookings) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppColors.mediumGray.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No bookings in this category',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.mediumGray.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return _buildBookingCard(bookings[index]);
      },
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: _getStatusColor(booking.status).withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with image and status
          Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(booking.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(booking.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    booking.bookingReference,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        booking.packageName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkGray,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'AED ${booking.totalAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 14, color: AppColors.mediumGray),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        booking.location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.mediumGray,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time,
                        size: 14, color: AppColors.mediumGray),
                    const SizedBox(width: 4),
                    Text(
                      booking.duration,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.mediumGray,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Trip details
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTripDetail(
                          'Travel Date',
                          _formatDate(booking.travelDate),
                          Icons.calendar_today,
                        ),
                      ),
                      Container(
                          width: 1, height: 30, color: const Color(0xFFE5E7EB)),
                      Expanded(
                        child: _buildTripDetail(
                          'Guests',
                          '${booking.guests} guests',
                          Icons.people,
                        ),
                      ),
                      Container(
                          width: 1, height: 30, color: const Color(0xFFE5E7EB)),
                      Expanded(
                        child: _buildTripDetail(
                          'Rooms',
                          '${booking.rooms} room${booking.rooms > 1 ? 's' : ''}',
                          Icons.hotel,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _viewBookingDetails(booking),
                        icon: const Icon(Icons.visibility_outlined, size: 16),
                        label: const Text('View Details'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryOrange,
                          side:
                              const BorderSide(color: AppColors.primaryOrange),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _getActionForStatus(booking),
                        icon: Icon(_getActionIcon(booking.status), size: 16),
                        label: Text(_getActionText(booking.status)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getActionColor(booking.status),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: AppColors.mediumGray),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.mediumGray,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.darkGray,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.upcoming:
        return Colors.blue;
      case BookingStatus.ongoing:
        return Colors.green;
      case BookingStatus.completed:
        return Colors.grey;
      case BookingStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.upcoming:
        return 'UPCOMING';
      case BookingStatus.ongoing:
        return 'ONGOING';
      case BookingStatus.completed:
        return 'COMPLETED';
      case BookingStatus.cancelled:
        return 'CANCELLED';
    }
  }

  IconData _getActionIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.upcoming:
        return Icons.edit_calendar;
      case BookingStatus.ongoing:
        return Icons.support_agent;
      case BookingStatus.completed:
        return Icons.rate_review;
      case BookingStatus.cancelled:
        return Icons.refresh;
    }
  }

  String _getActionText(BookingStatus status) {
    switch (status) {
      case BookingStatus.upcoming:
        return 'Modify';
      case BookingStatus.ongoing:
        return 'Support';
      case BookingStatus.completed:
        return 'Review';
      case BookingStatus.cancelled:
        return 'Rebook';
    }
  }

  Color _getActionColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.upcoming:
        return AppColors.primaryOrange;
      case BookingStatus.ongoing:
        return Colors.green;
      case BookingStatus.completed:
        return Colors.blue;
      case BookingStatus.cancelled:
        return AppColors.primaryOrange;
    }
  }

  void _getActionForStatus(Booking booking) {
    switch (booking.status) {
      case BookingStatus.upcoming:
        _modifyBooking(booking);
        break;
      case BookingStatus.ongoing:
        _contactSupport(booking);
        break;
      case BookingStatus.completed:
        _writeReview(booking);
        break;
      case BookingStatus.cancelled:
        _rebookPackage(booking);
        break;
    }
  }

  void _viewBookingDetails(Booking booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildBookingDetailsSheet(booking),
    );
  }

  Widget _buildBookingDetailsSheet(Booking booking) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Booking Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGray,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppColors.mediumGray),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Package Image and Info
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(booking.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.7),
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
                                booking.packageName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                booking.location,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getStatusColor(booking.status),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              _getStatusText(booking.status),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Booking Information
                  _buildDetailSection('Booking Information', [
                    _buildDetailRow(
                        'Booking Reference', booking.bookingReference),
                    _buildDetailRow(
                        'Booking Date', _formatDate(booking.bookingDate)),
                    _buildDetailRow('Total Amount',
                        'AED ${booking.totalAmount.toStringAsFixed(0)}'),
                    _buildDetailRow('Duration', booking.duration),
                  ]),

                  const SizedBox(height: 20),

                  // Travel Information
                  _buildDetailSection('Travel Information', [
                    _buildDetailRow(
                        'Travel Date', _formatDate(booking.travelDate)),
                    if (booking.endDate != null)
                      _buildDetailRow(
                          'Return Date', _formatDate(booking.endDate!)),
                    _buildDetailRow('Guests', '${booking.guests} guests'),
                    _buildDetailRow('Rooms',
                        '${booking.rooms} room${booking.rooms > 1 ? 's' : ''}'),
                  ]),

                  const SizedBox(height: 20),

                  // Contact Information
                  _buildDetailSection('Contact Information', [
                    _buildDetailRow('Name', booking.contactName),
                    _buildDetailRow('Email', booking.contactEmail),
                    _buildDetailRow('Phone', booking.contactPhone),
                  ]),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _downloadTicket(booking),
                          icon: const Icon(Icons.download, size: 18),
                          label: const Text('Download'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryOrange,
                            side: const BorderSide(
                                color: AppColors.primaryOrange),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _shareBooking(booking),
                          icon: const Icon(Icons.share, size: 18),
                          label: const Text('Share'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryOrange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
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

  Widget _buildDetailSection(String title, List<Widget> details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.darkGray,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            children: details,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.mediumGray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.darkGray,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _modifyBooking(Booking booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Modify booking: ${booking.packageName}'),
        backgroundColor: AppColors.primaryOrange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _contactSupport(Booking booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contacting support for: ${booking.packageName}'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _writeReview(Booking booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Write review for: ${booking.packageName}'),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _rebookPackage(Booking booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rebooking: ${booking.packageName}'),
        backgroundColor: AppColors.primaryOrange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _downloadTicket(Booking booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading ticket for: ${booking.packageName}'),
        backgroundColor: AppColors.primaryOrange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareBooking(Booking booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing booking: ${booking.packageName}'),
        backgroundColor: AppColors.primaryOrange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Bookings'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Search by package name or destination...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Bookings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Upcoming'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Completed'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Cancelled'),
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
