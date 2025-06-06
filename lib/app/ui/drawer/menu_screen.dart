import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/constant/app_images.dart';

import '../../../constant/strings.dart';
import '../../../widgets/app_widget.dart';
import 'custom_row_icon_text.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appColorPrimary,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: commonCacheImageWidget(
                  'https://i.ibb.co/JkbSSVZ/main-thumb-2130102404-200-ynberwrkslqbjankshjkcjagxxmtytsa.jpg', 60,
                  width: 60),
            ),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Jonathan Smith',
                style: TextStyle(
                    fontSize: textSizeLargeMedium,
                    fontWeight: FontWeight.w600,
                    color: whiteColor),
              ),
              Text(
                'jonathansmith@gmail.com',
                style: TextStyle(
                    fontSize: textSizeSMedium,
                    fontWeight: FontWeight.w400,
                    color: whiteColor.withAlpha(179)),
              ),
            ],
          ),
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
              child: CustomRowIconAndText(
                  title: signOut, onPressed: () {}, icon: drawerLogoutIcon),
            ),
          ],
        ),
      ),
    );
  }
}

void goToNextScreen(String name) {
  Get.toNamed('/$name/');
}
