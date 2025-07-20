import 'package:flutter/material.dart';
import 'package:royaldusk_mobile_app/screens/cart_screen.dart';
import 'package:royaldusk_mobile_app/screens/package_detail_screen.dart';
import 'package:royaldusk_mobile_app/screens/package_list_screen.dart';
import 'package:royaldusk_mobile_app/screens/main_navigation_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:royaldusk_mobile_app/screens/profile_screen.dart';
import 'package:royaldusk_mobile_app/screens/comming_screen.dart';
import 'package:royaldusk_mobile_app/screens/tour_detail_screen.dart';
import 'package:royaldusk_mobile_app/screens/tour_list_screen.dart';
import 'package:royaldusk_mobile_app/services/auth_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Stripe.publishableKey =
      'pk_test_51RURHOQVAwzUHOUyjXieJKJ091m2ALCO0hklQuaQti4NDrcywPdSp2ZGxt7gkybh8HKcswYRbOcM5v5ND9D16hbT00wazSv0Zr';

  await Stripe.instance.applySettings();

  AuthService.initialize();
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
        '/': (context) => const MainNavigationScreen(),
        '/cart': (context) => const CartScreen(),
        '/packages': (context) => const PackageListScreen(),
        '/tours': (context) => const TourListScreen(),
        '/package-detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return PackageDetailScreen(package: args['package']);
        },
        '/tour-detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return TourDetailScreen(tour: args['tour']);
        },
        '/profile': (context) => const ProfileScreen(),
        '/comingSoon': (context) => const ComingSoonScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
