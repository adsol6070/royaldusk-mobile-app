import 'package:card_scanner/card_scanner.dart';
import 'package:get/get.dart';
import '../controller/theme_controller.dart';

class ScanCardController extends GetxController {
  final ThemeController themeController = Get.put(ThemeController());

  CardDetails? cardDetails;
  CardScanOptions scanOptions = const CardScanOptions(
    scanCardHolderName: true,
    // enableDebugLogs: true,
    validCardsToScanBeforeFinishingScan: 5,
    possibleCardHolderNamePositions: [
      CardHolderNameScanPosition.aboveCardNumber,
    ],
  );

  Future<void> scanCard() async {
    final CardDetails? cardDetails = await CardScanner.scanCard(scanOptions: scanOptions);
    if (cardDetails != null) {
      this.cardDetails = cardDetails;
    }
  }

}
