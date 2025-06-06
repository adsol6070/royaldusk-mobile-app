import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constant/app_colors.dart';

const textFieldRadius = 45.0;
const iconSize = 35.0;
/* font sizes*/
const textSizeSmall = 12.0;
const textSizeSMedium = 14.0;
const textSizeMedium = 16.0;
const textSizeLargeMedium = 18.0;
const textSizeNormal = 20.0;
const textSizeMLarge = 22.0;
const textSizeLarge = 24.0;
const textSizeLarge1 = 28.0;
const textSizeXLarge = 30.0;
const textSizeXXLarge = 35.0;

Widget text(
  String? text, {
  var fontSize = textSizeLargeMedium,
  Color? textColor,
  var fontFamily,
  var isCentered = false,
  var maxLine = 1,
  var latterSpacing = 0.5,
  bool textAllCaps = false,
  var isLongText = false,
  bool lineThrough = false,
}) {
  return Text(
    textAllCaps ? text!.toUpperCase() : text!,
    textAlign: isCentered ? TextAlign.center : TextAlign.start,
    maxLines: isLongText ? null : maxLine,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      color: textColor ?? appTextColorPrimary,
      height: 1.5,
      letterSpacing: latterSpacing,
      decoration:
          lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
    ),
  );
}

Widget commonCacheImageWidget(String? url, double height,
    {double? width, BoxFit? fit, Color? color}) {
  if (url.validate().startsWith('http')) {
    if (isMobile) {
      return CachedNetworkImage(
        placeholder:
            placeholderWidgetFn() as Widget Function(BuildContext, String)?,
        imageUrl: '$url',
        height: height,
        width: width,
        color: color,
        fit: fit ?? BoxFit.cover,
        errorWidget: (_, __, ___) {
          return SizedBox(height: height, width: width);
        },
      );
    } else {
      return Image.network(url!,
          height: height, width: width, fit: fit ?? BoxFit.cover);
    }
  } else {
    return Image.asset(url!,
        height: height, width: width, fit: fit ?? BoxFit.cover);
  }
}

Widget? Function(BuildContext, String) placeholderWidgetFn() =>
    (_, s) => placeholderWidget();

Widget placeholderWidget() =>
    Image.asset('assets/placeholder.jpg', fit: BoxFit.cover);

PreferredSizeWidget commonAppBarWidget(BuildContext context,
    {String? titleText, Widget? actionWidget, Widget? actionWidget2}) {
  return AppBar(
    centerTitle: true,
    backgroundColor: context.scaffoldBackgroundColor,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Get.back();
      },
    ),
    actions: [
      actionWidget ?? const SizedBox(),
      actionWidget2 ?? const SizedBox()
    ],
    title: Text(titleText ?? "",
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: textSizeNormal, fontWeight: FontWeight.bold)),
    elevation: 0.0,
  );
}


InputDecoration inputDecoration(
    BuildContext context, {
      String? prefixIcon,
      Widget? suffixIcon,
      String? labelText,
      double? borderRadius,
      String? hintText,
      bool? isSvg,
      Color? fillColor,
      Color? borderColor,
      Color? hintColor,
      Color? prefixIconColor,
    }) {
  return InputDecoration(
    // prefixIconColor: prefixIconColor,
    counterText: "",
    contentPadding: const EdgeInsets.all(20),
    labelText: labelText,
    labelStyle: secondaryTextStyle(color: appTextColorPrimary),
    alignLabelWithHint: true,
    hintText: hintText.validate(),
    hintStyle: secondaryTextStyle(
        size: textSizeMedium.toInt(),
        color: hintColor ?? appTextColorPrimary.withAlpha(153)),
    isDense: true,
    prefixIcon: prefixIcon != null
        ? Padding(
      padding: const EdgeInsets.only(left: 20, right: 10),
      child: isSvg == null
          ? SvgPicture.asset(
        prefixIcon,
        width: 16,
        height: 16,
        colorFilter: ColorFilter.mode(
            prefixIconColor ?? appTextColorPrimary,
            BlendMode.srcIn),
      )
          : Image.asset(
        prefixIcon,
        width: 24,
        height: 24,
      ),
    )
        : null,
    prefixIconConstraints: const BoxConstraints(
      minWidth: 20,
      minHeight: 20,
    ),
    suffixIconConstraints: const BoxConstraints(
      minWidth: 20,
      minHeight: 20,
    ),
    suffixIcon: suffixIcon.validate(),
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: borderColor ?? textBorderColor, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide:
      BorderSide(color: borderColor ?? focusBorderColor, width: 1.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red, width: 0.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(color: Colors.red, size: 13),
    filled: true,
    fillColor: fillColor ?? Colors.white,
  );
}




extension Ext on BuildContext {
  ThemeData get theme => Theme.of(this);

  double get w => MediaQuery.of(this).size.width;

  double get h => MediaQuery.of(this).size.height;
}

final LinearGradient unavailableColor = LinearGradient(
  // Where the linear gradient begins and ends
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  // Add one stop for each color. Stops should increase from 0 to 1
  stops: const [0.1, 0.9],
  colors: [
    // Colors are easy thanks to Flutter's Colors class.
    gradientBgColor1.withAlpha(26),
    gradientBgColor2.withAlpha(26),
  ],
);
const LinearGradient availableColor = LinearGradient(
  // Where the linear gradient begins and ends
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  // Add one stop for each color. Stops should increase from 0 to 1
  stops: [0.1, 0.9],
  colors: [
    // Colors are easy thanks to Flutter's Colors class.
    Colors.white,
    Colors.white,
  ],
);
LinearGradient availableDarkColor = const LinearGradient(
  colors: [
    Color(0XFF2C363D),
    Color(0XFF2C363D),
  ],
);
const LinearGradient selectedColor = LinearGradient(
  // Where the linear gradient begins and ends
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  // Add one stop for each color. Stops should increase from 0 to 1
  stops: [0.1, 0.9],
  colors: [
    // Colors are easy thanks to Flutter's Colors class.
    gradientBgColor1,
    gradientBgColor2,
  ],
);
