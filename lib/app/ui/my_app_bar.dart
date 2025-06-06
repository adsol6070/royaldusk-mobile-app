import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant/app_images.dart';
import '../../widgets/app_widget.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(80);

  // final MainHomeController controller;
  final bool isDarkMode;

  // bool isDarkTheme;

  const MyAppBar(
      {super.key, /*required this.controller, */ required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                ZoomDrawer.of(context)!.toggle();
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20),
                child: CircleAvatar(
                  radius: 22.0,
                  backgroundColor: Colors.transparent,
                  // Set a transparent background
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      'https://i.ibb.co/JkbSSVZ/main-thumb-2130102404-200-ynberwrkslqbjankshjkcjagxxmtytsa.jpg',
                      // Replace with your image URL
                      // width: 55.0, // Set the width of the image
                      // height: 55.0, // Set the height of the image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(mapIcon,
                    height: 15, width: 15, fit: BoxFit.scaleDown),
                10.width,
                Text('New York, USA',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        letterSpacing: 0.3,
                        fontSize: textSizeMedium,
                        fontWeight: FontWeight.w600,
                        fontFamily: GoogleFonts.ubuntu().fontFamily)),
              ],
            ),
            Container(
              width: 45,
              height: 45,
              margin: const EdgeInsets.only(right: 20, top: 10),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: boxShadowColor.withAlpha(204),
                  spreadRadius: 0,
                  blurRadius: 32,
                  offset: const Offset(0, 6),
                )
              ]),
              child: SvgPicture.asset(
                isDarkMode ? sideMenuBlackIcon : sideMenuIcon,
                // height: 55,
                // width: 55,
              ),
            ),
            /* IconButton(
              iconSize: 60,
              style: ButtonStyle(
                shadowColor: MaterialStateProperty.all(
                  Colors.black.withAlpha(204),
                ),
                elevation: MaterialStateProperty.all(5.0),
              ),
              icon: SvgPicture.asset(
                sideMenuLightIcon,
                height: 55,
                width: 55,
              ),
              onPressed: () {
                // print("your menu action here");
              },
            ),*/
          ],
        ),
      ),
    );
    /*return AppBar(
      leading: GestureDetector(
        onTap: () {
          ZoomDrawer.of(context)!.toggle();
        },
        child: CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.transparent, // Set a transparent background
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              'https://i.ibb.co/JkbSSVZ/main-thumb-2130102404-200-ynberwrkslqbjankshjkcjagxxmtytsa.jpg',
              // Replace with your image URL
              width: 45.0, // Set the width of the image
              height: 45.0, // Set the height of the image
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(mapIcon,
              height: 15, width: 15, fit: BoxFit.scaleDown),
          10.width,
          Text('New York, USA',
              textAlign: TextAlign.center,
              style: TextStyle(
                  letterSpacing: 0.3,
                  fontSize: textSizeMedium,
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.ubuntu().fontFamily)),
        ],
      ),
      actions: [
        IconButton(
          style: ButtonStyle(
            shadowColor: MaterialStateProperty.all(
              Colors.black.withAlpha(204),
            ),
            elevation: MaterialStateProperty.all(5.0),
          ),
          icon: SvgPicture.asset(
            sideMenuIcon,
            height: 45,
            width: 45,
          ),
          onPressed: () {
            // print("your menu action here");
          },
        ),
      ],
    );*/
  }
}
