import 'package:royaldusk_mobile_app/app/ui/popular_package/scan_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';
import 'package:royaldusk_mobile_app/widgets/custom_row_text_with_click.dart';
import 'package:royaldusk_mobile_app/widgets/grediant_button.dart';

import '../../../constant/app_images.dart';
import '../../../constant/strings.dart';
import '../../controller/payment_controller.dart';
import 'add_new_card.dart';
import 'booking_success_dialog.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  late PaymentController controller;

  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    controller = PaymentController();
    isDarkMode = controller.themeController.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(
        init: controller,
        tag: 'travel_payment',
        // theme: theme,
        builder: (controller) {
          return Scaffold(
            bottomNavigationBar: Container(
              padding: const EdgeInsets.all(20),
              height: 100,
              child: GradientElevatedButton(
                  onPressed: () async {
                    if (controller.selectedPaymentMethod.value.isNotEmpty) {
                      // Implement your payment logic here
                      // print('Selected Payment Method: ${controller.selectedPaymentMethod.value}');
          
                      /*if (controller.formKey.currentState!
                                    .validate()) {*/
                      await BookingSuccessDialog()
                          .customDialog(context, isDarkMode);
                      // controller.goToNextScreen();
                      // }
                    } else {
                      Get.snackbar(
                          'Error', 'Please select a payment method.');
                    }
                  },
                  text: continueText
                  // ,height: 70,
                  ),
            ),
            backgroundColor: isDarkMode ? appDarkBgColor : whiteColor,
            appBar: commonAppBarWidget(context,
                titleText: payment,
                actionWidget: IconButton(
                    onPressed: () {
                      Get.off(const ScanCardScreen());
                    },
                    icon: SvgPicture.asset(
                      scanIcon,
                      width: 24,
                      height: 24,
                    ))),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomRowTextWithClick(
                          title: paymentMethod,
                          onPressed: () {
                            AddNewCardBottomSheet.show(context, isDarkMode);
                          },
                          title2: addNewCard,
                          color: appColorPrimary,
                          isDarkMode: isDarkMode,
                          titleFontWeight: FontWeight.w600,
                          titleColor:
                              isDarkMode ? whiteColor : appTextColorPrimary,
                        ),
                        30.height,
                        CustomRadioButton(
                            label: applePay,
                            icon: isDarkMode ? appleWhiteIcon : appleIcon,
                            isDarkMode: isDarkMode,
                            controller: controller),
                        20.height,
                        CustomRadioButton(
                            label: payPal,
                            icon: payPalIcon,
                            isDarkMode: isDarkMode,
                            controller: controller),
                        20.height,
                        CustomRadioButton(
                            label: googlePay,
                            icon: googleIcon,
                            isDarkMode: isDarkMode,
                            controller: controller),
                        20.height,
                        Row(
                          children: [
                            Obx(
                              () => Radio(
                                activeColor: appColorPrimary,
                                value: payByDebitCreditCard,
                                groupValue:
                                    controller.selectedPaymentMethod.value,
                                onChanged: (value) {
                                  controller.selectPaymentMethod(value!);
                                },
                              ),
                            ),
                            const Text(
                              payByDebitCreditCard,
                              style: TextStyle(
                                  fontSize: textSizeMedium,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
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
                          onFieldSubmitted: (v) {
                            controller.f1.unfocus();
                          },
                          validator: (k) {
                            if (k!.isNotEmpty) {
                              return errCardNumber;
                            }
                            return null;
                          },
                          controller: controller.cardNumberController,
                          decoration: inputDecoration(context,
                              borderColor: isDarkMode
                                  ? whiteColor.withAlpha(31)
                                  : const Color(0x0F1A201F).withAlpha(31),
                              prefixIcon: debitCardIcon,
                              hintColor:
                                  isDarkMode ? whiteColor : appTextColorPrimary,
                              borderRadius: textFieldRadius,
                              isSvg: true,
                              fillColor:
                                  isDarkMode ? appDarkBgColor : whiteColor,
                              hintText: 'xxxx xxxx xxxx 9581'),
                        ),
                        20.height,
                        const Text(
                          addVoucher,
                          style: TextStyle(
                              fontSize: textSizeMedium,
                              fontWeight: FontWeight.bold),
                        ),
                        20.height,
                        Container(
                          padding: const EdgeInsets.all(0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              // color: isDarkMode ? whiteColor:Color(0x0F1A201F).withAlpha(31),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  color: isDarkMode
                                      ? whiteColor.withAlpha(31)
                                      : const Color(0x0F1A201F)
                                          .withAlpha(31))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  style: const TextStyle(
                                    color:
                                        appTextColorPrimary, // Set your desired text color
                                  ),
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.number,
                                  onFieldSubmitted: (v) {
                                    controller.f2.unfocus();
                                  },
                                  validator: (k) {
                                    if (k!.length > 1) {
                                      return errcodeNumber;
                                    }
                                    return null;
                                  },
                                  controller: controller.voucherCodeController,
                                  decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      fillColor: Colors.transparent,
                                      border: InputBorder.none,
                                      hintText: voucherCode),
                                ),
                              ),
                              GradientElevatedButton(
                                text: apply,
                                width: 100,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        20.height,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class CustomRadioButton extends StatelessWidget {
  final String label;
  final String icon;
  final bool isDarkMode;
  final PaymentController controller;

  const CustomRadioButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isDarkMode,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
          // color: isDarkMode ? whiteColor:Color(0x0F1A201F).withAlpha(31),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: isDarkMode
                  ? whiteColor.withAlpha(31)
                  : const Color(0x0F1A201F).withAlpha(31))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          5.width,
          SvgPicture.asset(
            icon,
            width: 24,
            height: 24,
          ),
          15.width,
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: textSizeMedium),
            ),
          ),
          Obx(
            () => Radio(
              activeColor: appColorPrimary,
              value: label,
              groupValue: controller.selectedPaymentMethod.value,
              onChanged: (value) {
                controller.selectPaymentMethod(value!);
              },
            ),
          ),
        ],
      ),
    );
  }
}
