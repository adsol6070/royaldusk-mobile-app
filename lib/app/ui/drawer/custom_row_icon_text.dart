import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../widgets/app_widget.dart';



class CustomRowIconAndText extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onPressed;

  const CustomRowIconAndText({
    super.key,
    required this.title,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
            ),
            10.width,
            Text(
              title,
              style: const TextStyle(
                color: whiteColor,
                fontSize: textSizeMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
