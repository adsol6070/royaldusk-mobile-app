// import 'dart:io';
// import 'package:connectivity_plus/connectivity_plus.dart';

// class NetworkHelper {
//   static Future<bool> isConnected() async {
//     try {
//       final result = await InternetAddress.lookup('google.com');
//       return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
//     } on SocketException catch (_) {
//       return false;
//     }
//   }

//   static Future<ConnectivityResult> getConnectivityStatus() async {
//     final connectivity = Connectivity();
//     return await connectivity.checkConnectivity();
//   }

//   static Stream<ConnectivityResult> get connectivityStream {
//     return Connectivity().onConnectivityChanged;
//   }
// }