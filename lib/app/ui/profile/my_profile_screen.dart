import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/app/controller/auth_controller.dart';
import 'package:royaldusk_mobile_app/app/controller/profile_controller.dart';

import 'package:royaldusk_mobile_app/widgets/grediant_button.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/app_images.dart';
import '../../../constant/strings.dart';
import '../../../widgets/app_widget.dart';
import 'custom_row_text_icon.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  MyProfileScreenState createState() => MyProfileScreenState();
}

class MyProfileScreenState extends State<MyProfileScreen> {
  late AuthController authController;
  late ProfileController profileController;
  late TextEditingController nameController;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();
    profileController = Get.put(ProfileController());
    isDarkMode = Get.isDarkMode;
    nameController = TextEditingController(text: authController.displayName);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: commonAppBarWidget(context, titleText: myProfile),
          resizeToAvoidBottomInset: true,
          backgroundColor: isDarkMode ? appDarkBgColor : appLightBgColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUserAvatar(authController.displayName),
                    20.height,

                    // Editable Name
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: CustomRowTextAndIcon(
                        title: name,
                        onPressed: () {}, // still keeps edit icon
                        isDarkMode: isDarkMode,
                      ),
                    ),
                    15.height,
                    TextFormField(
                      style: TextStyle(
                        color: isDarkMode ? whiteColor : appTextColorPrimary,
                      ),
                      controller: nameController,
                      decoration: inputDecoration(
                        context,
                        prefixIconColor:
                            isDarkMode ? whiteColor : appTextColorPrimary,
                        borderColor: isDarkMode
                            ? whiteColor.withAlpha(31)
                            : appTextColorPrimary.withAlpha(31),
                        fillColor:
                            isDarkMode ? appDarkBgColor : appLightBgColor,
                        hintColor: isDarkMode
                            ? whiteColor.withAlpha(153)
                            : appTextColorPrimary.withAlpha(153),
                        prefixIcon: profileIcon,
                        borderRadius: textFieldRadius,
                        hintText: typeYourName,
                      ),
                    ),
                    30.height,

                    // Non-editable Email
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Text(
                            email,
                            style: TextStyle(
                              color:
                                  isDarkMode ? whiteColor : appTextColorPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          // No edit icon here
                        ],
                      ),
                    ),
                    15.height,
                    _readOnlyField(authController.userEmail),
                    20.height,

                    // Feedback messages
                    if (profileController.updateError.isNotEmpty)
                      Text(profileController.updateError.value,
                          style: const TextStyle(color: Colors.red)),
                    if (profileController.updateSuccess.isNotEmpty)
                      Text(profileController.updateSuccess.value,
                          style: const TextStyle(color: Colors.green)),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Obx(() => GradientElevatedButton(
                  text: profileController.isUpdating.value
                      ? 'Updating...'
                      : update,
                  onPressed: () {
                    if (!profileController.isUpdating.value) {
                      profileController.updateUserName(
                          authController.userId, nameController.text);
                    }
                  },
                  textColor: appColorPrimary,
                  gBgColor1: gradientBgColor1.withAlpha(26),
                  gBgColor2: gradientBgColor1.withAlpha(26),
                )),
          ),
        ));
  }

  Widget _readOnlyField(String value) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        decoration: BoxDecoration(
          color: isDarkMode ? appDarkBgColor : appLightBgColor,
          borderRadius: BorderRadius.circular(textFieldRadius),
          border: Border.all(
            color: isDarkMode
                ? whiteColor.withAlpha(31)
                : appTextColorPrimary.withAlpha(31),
          ),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: isDarkMode ? whiteColor : appTextColorPrimary,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(String name) {
    String initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Center(
      child: CircleAvatar(
        radius: 45,
        backgroundColor: gradientBgColor1,
        child: Text(
          initial,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
