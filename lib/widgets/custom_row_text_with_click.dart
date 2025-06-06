import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/constant/strings.dart';

import '../constant/app_colors.dart';
import 'app_widget.dart';

class CustomRowTextWithClick extends StatelessWidget {
  final String title;
  final String? title2;
  final VoidCallback onPressed;
  final bool isDarkMode;
  final Color? color;
  final Color? titleColor;
  final FontWeight? titleFontWeight;

  const CustomRowTextWithClick({
    super.key,
    required this.title,
    required this.onPressed,
    required this.isDarkMode,
    this.color,
    this.title2,
    this.titleColor,
    this.titleFontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isDarkMode
                ? titleColor ?? whiteColor.withAlpha(153)
                : titleColor ??  appTextColorPrimary.withAlpha(153),
            fontSize: textSizeMedium,
            fontWeight:titleFontWeight ?? FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: onPressed,
          child: Text(
            title2 ?? edit,
            style: TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: color ?? redColor1,
                fontSize: textSizeMedium,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.ubuntu().fontFamily,
                color: color ?? redColor1),
          ),
        )
      ],
    );
  }
}
