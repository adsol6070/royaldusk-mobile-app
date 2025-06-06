import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';

import 'app_widget.dart';

class CustomButtonWithIcon extends StatelessWidget {
  final String text;
  final String icon;
  final VoidCallback onPressed;

  const CustomButtonWithIcon(
      {super.key,
      required this.text,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // padding: const EdgeInsets.all(17),
        textStyle: const TextStyle(fontSize: textSizeMedium),
        shape: const StadiumBorder(),
        backgroundColor: whiteColor,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: 24,
            height: 24,
          ),
          10.width,
          Text(text, style: primaryTextStyle(size: textSizeMedium.toInt()))
        ],
      ),
    );
  }
}
