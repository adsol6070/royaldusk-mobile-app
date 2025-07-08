import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:royaldusk_mobile_app/constants/app_colors.dart';
import 'package:royaldusk_mobile_app/models/user.dart';
import 'package:royaldusk_mobile_app/services/auth_service.dart';
import 'package:royaldusk_mobile_app/widgets/auth/phone_auth_dialog.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: _buildAppBar(),
      body: AuthService.isSignedIn
          ? _buildProfileContent()
          : _buildGuestContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      title: Text(
        AuthService.isSignedIn ? 'My Profile' : 'Account',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkGray,
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      // actions: AuthService.isSignedIn
      //     ? [
      //         IconButton(
      //           icon: const Icon(Icons.settings_outlined,
      //               color: AppColors.mediumGray),
      //           onPressed: () {
      //             // Navigate to settings
      //             Navigator.pushNamed(context, '/comingSoon');
      //           },
      //         ),
      //         const SizedBox(width: 8),
      //       ]
      //     : null,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: const Color(0xFFF1F5F9),
        ),
      ),
    );
  }

  Widget _buildGuestContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildGuestHeader(),
          _buildSignInOptions(),
          _buildGuestFeatures(),
          // _buildAppFeatures(),
        ],
      ),
    );
  }

  Widget _buildGuestHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.lightOrange,
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.person_outline,
              size: 40,
              color: AppColors.primaryOrange,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Sign in to unlock benefits',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Get personalized recommendations,\nsave your favorites, and more',
            style: TextStyle(
              color: AppColors.mediumGray,
              fontSize: 14,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSignInOptions() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          _buildSignInButton(
            icon: Icons.email_outlined,
            title: 'Continue with Email',
            subtitle: 'Sign in with your email address',
            onTap: () =>
                _showEmailSignInDialog(), // You can implement this later
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _buildSignInButton(
            icon: Icons.phone_outlined,
            title: 'Continue with Phone',
            subtitle: 'Sign in with your phone number',
            onTap: () =>
                _showPhoneSignInDialog(), // You can implement this later
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _buildSignInButton(
            icon: Icons.g_mobiledata,
            title: 'Continue with Google',
            subtitle: 'Quick sign in with Google account',
            onTap: () => _signInWithGoogle(),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _buildSignInButton(
            icon: Icons.apple,
            title: 'Continue with Apple',
            subtitle: 'Sign in with your Apple ID',
            onTap: () => _signInWithApple(),
          )
        ],
      ),
    );
  }

  Widget _buildSignInButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
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

  Widget _buildGuestFeatures() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Why create an account?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGray,
              ),
            ),
          ),
          _buildBenefitItem(
            icon: Icons.bookmark_outline,
            title: 'Save your favorites',
            subtitle: 'Create wishlists of packages you love',
          ),
          _buildBenefitItem(
            icon: Icons.history,
            title: 'Track your bookings',
            subtitle: 'View past and upcoming trips',
          ),
          _buildBenefitItem(
            icon: Icons.notifications_outlined,
            title: 'Get exclusive deals',
            subtitle: 'Receive personalized offers and updates',
          ),
          _buildBenefitItem(
            icon: Icons.support_agent,
            title: 'Priority support',
            subtitle: 'Get faster help when you need it',
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.lightOrange,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryOrange,
              size: 16,
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
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    final user = AuthService.currentUser!;

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(user),
          // _buildQuickActions(),
          // _buildProfileMenu(),
          _buildAppInfo(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(User user) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primaryOrange,
                      AppColors.secondaryOrange
                    ],
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: user.avatar != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.network(
                          user.avatar!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: Text(
                          user.name
                              .split(' ')
                              .map((e) => e.isNotEmpty ? e[0] : '')
                              .join()
                              .toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
              if (user.isVerified)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(
              color: AppColors.mediumGray,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today,
                  size: 14, color: AppColors.mediumGray),
              const SizedBox(width: 4),
              Text(
                'Member since ${_formatDate(user.joinedDate)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.mediumGray,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _buildQuickActionItem(
                icon: Icons.confirmation_number_outlined,
                label: 'My Bookings',
                count: '3',
                onTap: () {
                  Navigator.pushNamed(context, '/comingSoon');
                },
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: const Color(0xFFF1F5F9),
            ),
            Expanded(
              child: _buildQuickActionItem(
                icon: Icons.favorite_outline,
                label: 'Wishlist',
                count: '12',
                onTap: () {
                  Navigator.pushNamed(context, '/comingSoon');
                },
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: const Color(0xFFF1F5F9),
            ),
            Expanded(
              child: _buildQuickActionItem(
                icon: Icons.reviews_outlined,
                label: 'Reviews',
                count: '5',
                onTap: () {
                  Navigator.pushNamed(context, '/comingSoon');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String label,
    required String count,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryOrange, size: 24),
            const SizedBox(height: 8),
            Text(
              count,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenu() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          _buildMenuItem(
            icon: Icons.person_outline,
            title: 'Personal Information',
            subtitle: 'Update your details',
            onTap: () {
              Navigator.pushNamed(context, '/comingSoon');
            },
          ),
          _buildMenuDivider(),
          _buildMenuItem(
            icon: Icons.payment_outlined,
            title: 'Payment Methods',
            subtitle: 'Manage cards and payment options',
            onTap: () {
              Navigator.pushNamed(context, '/comingSoon');
            },
          ),
          _buildMenuDivider(),
          _buildMenuItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage your preferences',
            onTap: () {
              Navigator.pushNamed(context, '/comingSoon');
            },
          ),
          _buildMenuDivider(),
          _buildMenuItem(
            icon: Icons.security_outlined,
            title: 'Privacy & Security',
            subtitle: 'Password and security settings',
            onTap: () {
              Navigator.pushNamed(context, '/comingSoon');
            },
          ),
          _buildMenuDivider(),
          _buildMenuItem(
            icon: Icons.language_outlined,
            title: 'Language & Region',
            subtitle: 'English (US), AED',
            onTap: () {
              Navigator.pushNamed(context, '/comingSoon');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primaryOrange)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.primaryOrange,
                size: 18,
              ),
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

  Widget _buildMenuDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.only(left: 68),
      color: const Color(0xFFF1F5F9),
    );
  }

  Widget _buildAppFeatures() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          _buildMenuItem(
            icon: Icons.headset_mic_outlined,
            title: 'Customer Support',
            subtitle: 'Get help with your bookings',
            onTap: () {
              Navigator.pushNamed(context, '/comingSoon');
            },
          ),
          _buildMenuDivider(),
          _buildMenuItem(
            icon: Icons.info_outline,
            title: 'About Royal Dusk Tours',
            subtitle: 'Learn more about our company',
            onTap: () {
              Navigator.pushNamed(context, '/comingSoon');
            },
          ),
          _buildMenuDivider(),
          _buildMenuItem(
            icon: Icons.article_outlined,
            title: 'Terms & Conditions',
            subtitle: 'Read our terms of service',
            onTap: () {
              Navigator.pushNamed(context, '/comingSoon');
            },
          ),
          _buildMenuDivider(),
          _buildMenuItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'How we protect your data',
            onTap: () {
              Navigator.pushNamed(context, '/comingSoon');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfo() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // _buildMenuItem(
          //   icon: Icons.headset_mic_outlined,
          //   title: 'Customer Support',
          //   subtitle: 'Get help 24/7',
          //   onTap: () {
          //     Navigator.pushNamed(context, '/comingSoon');
          //   },
          // ),
          // _buildMenuDivider(),
          // _buildMenuItem(
          //   icon: Icons.share_outlined,
          //   title: 'Invite Friends',
          //   subtitle: 'Share Royal Dusk Tours',
          //   onTap: () {
          //     Navigator.pushNamed(context, '/comingSoon');
          //   },
          // ),
          // _buildMenuDivider(),
          // _buildMenuItem(
          //   icon: Icons.star_outline,
          //   title: 'Rate Our App',
          //   subtitle: 'Help us improve',
          //   onTap: () {
          //     Navigator.pushNamed(context, '/comingSoon');
          //   },
          // ),
          _buildMenuDivider(),
          _buildMenuItem(
            icon: Icons.delete_outline,
            title: 'Delete Account',
            subtitle: 'Permanently delete your account and data',
            iconColor: Colors.red,
            onTap: () => _showDeleteAccountDialog(),
          ),
          _buildMenuDivider(),
          _buildMenuItem(
            icon: Icons.logout,
            title: 'Sign Out',
            subtitle: 'Sign out of your account',
            iconColor: Colors.red,
            onTap: () => _showSignOutDialog(),
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
    return '${months[date.month - 1]} ${date.year}';
  }

  // ==================== AUTHENTICATION METHODS ====================

  Future<void> _signInWithGoogle() async {
    try {
      // Show loading indicator
      _showLoadingDialog('Signing in with Google...');

      final user = await AuthService.signInWithGoogle();

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      if (user != null) {
        setState(() {
          // UI will automatically update due to AuthService state change
        });
        _showSuccessSnackBar('Successfully signed in with Google!');
      } else {
        // User cancelled the sign-in
        _showErrorSnackBar('Google sign-in was cancelled');
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog
      _showErrorSnackBar('Failed to sign in with Google: ${e.toString()}');
    }
  }

  Future<void> _signInWithApple() async {
    try {
      _showLoadingDialog('Signing in with Apple...');

      final user = await AuthService.signInWithApple();

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      if (user != null) {
        setState(() {}); // Optional: triggers UI update
        _showSuccessSnackBar('Successfully signed in with Apple!');
      } else {
        _showErrorSnackBar('Apple sign-in was cancelled by the user.');
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      if (e is SignInWithAppleAuthorizationException) {
        if (e.code == AuthorizationErrorCode.canceled ||
            e.code == AuthorizationErrorCode.unknown) {
          _showErrorSnackBar('Apple sign-in was cancelled by the user.');
          return;
        }
      }

      _showErrorSnackBar('Failed to sign in with Apple: ${e.toString()}');
    }
  }

  void _demoSignIn() {
    Navigator.pop(context); // Close dialog
    setState(() {
      AuthService.signIn(AuthService.mockUser);
    });
    _showSuccessSnackBar('Demo sign in successful!');
  }

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.primaryOrange),
            ),
            const SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              try {
                _showLoadingDialog('Signing out...');
                await AuthService.signOut();

                if (!mounted) return;
                Navigator.pop(context); // Close loading dialog

                setState(() {
                  // UI will automatically update due to AuthService state change
                });
                _showSuccessSnackBar('Successfully signed out!');
              } catch (e) {
                if (!mounted) return;
                Navigator.pop(context); // Close loading dialog
                _showErrorSnackBar('Failed to sign out: ${e.toString()}');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  // ==================== ACCOUNT DELETION ====================

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              'Delete Account',
              style: TextStyle(
                color: Colors.red,
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
              'This action cannot be undone. Deleting your account will:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            _buildDeleteAccountItem(
              icon: Icons.delete_forever,
              text: 'Permanently delete all your personal data',
            ),
            _buildDeleteAccountItem(
              icon: Icons.cancel,
              text: 'Cancel all upcoming bookings',
            ),
            _buildDeleteAccountItem(
              icon: Icons.history,
              text: 'Remove your booking history',
            ),
            _buildDeleteAccountItem(
              icon: Icons.favorite_border,
              text: 'Delete your wishlists and reviews',
            ),
            _buildDeleteAccountItem(
              icon: Icons.login,
              text: 'Revoke access to your account',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.red.withValues(alpha: 0.3),
                ),
              ),
              child: const Text(
                '⚠️ This action is permanent and cannot be reversed. All your data will be permanently deleted from our servers.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.mediumGray,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showDeleteAccountConfirmationDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteAccountItem({
    required IconData icon,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.darkGray,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountConfirmationDialog() {
    final TextEditingController confirmationController =
        TextEditingController();
    bool isDeleteEnabled = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Final Confirmation',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'To confirm account deletion, please type "DELETE" in the field below:',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmationController,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  hintText: 'Type DELETE here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    isDeleteEnabled = value.trim().toUpperCase() == 'DELETE';
                  });
                },
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.amber.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Account deletion may take up to 30 days to complete. During this time, your account will be deactivated but data deletion will be processing.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.amber[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.mediumGray,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: isDeleteEnabled
                  ? () async {
                      Navigator.pop(context);
                      await _deleteAccount();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDeleteEnabled ? Colors.red : Colors.grey,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text('Delete Account'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteAccount() async {
    try {
      _showLoadingDialog('Deleting your account...');

      // Call the delete account method from AuthService
      await AuthService.deleteAccount();

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      // Show success message and sign out
      _showSuccessSnackBar(
          'Account deletion initiated successfully. You will be signed out.');

      // Small delay before signing out to show the success message
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() {
        // UI will automatically update due to AuthService state change
      });
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog
      _showErrorSnackBar('Failed to delete account: ${e.toString()}');
    }
  }

  // Placeholder methods for email and phone sign-in (implement later)
  void _showEmailSignInDialog() {
    _showInfoDialog(
      'Email Sign In',
      'Email/password authentication will be implemented in a future update.\n\nFor now, please use Google, Apple, or Demo sign-in.',
    );
  }

  void _showPhoneSignInDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PhoneAuthDialog(),
    );

    if (result == true && mounted) {
      // Phone authentication was successful
      setState(() {
        // UI will automatically update due to AuthService state change
      });
    }
  }

  void _showInfoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
