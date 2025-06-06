import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controller/theme_controller.dart';

class ProfileController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

  TextEditingController emailController=TextEditingController(text: 'Jonathan Smith');
  TextEditingController nameController=TextEditingController(text: 'jonathansmith@gmail.com');
  TextEditingController phoneController=TextEditingController(text: '+00 123 456 789');

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();

  final formKey = GlobalKey<FormState>();

  final BuildContext context;

  ProfileController(this.context);
}
