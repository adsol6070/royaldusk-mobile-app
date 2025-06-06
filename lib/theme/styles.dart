import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constant/app_colors.dart';

abstract class Styles {
  //colors
  static const Color whiteColor = Color(0xffffffff);

  static const Color darkThemeColor = Color(0xff33333E);

  static const double letterSpacing = 0.3;
  static const double letterHeight = 1.5;

  static final ThemeData lightTheme = ThemeData(

          scaffoldBackgroundColor: whiteColor,
          primaryColor: appColorPrimary,
          primaryColorDark: appColorPrimary,
          hoverColor: Colors.white54,
          dividerColor: viewLineColor,
          fontFamily: GoogleFonts.urbanist().fontFamily,
          bottomNavigationBarTheme:
              const BottomNavigationBarThemeData(backgroundColor: whiteColor),
          appBarTheme: const AppBarTheme(

            actionsIconTheme: IconThemeData(color: Styles.whiteColor),
            backgroundColor: appLightBgColor,
            // color: whiteColor,
            iconTheme: IconThemeData(color: appTextColorPrimary),
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
          ),
          textSelectionTheme:
              const TextSelectionThemeData(cursorColor: Colors.black),
          colorScheme: const ColorScheme.light(primary: Colors.white),
          cardTheme: const CardThemeData(color: Colors.white),
          cardColor: cardLightColor,
          iconTheme: const IconThemeData(color: appTextColorPrimary),
          bottomSheetTheme:
              const BottomSheetThemeData(backgroundColor: whiteColor),
          primaryTextTheme: const TextTheme(
              titleLarge: TextStyle(
                color: appTextColorPrimary,
                letterSpacing: letterSpacing,
                height: letterHeight,
              ),
              labelSmall: TextStyle(
                  color: appTextColorPrimary,
                  letterSpacing: letterSpacing,
                  height: letterHeight)),
          textTheme: const TextTheme(
            labelLarge: TextStyle(
                color: appColorPrimary,
                letterSpacing: letterSpacing,
                height: letterHeight),
            titleLarge: TextStyle(
                color: appTextColorPrimary,
                letterSpacing: letterSpacing,
                height: letterHeight),
            titleSmall: TextStyle(
                color: textSecondaryColor,
                letterSpacing: letterSpacing,
                height: letterHeight),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          popupMenuTheme: const PopupMenuThemeData(color: whiteColor))
      .copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: OpenUpwardsPageTransitionsBuilder(),
        }),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: appBackgroundColorDark,
    highlightColor: appBackgroundColorDark,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: appBottomNavigationDarkColor),
    appBarTheme: const AppBarTheme(
      actionsIconTheme: IconThemeData(color: Styles.whiteColor),
      titleTextStyle: TextStyle(color: Colors.white),
      backgroundColor: appDarkBgColor,
      iconTheme: IconThemeData(color: Styles.whiteColor),
      systemOverlayStyle:
          SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
    ),
    primaryColor: colorPrimaryBlack,
    dividerColor: const Color.fromRGBO(218, 218, 218, 0.3),
    primaryColorDark: colorPrimaryBlack,
    textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white, selectionColor: Colors.white),
    hoverColor: Colors.black12,
    fontFamily: GoogleFonts.urbanist().fontFamily,
    bottomSheetTheme:
        const BottomSheetThemeData(backgroundColor: appBackgroundColorDark),
    primaryTextTheme: const TextTheme(
        titleLarge: TextStyle(
            color: Colors.white,
            letterSpacing: letterSpacing,
            height: letterHeight),
        labelSmall: TextStyle(
            color: Colors.white,
            letterSpacing: letterSpacing,
            height: letterHeight)),
    cardTheme: const CardThemeData(color: cardBackgroundBlackDark),
    cardColor: appSecondaryBackgroundColor,
    iconTheme: const IconThemeData(color: whiteColor),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          color: Colors.white,
          letterSpacing: letterSpacing,
          height: letterHeight),
      headlineSmall: TextStyle(
          color: Colors.white,
          letterSpacing: letterSpacing,
          height: letterHeight),
      headlineMedium: TextStyle(
          color: Colors.white,
          letterSpacing: letterSpacing,
          height: letterHeight),
      bodyLarge: TextStyle(
          color: Colors.white,
          letterSpacing: letterSpacing,
          height: letterHeight),
      bodyMedium: TextStyle(
          color: Colors.white,
          letterSpacing: letterSpacing,
          height: letterHeight),
      bodySmall: TextStyle(
          color: Colors.white,
          letterSpacing: letterSpacing,
          height: letterHeight),
      displayLarge: TextStyle(
          color: Colors.white,
          letterSpacing: letterSpacing,
          height: letterHeight),
      displayMedium: TextStyle(
          color: Colors.white,
          letterSpacing: letterSpacing,
          height: letterHeight),
      displaySmall: TextStyle(
          color: Colors.white,
          letterSpacing: letterSpacing,
          height: letterHeight),
      labelLarge: TextStyle(
          color: Colors.white,
          letterSpacing: letterSpacing,
          height: letterHeight),
      titleLarge: TextStyle(
          color: whiteColor,
          letterSpacing: letterSpacing,
          height: letterHeight),
      titleSmall: TextStyle(
          color: Colors.white,
          letterSpacing: letterSpacing,
          height: letterHeight),
    ),
    popupMenuTheme: const PopupMenuThemeData(color: appTextColorPrimary),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: const ColorScheme.dark(
            primary: appBackgroundColorDark, onPrimary: cardBackgroundBlackDark)
        .copyWith(secondary: whiteColor),
  ).copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: OpenUpwardsPageTransitionsBuilder(),
        }),
  );

  static Color primaryColor = appColorPrimary;
  static Color textColor = const Color(0xFF3b3b3b);
  static Color bgColor = const Color(0xFFeeedf2);
  static Color orangeColor = const Color(0xFFF37B67);
  static Color kakiColor = const Color(0xFFd2bdd6);
  static TextStyle textStyle =
      TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.w500);
  static TextStyle headLineStyle1 =
      TextStyle(fontSize: 26, color: textColor, fontWeight: FontWeight.bold);
  static TextStyle headLineStyle2 =
      TextStyle(fontSize: 21, color: textColor, fontWeight: FontWeight.bold);
  static const TextStyle headLineStyle3 =
      TextStyle(fontSize: 17, fontWeight: FontWeight.bold);
  static TextStyle headLineStyle4 = TextStyle(
      fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.bold);
}
