import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/constant/app_images.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';

class SuggestionViewScreen extends StatelessWidget {
  final bool isDarkMode;
  final String text;
  final VoidCallback onPressed;

  const SuggestionViewScreen(
      {super.key, required this.isDarkMode, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onPressed ,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              clockIcon,
              height: 20,
              width: 20,
              colorFilter: ColorFilter.mode(
                  isDarkMode
                      ? whiteColor.withAlpha(153)
                      : appTextColorPrimary.withAlpha(153),
                  BlendMode.srcIn),
            ),
            10.width,
            Expanded(
                child: Text(
              text,
              style: TextStyle(
                color: isDarkMode
                    ? whiteColor.withAlpha(153)
                    : appTextColorPrimary.withAlpha(153),
                fontSize: textSizeMedium,
                fontWeight: FontWeight.w500
              ),
            )),
            SvgPicture.asset(
              clearIcon,
              height: 20,
              width: 20,
              colorFilter: ColorFilter.mode(
                  isDarkMode
                      ? whiteColor.withAlpha(153)
                      : appTextColorPrimary.withAlpha(153),
                  BlendMode.srcIn),
            )
          ],
        ),
      ),
    );
  }
}
