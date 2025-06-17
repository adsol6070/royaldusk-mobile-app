import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';
import 'package:royaldusk_mobile_app/app/controller/auth_controller.dart';

import '../../constant/app_images.dart';
import '../../widgets/app_widget.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(80);

  final bool isDarkMode;

  const MyAppBar({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    // Get AuthController instance
    final AuthController authController = Get.find<AuthController>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // User Avatar with placeholder
            GestureDetector(
              onTap: () {
                ZoomDrawer.of(context)!.toggle();
              },
              onLongPress: () {
                // Optional: Show user info on long press
                _showUserInfo(context, authController);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20),
                child: Obx(() => _buildUserAvatar(authController)),
              ),
            ),

            // Dynamic Location/Info section
            Expanded(
              child: Obx(() => _buildCenterContent(authController)),
            ),

            // Menu icon with optional notification badge
            Container(
              width: 45,
              height: 45,
              margin: const EdgeInsets.only(right: 20, top: 10),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: boxShadowColor.withAlpha(204),
                  spreadRadius: 0,
                  blurRadius: 32,
                  offset: const Offset(0, 6),
                )
              ]),
              child: GestureDetector(
                onTap: () {
                  // Handle notification/menu tap
                  _showAppMenu(context);
                },
                child: SvgPicture.asset(
                  isDarkMode ? sideMenuBlackIcon : sideMenuIcon,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build center content with multiple fallback options
  Widget _buildCenterContent(AuthController authController) {
    // Priority 1: User's profile location
    if (authController.userData.isNotEmpty) {
      final city = authController.userData['city'];
      final country = authController.userData['country'];
      final location = authController.userData['location'];

      if (city != null && country != null) {
        return _buildLocationDisplay('$city, $country', mapIcon);
      } else if (location != null && location.toString().isNotEmpty) {
        return _buildLocationDisplay(location.toString(), mapIcon);
      }
    }

    // Priority 2: Welcome message with user name
    if (authController.displayName.isNotEmpty &&
        authController.displayName != 'User') {
      final firstName = authController.displayName.split(' ')[0];
      return _buildLocationDisplay('Welcome, $firstName!', null,
          icon: Icons.waving_hand);
    }

    // Priority 3: App branding
    return _buildLocationDisplay('Explore with Royal Dusk', null,
        icon: Icons.explore);
  }

  /// Build location display widget
  Widget _buildLocationDisplay(String text, String? svgIcon, {IconData? icon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (svgIcon != null)
          SvgPicture.asset(svgIcon,
              height: 15, width: 15, fit: BoxFit.scaleDown)
        else if (icon != null)
          Icon(icon,
              size: 16, color: isDarkMode ? Colors.white70 : Colors.black54),
        if (svgIcon != null || icon != null) 10.width,
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              letterSpacing: 0.3,
              fontSize: textSizeMedium,
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.ubuntu().fontFamily,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  /// Build user avatar with first letter placeholder
  Widget _buildUserAvatar(AuthController authController) {
    if (authController.isLoadingUserData.value) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 22.0,
          backgroundColor: Colors.grey.withOpacity(0.3),
          child: const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      );
    }

    // Get the first letter of the user's name
    String firstLetter = _getFirstLetter(authController.displayName);
    Color avatarColor = _getAvatarColor(firstLetter);

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 22.0,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 20.0,
          backgroundColor: avatarColor,
          child: Text(
            firstLetter,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  /// Show app menu options
  void _showAppMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Change Location'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to location selection
                Get.toNamed('/select-location');
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/notifications');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/settings');
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Show user info on long press
  void _showUserInfo(BuildContext context, AuthController authController) {
    if (authController.displayName.isEmpty) return;

    Get.snackbar(
      'Welcome!',
      'Hello ${authController.displayName}',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      backgroundColor:
          _getAvatarColor(_getFirstLetter(authController.displayName)),
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
    );
  }

  /// Get the first letter of the user's name
  String _getFirstLetter(String name) {
    if (name.isEmpty ||
        name == 'User' ||
        name == 'Loading...' ||
        name == 'Royal Dusk User') {
      return 'R';
    }
    return name.trim().substring(0, 1).toUpperCase();
  }

  /// Get avatar background color based on the first letter
  Color _getAvatarColor(String firstLetter) {
    final colors = [
      const Color(0xFF6C63FF),
      const Color(0xFF4ECDC4),
      const Color(0xFF45B7D1),
      const Color(0xFF96CEB4),
      const Color(0xFFFD79A8),
      const Color(0xFFFFB74D),
      const Color(0xFF9575CD),
      const Color(0xFF4FC3F7),
      const Color(0xFF81C784),
      const Color(0xFFFF8A65),
      const Color(0xFFBA68C8),
      const Color(0xFF64B5F6),
      const Color(0xFFA1C181),
      const Color(0xFFFF7043),
    ];

    int colorIndex = firstLetter.codeUnitAt(0) % colors.length;
    return colors[colorIndex];
  }
}
