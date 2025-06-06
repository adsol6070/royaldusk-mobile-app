import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/app_colors.dart';



class CustomRowText extends StatelessWidget {
  final String text;
  final Gradient gradient;

  const CustomRowText({super.key, required this.text, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: appTextColorPrimary.withAlpha(128), width: 1),
          ),
        ),
        8.width,
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
