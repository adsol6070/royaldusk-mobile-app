import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';
import 'package:royaldusk_mobile_app/widgets/grediant_button.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/app_images.dart';
import '../../../constant/strings.dart';


class AddNewCardBottomSheet {
  static void show(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: isDarkMode ? appDarkBgColor : appLightBgColor,
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: _buildBottomSheetContent(isDarkMode, context));
      },
    );
  }

  static Widget _buildBottomSheetContent(
      bool isDarkMode, BuildContext context) {
    TextEditingController? cardNumberController;
    TextEditingController? cardExpiryNumberController;
    TextEditingController? cardCvvNumberController;

    bool isChecked = true;
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter mystate) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? appDarkBgColor
                  : appTextColorPrimary.withAlpha(77),
              spreadRadius: 0,
              blurRadius: 40,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(cardNumber,
                  style: TextStyle(fontSize: textSizeMedium)),
              10.height,
              TextFormField(
                style: TextStyle(
                  color: isDarkMode
                      ? whiteColor
                      : appTextColorPrimary, // Set your desired text color
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (v) {},
                validator: (k) {
                  if (k!.isNotEmpty) {
                    return errCardNumber;
                  }
                  return null;
                },
                controller: cardNumberController,
                decoration: inputDecoration(context,
                    borderColor: isDarkMode
                        ? whiteColor.withAlpha(31)
                        : const Color(0x0F1A201F).withAlpha(31),
                    prefixIcon: debitCardIcon,
                    hintColor: isDarkMode ? whiteColor : appTextColorPrimary,
                    borderRadius: textFieldRadius,
                    isSvg: true,
                    fillColor: isDarkMode ? appDarkBgColor : whiteColor,
                    hintText: 'xxxx xxxx xxxx 9581'),
              ),
              20.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(expiresEnd,
                            style: TextStyle(fontSize: textSizeMedium)),
                        10.height,
                        TextFormField(
                          style: TextStyle(
                            color: isDarkMode
                                ? whiteColor
                                : appTextColorPrimary, // Set your desired text color
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (v) {},
                          validator: (k) {
                            if (k!.isNotEmpty) {
                              return errExpiryNumber;
                            }
                            return null;
                          },
                          controller: cardExpiryNumberController,
                          decoration: inputDecoration(context,
                              borderColor: isDarkMode
                                  ? whiteColor.withAlpha(31)
                                  : const Color(0x0F1A201F).withAlpha(31),
                              hintColor:
                                  isDarkMode ? whiteColor : appTextColorPrimary,
                              borderRadius: textFieldRadius,
                              isSvg: true,
                              fillColor:
                                  isDarkMode ? appDarkBgColor : whiteColor,
                              hintText: 'xx/xx'),
                        ),
                      ],
                    ),
                  ),
                  10.width,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(cvv,
                              style: TextStyle(fontSize: textSizeMedium)),
                        ),
                        10.height,
                        TextFormField(
                          style: TextStyle(
                            color: isDarkMode
                                ? whiteColor
                                : appTextColorPrimary, // Set your desired text color
                          ),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (v) {},
                          validator: (k) {
                            if (k!.isNotEmpty) {
                              return errCvvNumber;
                            }
                            return null;
                          },
                          controller: cardCvvNumberController,
                          decoration: inputDecoration(context,
                              borderColor: isDarkMode
                                  ? whiteColor.withAlpha(31)
                                  : const Color(0x0F1A201F).withAlpha(31),
                              hintColor:
                                  isDarkMode ? whiteColor : appTextColorPrimary,
                              borderRadius: textFieldRadius,
                              isSvg: true,
                              fillColor:
                                  isDarkMode ? appDarkBgColor : whiteColor,
                              hintText: 'xxx'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              20.height,

              Row(
                children: [
                  InkWell(
                    onTap: () {
                      mystate(() {
                        isChecked = !isChecked;
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: checkGreenColor),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: isChecked
                            ? const Icon(
                                Icons.check,
                                size: 15.0,
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.check_box_outline_blank,
                                size: 15.0,
                                color: checkGreenColor,
                              ),
                      ),
                    ),
                  ),
                  10.width,
                  Text(
                    savePrimaryCard,
                    style: TextStyle(
                        fontSize: textSizeSMedium,
                        color: isDarkMode
                            ? whiteColor.withAlpha(153)
                            : appTextColorPrimary.withAlpha(153)),
                  )
                ],
              ),
              20.height,
              GradientElevatedButton(onPressed: () {}, text: continueText)
              // Add more widgets as needed
            ],
          ),
        ),
      );
    });
  }
}
