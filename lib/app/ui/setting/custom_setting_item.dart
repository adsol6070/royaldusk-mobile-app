import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/constant/app_images.dart';

import '../../../widgets/app_widget.dart';



class CustomSettingItem extends StatelessWidget {
  final String text1;
  final bool? value;
  final bool isDarkTheme;
  final ValueChanged<bool>? onChanged;
  final bool? isSwitchShow;
  final bool? isIconShow;

  const CustomSettingItem(
      {super.key,
      required this.text1,
      this.value,
      required this.isDarkTheme,
      this.onChanged,
      this.isSwitchShow,
      this.isIconShow});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text1,
          style: const TextStyle(
              fontSize: textSizeMedium), // Adjust the font size as needed
        ),
        if (isSwitchShow != null)
          Transform.scale(
            scale: 0.6,
            // Adjust the scale factor to change the size
            child: CupertinoSwitch(
              value: value!,
              onChanged: onChanged, // Adjust the font size as needed
              activeTrackColor: appColorPrimary,
            ),
          ),

        if (isIconShow != null) Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: SvgPicture.asset(arrowRightIcon,width: 24,height: 24,colorFilter: ColorFilter.mode(isDarkTheme ? whiteColor : appTextColorPrimary, BlendMode.srcIn),),
        )
      ],
    );
  }
}
