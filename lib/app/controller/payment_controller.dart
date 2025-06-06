import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controller/theme_controller.dart';


class PaymentController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

  RxString selectedPaymentMethod = ''.obs;
  final formKey = GlobalKey<FormState>();
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  TextEditingController? cardNumberController;
  TextEditingController? voucherCodeController;

  void selectPaymentMethod(String paymentMethod) {
    selectedPaymentMethod.value = paymentMethod;
  }

  void proceedToPayment() {
    if (selectedPaymentMethod.isNotEmpty) {
      // print('Selected Payment Method: ${selectedPaymentMethod.value}');
      // Implement your payment logic here
    } else {
      Get.snackbar('Error', 'Please select a payment method.');
    }
  }
}
