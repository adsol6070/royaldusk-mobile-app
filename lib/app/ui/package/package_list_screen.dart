import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/constant/app_colors.dart';

import '../../../constant/app_images.dart';
import '../../../constant/strings.dart';
import '../../../widgets/app_widget.dart';
import '../../controller/packages_controller.dart';
import '../../model/package.dart';
import '../../enums/package_types.dart';
import '../dashboard/package_view.dart';

class PackageListScreen extends StatefulWidget {
  final PackageType packageType;

  const PackageListScreen({
    Key? key,
    required this.packageType,
  }) : super(key: key);

  @override
  PackageListScreenState createState() => PackageListScreenState();
}

class PackageListScreenState extends State<PackageListScreen> {
  late PackagesController controller;
  late bool isDarkMode;

  String get screenTitle {
    switch (widget.packageType) {
      case PackageType.all:
        return allPackages;
      case PackageType.popular:
        return popularPackages;
      case PackageType.top:
        return topPackages;
    }
  }

  String get controllerTag => widget.packageType.routeTag;

  @override
  void initState() {
    super.initState();
    controller = PackagesController(packageType: widget.packageType);
    isDarkMode = controller.themeController.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PackagesController>(
        init: controller,
        tag: controllerTag,
        builder: (controller) {
          return Scaffold(
            appBar: commonAppBarWidget(context, titleText: screenTitle),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Make the count reactive using Obx
                        Obx(() => Text(
                              "$resultFound(${controller.filteredPackages.length})",
                              style: const TextStyle(
                                  fontSize: textSizeMedium,
                                  fontWeight: FontWeight.w500),
                            )),
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
                      child: Obx(() {
                        // Show loading indicator
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: appColorPrimary,
                            ),
                          );
                        }

                        // Show error message
                        if (controller.errorMessage.value.isNotEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                16.height,
                                Text(
                                  controller.errorMessage.value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                24.height,
                                ElevatedButton.icon(
                                  onPressed: () {
                                    controller.clearError();
                                    controller.refreshPackages();
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Retry'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: appColorPrimary,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // Show packages or no data message
                        if (controller.filteredPackages.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inbox_outlined,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                16.height,
                                const Text(
                                  noDataAvailable,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                24.height,
                                ElevatedButton.icon(
                                  onPressed: () {
                                    controller.refreshPackages();
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Refresh'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: appColorPrimary,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // Show packages list
                        return Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: RefreshIndicator(
                            onRefresh: () async {
                              await controller.refreshPackages();
                            },
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: controller.filteredPackages.length,
                              itemBuilder: (context, index) {
                                Package package =
                                    controller.filteredPackages[index];
                                return PackageView(package);
                              },
                            ),
                          ),
                        );
                      }),
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
  }
}
