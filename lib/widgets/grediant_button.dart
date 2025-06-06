import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/app_colors.dart';
import 'app_widget.dart';

class GradientElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double? width;
  final double? height;
  final double? fontSize;
  final Color? gBgColor1;
  final Color? gBgColor2;
  final Color? textColor;
  final BoxBorder? boxBorder;

  const GradientElevatedButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.width,
      this.height,
      this.fontSize,
      this.gBgColor1,
      this.gBgColor2,
      this.textColor,
      this.boxBorder});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 60.0,
      decoration: BoxDecoration(
        border: boxBorder,
        borderRadius: BorderRadius.circular(30.0),
        gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // Add one stop for each color. Stops should increase from 0 to 1
          stops: const [0.1, 0.9],
          colors: [
            // Colors are easy thanks to Flutter's Colors class.
            gBgColor1 ?? gradientBgColor1,
            gBgColor2 ?? gradientBgColor2,
          ],
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 4,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              fontFamily: GoogleFonts.ubuntu().fontFamily,
              fontSize: fontSize ?? textSizeMedium,
              fontWeight: FontWeight.w600,
              color: textColor ?? Colors.white),
        ),
      ),
    );
  }
}
