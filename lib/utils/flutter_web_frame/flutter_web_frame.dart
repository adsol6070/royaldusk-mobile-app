library flutter_web_frame;

import 'package:royaldusk_mobile_app/constant/strings.dart';
import 'package:royaldusk_mobile_app/route/my_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/controller/theme_controller.dart';
import '../../constant/app_colors.dart';
import 'src/frame_content.dart';
import 'src/media_query_observer.dart';

class FlutterWebFrame extends StatefulWidget {
  /// If not [enabled], the [child] is used directly.
  final bool enabled;

  /// The previewed widget.
  ///
  /// It is common to give the root application widget.
  final WidgetBuilder builder;

  /// Background color in white space
  final Color? backgroundColor;

  /// Maximum size
  final Size maximumSize;

  /// Clip behavior
  final Clip clipBehavior;

  const FlutterWebFrame({
    Key? key,
    required this.builder,
    this.enabled = true,
    this.backgroundColor,
    required this.maximumSize,
    this.clipBehavior = Clip.none,
  }) : super(key: key);

  /// A global builder that should be inserted into [WidgetApp]'s builder
  /// to simulated the simulated device screen and platform properties.
  static Widget appBuilder(BuildContext context,
      Widget? widget,) {
    if (!_isEnabled(context)) {
      return widget ?? const SizedBox();
    }

    if (!_isEnabled(context)) return widget ?? const SizedBox();

    return MediaQuery(
      data: _mediaQuery(context),
      child: Theme(
        data: Theme.of(context).copyWith(
          visualDensity: _isEnabled(context) ? VisualDensity.standard : null,
        ),
        child: widget ?? const SizedBox(),
      ),
    );
  }

  static MediaQueryData _mediaQuery(BuildContext context) {
    return FrameContent.mediaQuery(
      context,
      context
          .findAncestorStateOfType<FlutterWebFrameState>()
          ?.widget
          .maximumSize ??
          const Size(375.0, 812.0),
    );
  }

  static bool _isEnabled(BuildContext context) {
    final state = context.findAncestorStateOfType<FlutterWebFrameState>();
    return state != null && state.widget.enabled;
  }

  @override
  FlutterWebFrameState createState() => FlutterWebFrameState();
}

class FlutterWebFrameState extends State<FlutterWebFrame> {
  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return Builder(
        builder: widget.builder,
      );
    }

    return Container(
      color: widget.backgroundColor ?? Theme
          .of(context)
          .dividerColor,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: MediaQueryObserver(
          child: widget.enabled
              ? Builder(builder: _buildPreview)
              : Builder(builder: widget.builder),
        ),
      ),
    );
  }

  Widget _buildPreview(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return FittedBox(
      fit: BoxFit.contain,
      child: RepaintBoundary(
        child: FrameContent(
          size: widget.maximumSize,
          clipBehavior: widget.clipBehavior,
          headerSection: Observer(builder: (context) {
            return GetBuilder<ThemeController>(
                init: ThemeController(),
                builder: (themeController) {
                  return Obx(
                        () =>
                        Container(
                          width: 475.0,
                          padding: const EdgeInsets.all(8),
                          color: themeController.isDarkMode
                              ? cardDarkColor
                              : cardLightColor,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                textDirection: TextDirection.ltr,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.all(4),
                                      height: 60,
                                      width: 60,
                                      child: SvgPicture.asset('assets/app_logo.svg',
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.cover)),
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: TextButton(
                                      onPressed: () {
                                        Get.offNamedUntil(
                                            MyRoutes.mainDrawerScreen, (route) => false);
                                        // finish(context);
                                        // commonLaunchUrl(MainSiteUrl);
                                      },
                                      child: Text(appName,
                                          style: TextStyle(
                                              fontFamily:
                                              GoogleFonts
                                                  .ubuntu()
                                                  .fontFamily,
                                              letterSpacing: 0.8,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: themeController.isDarkMode
                                                  ? Colors.white
                                                  : appTextColorPrimary),
                                          textDirection: TextDirection.ltr),
                                    ),
                                  ),
                                  const Spacer(),
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: AppButton(
                                      elevation: 0,
                                      color: appColorPrimary,
                                      height: 10,
                                      onTap: () {
                                        commonLaunchUrl(
                                            "https://codecanyon.net/item/explore-ease-flutter-travel-app-template-ui-kit-figma-free/50707980");
                                      },
                                      child: Text('Buy Now',
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                          textDirection: TextDirection.ltr),
                                    ),
                                  ),
                                ],
                              ).paddingOnly(left: 8, right: 8),
                              Divider(height: 0, color: context.dividerColor),
                            ],
                          ),
                        ),
                  );
                });
          }),
          footerSection: Observer(builder: (context) {
            return GetBuilder<ThemeController>(
                init: ThemeController(),
                builder: (themeController) {
                  return Obx(
                        () =>
                        Container(
                          alignment: Alignment.center,
                          decoration: boxDecorationDefault(
                            borderRadius: radius(0),
                            color:
                            themeController.isDarkMode
                                ? cardDarkColor
                                : cardLightColor,
                          ),
                          width: 475.0,
                          child: Column(
                            children: [
                              Divider(height: 0, color: context.dividerColor),
                              Text(
                                  'Copyright © 2024. Crafted with passion by Imperia Themes.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: textSecondaryColor),
                                  textDirection: TextDirection.ltr)
                                  .paddingAll(12),
                            ],
                          ),
                        ),
                  );
                });
          }),
          child: Builder(builder: widget.builder),
        ),
      ),
    );
  }
}

Future<bool> commonLaunchUrl(String address, {
  LaunchMode launchMode = LaunchMode.inAppWebView,
}) async {
  try {
    await launchUrl(
      Uri.parse(address),
      mode: launchMode,
    );
    return true; // Success
  } catch (e) {
    Get.snackbar(
      'Error',
      'Failed to launch URL: $address',
    );
    return false; // Error
  }
}
