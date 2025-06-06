import 'package:royaldusk_mobile_app/app/ui/flight/select_flight_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';

import '../../../constant/app_images.dart';
import '../../../constant/strings.dart';
import '../../../widgets/grediant_button.dart';
import '../../controller/search_flight_controller.dart';


class SearchFlightScreen extends StatefulWidget {
  const SearchFlightScreen({super.key});

  @override
  SearchFlightScreenState createState() => SearchFlightScreenState();
}

class SearchFlightScreenState extends State<SearchFlightScreen> {
  late SearchFlightController controller;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SearchFlightController());
    isDarkMode = controller.themeController.isDarkMode;
  }

  Map<TripType, String> tripTypes = {
    TripType.rountrip: roundTrip,
    TripType.oneway: oneWay,
    TripType.multicity: multiCity
  };

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchFlightController>(
      builder: (SearchFlightController controller) {
        return Scaffold(
                  backgroundColor: isDarkMode ? appDarkBgColor : appLightBgColor,
                  appBar: commonAppBarWidget(context, titleText: searchFlight),
                  body: SafeArea(
                    child: Form(
                            key: controller.formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(
                                    () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(tripTypes.length, (index) {
                      return buildTripTypeSelector(
                          tripTypes.keys.elementAt(index));
                    }),
                                    ),
                                  ),
                                  10.height,
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                        width: 1,
                        color: isDarkMode
                            ? whiteColor.withAlpha(26)
                            : appTextColorPrimary.withAlpha(26)),
                                    ),
                                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fromLocation,
                        style: TextStyle(
                            fontSize: textSizeSMedium,
                            color: isDarkMode
                                ? whiteColor.withAlpha(153)
                                : appTextColorPrimary.withAlpha(153)),
                      ),
                      10.height,
                      Center(
                        child: SizedBox(
                          height: 20,
                          child: TextFormField(
                            style: TextStyle(
                              color: isDarkMode
                                  ? whiteColor
                                  : appTextColorPrimary, // Set your desired text color
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            onFieldSubmitted: (v) {},
                            validator: (k) {
                              if (k!.isEmpty) {
                                return "input value";
                              }
                              return null;
                            },
                            controller: controller.fromController,
                            decoration: const InputDecoration(
                              fillColor: Colors.transparent,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                        width: 1,
                        color: isDarkMode
                            ? whiteColor.withAlpha(26)
                            : appTextColorPrimary.withAlpha(26)),
                                    ),
                                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        toLocation,
                        style: TextStyle(
                            fontSize: textSizeSMedium,
                            color: isDarkMode
                                ? whiteColor.withAlpha(153)
                                : appTextColorPrimary.withAlpha(153)),
                      ),
                      10.height,
                      Center(
                        child: SizedBox(
                          height: 20,
                          child: TextFormField(
                            style: TextStyle(
                              color: isDarkMode
                                  ? whiteColor
                                  : appTextColorPrimary, // Set your desired text color
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            onFieldSubmitted: (v) {},
                            validator: (k) {
                              if (k!.isEmpty) {
                                return "input value";
                              }
                              return null;
                            },
                            controller: controller.toController,
                            decoration: const InputDecoration(
                              fillColor: Colors.transparent,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                    Expanded(
                      child: Container(
                        // width: double.infinity,
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                              width: 1,
                              color: isDarkMode
                                  ? whiteColor.withAlpha(26)
                                  : appTextColorPrimary.withAlpha(26)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              departure,
                              style: TextStyle(
                                  fontSize: textSizeSMedium,
                                  color: isDarkMode
                                      ? whiteColor.withAlpha(153)
                                      : appTextColorPrimary.withAlpha(153)),
                            ),
                            10.height,
                            Center(
                              child: SizedBox(
                                height: 20,
                                child: TextFormField(
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? whiteColor
                                        : appTextColorPrimary, // Set your desired text color
                                  ),
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  onFieldSubmitted: (v) {},
                                  validator: (k) {
                                    if (k!.isEmpty) {
                                      return "input value";
                                    }
                                    return null;
                                  },
                                  controller: controller.departureController,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.transparent,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        // width: double.infinity,
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                              width: 1,
                              color: isDarkMode
                                  ? whiteColor.withAlpha(26)
                                  : appTextColorPrimary.withAlpha(26)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              returnText,
                              style: TextStyle(
                                  fontSize: textSizeSMedium,
                                  color: isDarkMode
                                      ? whiteColor.withAlpha(153)
                                      : appTextColorPrimary.withAlpha(153)),
                            ),
                            10.height,
                            Center(
                              child: SizedBox(
                                height: 20,
                                child: TextFormField(
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? whiteColor
                                        : appTextColorPrimary, // Set your desired text color
                                  ),
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  onFieldSubmitted: (v) {},
                                  validator: (k) {
                                    if (k!.isEmpty) {
                                      return "input value";
                                    }
                                    return null;
                                  },
                                  controller: controller.returnController,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.transparent,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                                    ],
                                  ),
                                  10.height,
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Text(
                    classText,
                    style: TextStyle(
                        fontSize: textSizeMedium,
                        color: isDarkMode
                            ? whiteColor.withAlpha(153)
                            : appTextColorPrimary.withAlpha(153)),
                                    ),
                                  ),
                                  Row(
                                    children: [
                    _buildClassValues(economy),
                    _buildClassValues(business),
                    _buildClassValues(elite),
                                    ],
                                  ),
                                  10.height,
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            personTitle,
                            style: TextStyle(
                              color: isDarkMode
                                  ? whiteColor.withAlpha(153)
                                  : appTextColorPrimary.withAlpha(153),
                              fontSize: textSizeMedium,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          _buildText('02 Persons'),
                        ],
                      ),
                      // Flexible(fit: FlexFit.tight, child: SizedBox()),
                      _buildQtyPicker()
                    ],
                                    ),
                                  ),
                                  10.height,
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Row(
                    children: [
                      SvgPicture.asset(
                        infoCircleIcon,
                        width: 16,
                        height: 16,
                        colorFilter: ColorFilter.mode(
                            isDarkMode
                                ? whiteColor.withAlpha(153)
                                : appTextColorPrimary.withAlpha(153),
                            BlendMode.srcIn),
                      ),
                      5.width,
                      Text(
                        'Every person you add it will be \$520',
                        style: TextStyle(
                            color: isDarkMode
                                ? whiteColor.withAlpha(153)
                                : appTextColorPrimary.withAlpha(153),
                            fontWeight: FontWeight.w500,
                            fontSize: textSizeSmall),
                      )
                    ],
                                    ),
                                  ),
                                  30.height,
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: GradientElevatedButton(
                      onPressed: () {
                        Get.to(const SelectFlightScreen());
                      },
                      text: searchFlights),
                                  ),
                                  20.height,
                                ],
                              ),
                            ),
                    ),
                  ),
                );
      },
    );
  }

  _buildQtyPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => controller.decrement(),
          child: SvgPicture.asset(
            isDarkMode ? minusWhiteIcon : minusIcon,
            width: 24,
            height: 24,
          ),
        ),
        10.width,
        Obx(
          () => Text(
            '${controller.quantity}',
            style: const TextStyle(
                fontSize: textSizeNormal, fontWeight: FontWeight.bold),
          ),
        ),
        10.width,
        GestureDetector(
          onTap: () => controller.increment(),
          child: SvgPicture.asset(
            isDarkMode ? addWhiteIcon : addIcon,
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }

  _buildText(String text) {
    return Text(text,
        style: TextStyle(
            fontSize: textSizeMedium,
            fontFamily: GoogleFonts.ubuntu().fontFamily));
  }

  _buildClassValues(String value) {
    return Row(
      children: [
        Obx(
          () => Radio(
            fillColor: WidgetStateColor.resolveWith(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return appColorPrimary;
                }
                return isDarkMode
                    ? whiteColor.withAlpha(26)
                    : appTextColorPrimary.withAlpha(26);
              },
            ),
            activeColor: appColorPrimary,
            value: value,
            groupValue: controller.selectedClass.value,
            onChanged: (value) {
              controller.selectClass(value!);
            },
          ),
        ),
        Text(
          value,
          style: const TextStyle(
              fontSize: textSizeMedium, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget buildTripTypeSelector(TripType tripType) {
    var isSelected = controller.selectedTrip.value == tripType;
    return MaterialButton(
      padding: const EdgeInsets.all(8),
      onPressed: () {
        controller.setSelectedTrip(tripType);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: isSelected
          ? appColorPrimary
          : isDarkMode
              ? whiteColor.withAlpha(153)
              : whiteColor.withAlpha(204),
      child: Row(
        children: <Widget>[
          if (isSelected)
            const Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
          3.width,
          Text(
            tripTypes[tripType]!,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
