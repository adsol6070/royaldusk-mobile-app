import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:royaldusk_mobile_app/app/ui/dashboard/popular_category_view.dart';
import 'package:royaldusk_mobile_app/app/ui/dashboard/top_package_screen.dart';
import 'package:royaldusk_mobile_app/widgets/custom_see_more_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/app_images.dart';
import '../../../constant/strings.dart';
import '../../../widgets/app_widget.dart';
import '../../../widgets/decorated_input_border.dart';
import '../../controller/home_controller.dart';
import '../../model/category.dart';
import '../../model/popular_packages.dart';
import '../my_app_bar.dart';
import '../popular_package/popular_package_detail_screen.dart';
import 'all_packages_view.dart';
import 'category_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late HomeController controller;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    controller = Get.put(HomeController());
    isDarkMode = controller.themeController.isDarkMode;
    controller.filteredPackages.assignAll(controller.allPackages);
    controller.filteredPopularPackages.assignAll(controller.allPopularPackages);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: controller,
        tag: 'travel_home',
        builder: (controller) {
          return Scaffold(
            appBar: MyAppBar(isDarkMode: isDarkMode),
            resizeToAvoidBottomInset: true,
            backgroundColor: isDarkMode ? appDarkBgColor : appLightBgColor,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.height,
                    const Text(
                      exploreThe,
                      style: TextStyle(
                          fontSize: textSizeLarge1,
                          fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        const Text(
                          beautifulWorld,
                          style: TextStyle(
                              fontSize: textSizeLarge1,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.3),
                        ),
                        10.width,
                        Image.asset(
                          planeIcon,
                          height: 25,
                          width: 25,
                        ),
                      ],
                    ),
                    20.height,
                    _buildSearchBar(),
                    20.height,
                    _buildCategoryList(),
                    20.height,
                    CustomTextSeeMore(
                      title: "${controller.filteredPackages.length} Packages",
                      onPressed: () {},
                    ),
                    10.height,
                    _buildPackagesList(),
                    20.height,
                    CustomTextSeeMore(
                        title: popularPackages,
                        onPressed: () {
                          controller.goToPopularPackageScreen();
                        }),
                    10.height,
                    _buildPopularView(),
                    20.height,
                    CustomTextSeeMore(title: topPackages, onPressed: () {}),
                    10.height,
                    _buildTopPackagesList(),
                    10.height,
                  ],
                ),
              ),
            ),
          );
        });
  }

  _buildSearchBar() {
    var style = DecoratedInputBorder(
      child: OutlineInputBorder(
        borderSide: BorderSide(
            color: isDarkMode ? cardBackgroundBlackDark : Colors.white),
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      shadow: BoxShadow(
        color: Colors.black.withAlpha(26),
        blurRadius: 5,
      ),
    );
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 60.0,
          child: TextField(
            controller: controller.searchController,
            onChanged: controller.filterPackages,
            decoration: InputDecoration(
              hintText: searchPackages,
              fillColor: isDarkMode ? cardBackgroundBlackDark : Colors.white,
              border: style,
              enabledBorder: style,
              focusedBorder: style,
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 20, minHeight: 20),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: SvgPicture.asset(
                  searchIcon,
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                      isDarkMode ? whiteColor : appTextColorPrimary,
                      BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ),
        10.width,
        Container(
          height: 60.0,
          width: 60.0,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: yellowGradient1.withAlpha(51),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
            gradient: const LinearGradient(
              colors: [yellowGradient1, yellowGradient2],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.0, 0.3],
              tileMode: TileMode.clamp,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: MaterialButton(
            onPressed: controller.goToSearchScreen,
            child: SvgPicture.asset(filterIcon),
          ),
        ),
      ],
    );
  }

  _buildCategoryList() {
    return Obx(() => Container(
          padding: const EdgeInsets.only(right: 10),
          height: 110,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.allCategories.length,
            itemBuilder: (ctx, i) {
              Category cat = controller.allCategories[i];
              return CategoryViewScreenState(
                category: cat,
                isDarkMode: isDarkMode,
                onPressed: () {
                  if (i == 0) controller.goToPopularPackageScreen();
                },
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              mainAxisExtent: 100,
            ),
          ),
        ));
  }

  // updated _buildPackagesList method with no-result UI
  _buildPackagesList() {
    return SizedBox(
      child: Obx(() {
        if (controller.filteredPackages.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Text(
                'No travel packages found matching your search. Try something else! ✈️',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
            ),
          );
        } else {
          return HorizontalList(
            padding: EdgeInsets.zero,
            itemCount: controller.filteredPackages.length,
            itemBuilder: (ctx, i) {
              PopularPackage package = controller.filteredPackages[i];
              return InkWell(
                onTap: () => Get.to(
                  PopularPackageDetailScreen(popularPackage: package),
                ),
                child: AllPackagesViewScreenState(
                  package: package,
                  isDarkMode: isDarkMode,
                ),
              );
            },
          );
        }
      }),
    );
  }

  _buildTopPackagesList() {
    return FutureBuilder<List<PopularPackage>>(
      future: controller.getAllTopPackages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: appColorPrimary);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Obx(() => controller.topPackages.isEmpty
              ? const Text(noDataAvailable)
              : Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.topPackages.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      PopularPackage pkg = controller.topPackages[index];
                      return InkWell(
                        child: TopPackagesScreen(pkg, isDarkMode),
                        onTap: () => Get.to(
                          PopularPackageDetailScreen(popularPackage: pkg),
                        ),
                      );
                    },
                  ),
                ));
        }
      },
    );
  }

  _buildPopularView() {
    int len = controller.filteredPopularPackages.length;
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Column(
        children: [
          CarouselSlider.builder(
            itemCount: len,
            itemBuilder: (context, index, realIndex) {
              if (controller.filteredPopularPackages.isNotEmpty) {
                return PopularCategoryView(
                  controller.filteredPopularPackages[index],
                );
              } else {
                return Container();
              }
            },
            options: CarouselOptions(
              viewportFraction: 1,
              height: 200,
              initialPage: 1,
              autoPlay: true,
              onPageChanged: (index, reason) {
                setState(() {
                  controller.popularPkgCurrentIndex = index;
                });
              },
            ),
          ),
          5.height,
          if (len > 0)
            DotsIndicator(
              dotsCount: len,
              position: controller.popularPkgCurrentIndex.toDouble(),
              decorator: DotsDecorator(
                activeColor: dotActiveColor,
                color: dotInactiveColor,
                size: const Size.square(4.0),
                activeSize: const Size(20.0, 4.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
