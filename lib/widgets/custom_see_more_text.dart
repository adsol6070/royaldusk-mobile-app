import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:royaldusk_mobile_app/constant/strings.dart';

import '../constant/app_colors.dart';
import 'app_widget.dart';

class CustomTextSeeMore extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const CustomTextSeeMore(
      {super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: textSizeMedium,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.ubuntu().fontFamily,
              ),
            ),
            Text(
              seeAll,
              style: TextStyle(
                  fontSize: textSizeMedium,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.ubuntu().fontFamily,
                  color: appColorPrimary),
            )
          ],
        ),
      ),
    );
  }
}
