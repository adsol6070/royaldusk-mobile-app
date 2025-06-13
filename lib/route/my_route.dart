import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:royaldusk_mobile_app/middleware/auth_middleware.dart';

import '../app/ui/dashboard/main_home_screen.dart';
import '../app/ui/drawer/drawer_screen.dart';
import '../app/ui/flight/boarding_pass_screen.dart';
import '../app/ui/flight/flights_screen.dart';
import '../app/ui/hotel/hotel_confirmation_screen.dart';
import '../app/ui/hotel/hotel_list_screen.dart';
import '../app/ui/password/new_password_screen.dart';
import '../app/ui/otp/otp_verfication_screen.dart';
import '../app/ui/place/popular_places_screen.dart';
import '../app/ui/popular_package/confirmation_screen.dart';
import '../app/ui/popular_package/payment_screen.dart';
import '../app/ui/popular_package/popular_package_screen.dart';
import '../app/ui/profile/my_profile_screen.dart';
import '../app/ui/password/reset_password.dart';
import '../app/ui/search/serach_result_screen.dart';
import '../app/ui/signin/signin_screen.dart';

import '../app/ui/signup/signup_screen.dart';
import '../app/ui/spalsh_screen.dart';
import '../app/ui/welcome/welcome_screen.dart';

class MyRoutes {
  static const initial = '/splash';
  static const welcome = '/welcome';
  static const signIn = '/signin';
  static const signup = '/signup';
  static const otpVerify = '/otp_verify';
  static const resetPassword = '/reset_password';
  static const newPassword = '/new_password';
  static const mainHomeScreen = '/main_home_screen';
  static const mainDrawerScreen = '/main_drawer_screen';
  static const popularPackageScreen = '/popular_package_screen';
  static const topPackageScreen = '/top_package_screen';
  static const flightScreen = '/flight_screen';
  static const paymentScreen = '/payment_screen';
  static const confirmationScreen = '/confirmation_screen';
  static const boardingPass = '/boarding_pass';
  static const popularPlace = '/popular_place';
  static const popularHotel = '/popular_hotel';
  static const hotelConfirmation = '/hotel_confirmation';
  static const profileScreen = '/profile_screen';
  static const searchScreen = '/search_screen';

  static final routes = [
    GetPage(name: initial, page: () => const SplashScreen()),
    GetPage(
        name: welcome,
        page: () => const WelcomeScreen(),
        middlewares: [GuestMiddleware()]),
    GetPage(
        name: signIn,
        page: () => const SignInScreen(),
        middlewares: [GuestMiddleware()]),
    GetPage(
        name: signup,
        page: () => const SignUpScreen(),
        middlewares: [GuestMiddleware()]),
    GetPage(name: otpVerify, page: () => const OtpVerificationScreen()),
    GetPage(name: resetPassword, page: () => const ResetPasswordScreen()),
    GetPage(name: newPassword, page: () => const NewPasswordScreen()),
    GetPage(
        name: mainHomeScreen,
        page: () => const MainHomeScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: mainDrawerScreen,
        page: () => MainDrawerScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: popularPackageScreen,
        page: () => const PopularPackageScreen(),
        middlewares: [AuthMiddleware()]),
    // GetPage(name: topPackageScreen, page: )
    GetPage(
        name: flightScreen,
        page: () => const FlightScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: paymentScreen,
        page: () => const PaymentScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: confirmationScreen,
        page: () => const ConfirmationScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: boardingPass,
        page: () => const BoardingPassScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: popularPlace,
        page: () => const PopularPlaceScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: popularHotel,
        page: () => const HotelListScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: hotelConfirmation,
        page: () => const HotelConfirmationScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: profileScreen,
        page: () => const MyProfileScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: searchScreen,
        page: () => const SearchResultScreen(),
        middlewares: [AuthMiddleware()]),
  ];
}
