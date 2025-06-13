import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/constant/app_images.dart';
import 'package:royaldusk_mobile_app/app/controller/auth_controller.dart';

import '../../../constant/strings.dart';
import '../../../widgets/app_widget.dart';
import 'custom_row_icon_text.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get AuthController instance
    final AuthController authController = Get.find<AuthController>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appColorPrimary,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8),
            child: Obx(() => _buildUserAvatar(authController)),
          ),
          title: Obx(() => _buildUserInfo(authController)),
          actions: [
            // Optional: Add refresh button to manually refresh user data
            Obx(() => authController.isLoadingUserData.value
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(whiteColor),
                      ),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.refresh, color: whiteColor),
                    onPressed: () => authController.refreshUserData(),
                  )),
          ],
        ),
        backgroundColor: appColorPrimary,
        body: Stack(
          children: [
            Column(
              children: [
                30.height,
                CustomRowIconAndText(
                    title: myProfile,
                    onPressed: () {
                      goToNextScreen("profile_screen");
                    },
                    icon: profileIcon1),
                CustomRowIconAndText(
                    title: notification,
                    onPressed: () {},
                    icon: drawerNotificationIcon),
                CustomRowIconAndText(
                    title: myRecentTrips,
                    onPressed: () {},
                    icon: drawerMapIcon),
                CustomRowIconAndText(
                    title: addedAddress,
                    onPressed: () {},
                    icon: drawerLocationIcon),
                CustomRowIconAndText(
                    title: myWallet, onPressed: () {}, icon: drawerWalletIcon),
                CustomRowIconAndText(
                    title: inviteFriends,
                    onPressed: () {},
                    icon: drawerProfile2Icon),
                CustomRowIconAndText(
                    title: helpSupport,
                    onPressed: () {},
                    icon: drawerHelpSupportIcon)
              ],
            ),
            Positioned(
              bottom: 0,
              child: Obx(() => CustomRowIconAndText(
                    title: signOut,
                    onPressed: authController.isLoading
                        ? () {}
                        : () => _handleLogout(context, authController),
                    icon: drawerLogoutIcon,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  /// Build user info section with loading states
  Widget _buildUserInfo(AuthController authController) {
    if (authController.isLoadingUserData.value) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 16,
            decoration: BoxDecoration(
              color: whiteColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 160,
            height: 12,
            decoration: BoxDecoration(
              color: whiteColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          // Use real user data from AuthController
          authController.displayName.isNotEmpty
              ? authController.displayName
              : 'Royal Dusk User',
          style: const TextStyle(
              fontSize: textSizeLargeMedium,
              fontWeight: FontWeight.w600,
              color: whiteColor),
        ),
        Text(
          // Use real user email from AuthController
          authController.userEmail.isNotEmpty
              ? authController.userEmail
              : 'user@royaldusk.com',
          style: TextStyle(
              fontSize: textSizeSMedium,
              fontWeight: FontWeight.w400,
              color: whiteColor.withAlpha(179)),
        ),
      ],
    );
  }

  /// Build user avatar with first letter placeholder
  Widget _buildUserAvatar(AuthController authController) {
    if (authController.isLoadingUserData.value) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: whiteColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(whiteColor),
            ),
          ),
        ),
      );
    }

    // Get the first letter of the user's name
    String firstLetter = _getFirstLetter(authController.displayName);

    // Choose background color based on the first letter
    Color avatarColor = _getAvatarColor(firstLetter);

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: avatarColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: whiteColor.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            firstLetter,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: whiteColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  /// Get the first letter of the user's name
  String _getFirstLetter(String name) {
    if (name.isEmpty ||
        name == 'User' ||
        name == 'Loading...' ||
        name == 'Royal Dusk User') {
      return 'R'; // Default to 'R' for Royal Dusk
    }

    // Get the first character and make it uppercase
    return name.trim().substring(0, 1).toUpperCase();
  }

  /// Get avatar background color based on the first letter
  Color _getAvatarColor(String firstLetter) {
    // Create a consistent color palette that matches your app theme
    final colors = [
      const Color(0xFF6C63FF), // Purple
      const Color(0xFF4ECDC4), // Teal
      const Color(0xFF45B7D1), // Blue
      const Color(0xFF96CEB4), // Green
      const Color(0xFFFD79A8), // Pink
      const Color(0xFFFFB74D), // Orange
      const Color(0xFF9575CD), // Purple Light
      const Color(0xFF4FC3F7), // Light Blue
      const Color(0xFF81C784), // Light Green
      const Color(0xFFFF8A65), // Deep Orange
      const Color(0xFFBA68C8), // Purple Medium
      const Color(0xFF64B5F6), // Blue Light
      const Color(0xFFA1C181), // Sage Green
      const Color(0xFFFF7043), // Orange Red
    ];

    // Use the ASCII value of the first letter to pick a color consistently
    int colorIndex = firstLetter.codeUnitAt(0) % colors.length;
    return colors[colorIndex];
  }

  /// Handle logout with confirmation dialog
  void _handleLogout(BuildContext context, AuthController authController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Sign Out'),
          content: Text(
              'Are you sure you want to sign out, ${authController.displayName}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog
                await _performLogout(authController);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  /// Perform the actual logout
  Future<void> _performLogout(AuthController authController) async {
    try {
      // Show loading indicator
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        barrierDismissible: false,
      );

      print('🚪 Starting logout process...');

      // Call AuthController logout method
      await authController.logout();

      // Note: logout() method handles navigation, so no need to close dialog
    } catch (e) {
      // Close loading dialog if still open
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      print('❌ Logout error: $e');

      // Show error message
      Get.snackbar(
        'Error',
        'Failed to sign out. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    }
  }
}

void goToNextScreen(String name) {
  Get.toNamed('/$name/');
}
