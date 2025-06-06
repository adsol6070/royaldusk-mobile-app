import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/constant/app_images.dart';

import '../../../constant/app_colors.dart';



class CategoryView extends StatelessWidget {
  final int selectedCatIndex;
  final bool isDarkMode;
  final bool isShowRattingIcon;
  final int i;
  final String name;

  const CategoryView({
    super.key,
    required this.isDarkMode,
    required this.selectedCatIndex,
    required this.i,
    required this.name,
    required this.isShowRattingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: (selectedCatIndex == i) ? appColorPrimary : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: (selectedCatIndex == i)
            ? null
            : Border.all(
                color: isDarkMode
                    ? whiteColor.withAlpha(26)
                    : appTextColorPrimary.withAlpha(26)),
      ),
      child: Row(
        children: [
          if (isShowRattingIcon)
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: SvgPicture.asset(
                starIcon,
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(
                    (selectedCatIndex == i)
                        ? whiteColor
                        : isDarkMode
                            ? whiteColor
                            : appTextColorPrimary,
                    BlendMode.srcIn),
              ),
            ),

          Text(
            name,
            style: TextStyle(
                color: (selectedCatIndex == i)
                    ? whiteColor
                    : isDarkMode
                        ? whiteColor
                        : appTextColorPrimary),
          ),
        ],
      ),
    );
  }
}
