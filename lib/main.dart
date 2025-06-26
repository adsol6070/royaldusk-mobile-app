import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:royaldusk_mobile_app/screens/booking_screen.dart';
import 'package:royaldusk_mobile_app/screens/cart_screen.dart';
import 'package:royaldusk_mobile_app/screens/dashboard_screen.dart';
import 'package:royaldusk_mobile_app/screens/package_list_screen.dart';
import 'package:royaldusk_mobile_app/screens/profile_screen.dart';
import 'package:royaldusk_mobile_app/screens/wish_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Royal Dusk Tours',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter', // You can change this to your preferred font
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/cart': (context) => const CartScreen(),
        '/packages': (context) => const PackageListScreen(),
        '/bookings': (context) => const BookingsScreen(),
        '/wishlist': (context) => const WishlistScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// Additional Widgets and Screens for complete functionality

class StatsWidget extends StatelessWidget {
  final String number;
  final String label;
  final Color? color;

  const StatsWidget({
    super.key,
    required this.number,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: (color ?? Colors.white).withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class AnimatedCounter extends StatefulWidget {
  final int targetNumber;
  final Duration duration;
  final TextStyle? style;

  const AnimatedCounter({
    super.key,
    required this.targetNumber,
    this.duration = const Duration(seconds: 2),
    this.style,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = IntTween(begin: 0, end: widget.targetNumber).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          '${_animation.value}+',
          style: widget.style,
        );
      },
    );
  }
}

// Custom App Bar with Gradient
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF8853D),
            Color(0xFFE67428),
          ],
        ),
      ),
      child: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        actions: actions,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Loading Shimmer Widget
class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Color(0xFFE2E8F0),
                Color(0xFFF1F5F9),
                Color(0xFFE2E8F0),
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
            ),
          ),
        );
      },
    );
  }
}

// Usage example and constants
class AppConstants {
  static const Color primaryOrange = Color(0xFFF8853D);
  static const Color secondaryOrange = Color(0xFFE67428);
  static const Color lightOrange = Color(0xFFFEF7F0);
  static const Color borderOrange = Color(0xFFFED7AA);
  static const Color darkGray = Color(0xFF1E293B);
  static const Color mediumGray = Color(0xFF64748B);
  static const Color lightGray = Color(0xFFF8FAFC);

  static const EdgeInsets defaultPadding = EdgeInsets.all(20);
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  static const double defaultBorderRadius = 12;
  static const double largeBorderRadius = 16;
}
