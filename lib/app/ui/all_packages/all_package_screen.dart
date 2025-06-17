import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/constant/app_colors.dart';

import '../../../constant/app_images.dart';
import '../../../constant/strings.dart';
import '../../../widgets/app_widget.dart';
import '../../controller/all_packages_controller.dart';
import '../../model/all_packages.dart';

// import '../dashboard/popular_category_view.dart';
import '../dashboard/all_category_view.dart';

class AllPackageScreen extends StatefulWidget {
  const AllPackageScreen({Key? key}) : super(key: key);

  @override
  AllPackageScreenState createState() => AllPackageScreenState();
}

class AllPackageScreenState extends State<AllPackageScreen> {
  late AllPackagesController controller;
  int get totalRecords => controller.myAllPackagesData.length;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    controller = AllPackagesController();
    isDarkMode = controller.themeController.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllPackagesController>(
        init: controller,
        tag: 'travel_all_packages',
        // theme: theme,
        builder: (controller) {
          return Scaffold(
            appBar: commonAppBarWidget(context, titleText: allPackages),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$resultFound($totalRecords)",
                          style: const TextStyle(
                              fontSize: textSizeMedium,
                              fontWeight: FontWeight
                                  .w500), // Adjust the font size as needed
                        ),
                        3.width,
                        IconButton(
                          onPressed: () {
                            showPopupMenu(context);
                          },
                          icon: SvgPicture.asset(
                            filterArrowIcon,
                            width: 20,
                            height: 20,
                          ),
                        )
                      ],
                    ),
                    // 5.height,
                    Expanded(
                      child: Center(
                          child: FutureBuilder<List<AllPackage>>(
                        future: controller.fetchData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                              color: appColorPrimary,
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Obx(
                              () => controller.myAllPackagesData.isEmpty
                                  ? const Text(noDataAvailable)
                                  : Padding(
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
                                      child: ListView.builder(
                                        // physics: const NeverScrollableScrollPhysics(),
                                        itemCount: controller.myAllPackagesData.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          AllPackage? allPackage =
                                              controller.myAllPackagesData[index];
                                          return AllCategoryView(
                                              allPackage);
                                        },
                                      ),
                                    ),
                            );
                          }
                        },
                      )),
                    ),
                    10.height,
                  ],
                ),
              ),
            ),
          );
        });
  }

  void showPopupMenu(BuildContext context) async {
    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(200, 140, 10, 100),
      items: [
        PopupMenuItem(
          value: '1',
          child: Obx(() => RadioListTile(
                activeColor: appColorPrimary,
                title: const Text(highPrice),
                value: '1',
                groupValue: controller.selectedOption.value,
                onChanged: (value) {
                  controller.setSelectedOption(value!);
                  Get.back();
                },
              )),
        ),
        PopupMenuItem(
          value: '2',
          child: Obx(() => RadioListTile(
                activeColor: appColorPrimary,
                title: const Text(lowPrice),
                value: '2',
                groupValue: controller.selectedOption.value,
                onChanged: (value) {
                  controller.setSelectedOption(value!);
                  Get.back();
                },
              )),
        ),
        PopupMenuItem(
          value: '3',
          child: Obx(() => RadioListTile(
                activeColor: appColorPrimary,
                title: const Text(trendingNow),
                value: '3',
                groupValue: controller.selectedOption.value,
                onChanged: (value) {
                  controller.setSelectedOption(value!);
                  Get.back();
                },
              )),
        ),
      ],
      elevation: 8.0,
    );

    // print('Selected option: ${controller.selectedOption.value}');
  }
}
