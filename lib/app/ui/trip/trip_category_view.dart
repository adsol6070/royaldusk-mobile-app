import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/constant/app_colors.dart';

import '../../../widgets/app_widget.dart';
import '../../model/category.dart';



class TripCategoryViewScreen extends StatelessWidget {
  final Category category;
  final bool isDarkMode;
  final int selectedIndex;
  final int index;
  final VoidCallback onPressed;

  const TripCategoryViewScreen(
      {super.key,
      required this.category,
      required this.isDarkMode,
      required this.selectedIndex,
      required this.index,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: SizedBox(
            // color: Colors.white,
            width: 70,
            height: 70,
            child: Card(
              // color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: (selectedIndex == index)
                    ? const BorderSide(color: appColorPrimary, width: 1.0)
                    : BorderSide.none,
              ),
              elevation: 1.0,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: commonCacheImageWidget(
                      category.image.toString(), 35.0,
                      width: 35.0,
                      // Adjust the width as needed, // Adjust the height as needed
                      // fit: BoxFit.cover,
                    ),
                  )),
            ),
          ),
        ),
        8.height,
        Text(
          category.name.toString(),
          style: TextStyle(
              fontSize: textSizeSMedium,
              fontWeight: FontWeight.w500,
              color: isDarkMode
                  ? whiteColor.withAlpha(153)
                  : appTextColorPrimary.withAlpha(153)),
        ).center()
      ],
    );
  }
}
