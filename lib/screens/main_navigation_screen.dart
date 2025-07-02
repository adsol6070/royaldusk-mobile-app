import 'package:flutter/material.dart';
import 'package:royaldusk_mobile_app/constants/app_colors.dart';
import 'package:royaldusk_mobile_app/screens/booking_screen.dart';
import 'package:royaldusk_mobile_app/screens/dashboard_screen.dart';
import 'package:royaldusk_mobile_app/screens/profile_screen.dart';
import 'package:royaldusk_mobile_app/screens/wish_list_screen.dart';
import 'package:royaldusk_mobile_app/services/auth_service.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  // Define your screens here
  final List<Widget> _screens = [
    const DashboardScreen(
        showAppBar:
            false), // Hide the sliver app bar since we're handling navigation
    const BookingsScreen(),
    const WishlistScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  bool get isTablet {
    return MediaQuery.of(context).size.width > 600;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
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
          onTap: _onTabTapped,
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
