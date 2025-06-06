import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/app_colors.dart';
import '../../../widgets/app_widget.dart';

class OtpTextField extends StatelessWidget {
  final FocusNode focusNode;
  final Function(String) onTextChanged;
  final bool isDarkMode;

  const OtpTextField({super.key,
    required this.focusNode,
    required this.onTextChanged,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            width: 1,
            color: isDarkMode
                ? whiteColor.withAlpha(31)
                : appTextColorPrimary.withAlpha(31)),
      ),
      child: TextField(
        style:
        const TextStyle(fontSize: textSizeNormal,fontWeight: FontWeight.w600),
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: const InputDecoration(
          counter: Offstage(),
          border: InputBorder.none,

        ),
        onChanged: onTextChanged,
      ),
    );
  }
}
