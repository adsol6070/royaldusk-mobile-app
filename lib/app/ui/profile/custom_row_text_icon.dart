import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/constant/app_images.dart';

import '../../../widgets/app_widget.dart';



class CustomRowTextAndIcon extends StatelessWidget {
  final String title;
  final String? icon;
  final bool isDarkMode;
  final VoidCallback onPressed;

  const CustomRowTextAndIcon({
    super.key,
    required this.title,
    required this.onPressed,
     this.icon,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(
            title,
            style:  TextStyle(
              fontSize: textSizeMedium,
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.ubuntu().fontFamily
            ),
          ),
          10.width,
          SvgPicture.asset(
            icon ?? editYellowIcon,
            width: 20,
            height: 20,

          ),

        ],
      ),
    );
  }
}
