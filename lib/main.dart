import 'package:royaldusk_mobile_app/route/my_route.dart';
import 'package:royaldusk_mobile_app/theme/styles.dart';
import 'package:royaldusk_mobile_app/utils/flutter_web_frame/flutter_web_frame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/controller/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final ThemeController controller = Get.put(ThemeController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return FlutterWebFrame(
      builder: (context) {
        return Obx(
          () {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              theme:
                  controller.isDarkMode ? Styles.darkTheme : Styles.lightTheme,
              getPages: MyRoutes.routes,
              initialRoute: MyRoutes.initial,
            );
          },
          // ),
        );
      },
      maximumSize: const Size(475.0, 812.0),
      enabled: kIsWeb, // default is enable, when disable content is full size
      backgroundColor: Colors.grey, // Background color/white space
    );
  }
// child: ,
// );
// }
}
