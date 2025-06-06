import 'package:royaldusk_mobile_app/app/ui/search/search_result_view.dart';
import 'package:royaldusk_mobile_app/app/ui/search/sort_filter_bottom_sheet.dart';
import 'package:royaldusk_mobile_app/app/ui/search/suggetsion_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/app_images.dart';
import '../../../constant/strings.dart';
import '../../../widgets/decorated_input_border.dart';
import '../../controller/search_controller.dart';
import '../../model/search.dart';



class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key});

  @override
  SearchResultScreenState createState() => SearchResultScreenState();
}

class SearchResultScreenState extends State<SearchResultScreen> {
  late SearchResultController controller;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SearchResultController());
    isDarkMode = controller.themeController.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchResultController>(
        init: controller,
        tag: 'travel_my_search',
        // theme: theme,
        builder: (controller) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: commonAppBarWidget(context, titleText: search),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(),
                    10.height,
                    Expanded(
                      child: Obx(
                        () => controller.filteredSuggestions.isEmpty
                            ? controller.isSuggestionClick
                                ? _buildResultList()
                                : _buildNotFoundImage()
                            : ListView.builder(
                                itemCount: controller.filteredSuggestions.length,
                                itemBuilder: (context, index) {
                                  return SuggestionViewScreen(
                                    isDarkMode: isDarkMode,
                                    text: controller
                                        .filteredSuggestions[index].name
                                        .toString(),
                                    onPressed: () {
                                      controller.searchController.text =
                                          controller
                                              .filteredSuggestions[index].name
                                              .toString();
                                      controller.isSuggestionClick = true;
                                      FocusScope.of(context).unfocus();
                                      controller.clearSuggestions();
                                      controller.getSearchResult(controller
                                          .searchController.text
                                          .toString());
                                    },
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _buildResultList() {
    return Obx(
      () => ListView.builder(
        // physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.resultSuggestions.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          Search search = controller.resultSuggestions[index];
          return SearchResultView(
            search,
            isBooked: false,
          );
        },
      ),
    );
  }

  _buildNotFoundImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          notFoundImage,
          width: 150,
          height: 150,
        ),
        20.height,
        const Text(
          notFound,
          style:
              TextStyle(fontSize: textSizeLarge, fontWeight: FontWeight.bold),
        ),
        10.height,
        Text(
          resultNotFound,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: textSizeMedium,
              fontWeight: FontWeight.w400,
              color: isDarkMode
                  ? whiteColor.withAlpha(153)
                  : appTextColorPrimary.withAlpha(153)),
        ),
      ],
    );
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
        Expanded(
          child: SizedBox(
              height: 60.0,
              child: TextField(
                onSubmitted: (value) {
                  FocusScope.of(context).unfocus();
                  controller.getSearchResult(value);
                },
                textInputAction: TextInputAction.search,
                onChanged: controller.onSearchTextChanged,
                controller: controller.searchController,
                decoration: InputDecoration(
                    hintText: searchPackages,
                    fillColor:
                        isDarkMode ? cardBackgroundBlackDark : Colors.white,
                    border: style,
                    enabledBorder: style,
                    focusedBorder: style,
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
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
                    )),
              )),
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
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            gradient: const LinearGradient(
                colors: [yellowGradient1, yellowGradient2],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.0, 0.3],
                tileMode: TileMode.clamp),
            borderRadius: BorderRadius.circular(20),
          ),
          child: MaterialButton(
            onPressed: () {
              FocusScope.of(context).unfocus();

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
                      child: SearchSortFilterBottomSheet(
                        isDarkMode: isDarkMode,
                      ));
                  // return _buildBottomSheetContent(isDarkMode);
                },
              );
            },
            child: SvgPicture.asset(filterIcon),
          ),
        ),
      ],
    );
  }
}
