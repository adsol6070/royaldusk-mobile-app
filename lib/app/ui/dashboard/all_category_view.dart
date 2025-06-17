import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/app_images.dart';
import '../../model/all_packages.dart';
import '../all_packages/all_package_detail_screen.dart';

class AllCategoryView extends StatefulWidget {
  final AllPackage allPackage;

  const AllCategoryView(this.allPackage, {super.key});

  @override
  AllCategoryViewScreenState createState() =>
      AllCategoryViewScreenState();
}

class AllCategoryViewScreenState extends State<AllCategoryView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          AllPackageDetailScreen(
            allPackage: widget.allPackage,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(width: 5, color: grey1.withAlpha(51)),
          image: const DecorationImage(
            image: AssetImage(cardBg),
            fit: BoxFit.cover,
          ),
        ),
        width: double.infinity,
        height: 200,
        child: Stack(
          children: [
            // Background image
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: commonCacheImageWidget(widget.allPackage.imageUrl, 200,
                  width: double.infinity, fit: BoxFit.cover),
            ),

            // Transparent overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: const DecorationImage(
                  image: AssetImage(transparentBgImage),
                  fit: BoxFit.fill,
                ),
              ),
              width: double.infinity,
            ),

            // Rating Badge (optional if rating exists)
            if (widget.allPackage.review > 0)
              Positioned(
                top: 10,
                left: 10,
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          starIcon,
                          height: 15,
                          width: 15,
                        ),
                        5.width,
                        Text(
                            "${(widget.allPackage.review / 1000).toStringAsFixed(1)}k"),
                      ],
                    ),
                  ),
                ),
              ),

            // Title + Description + Bookmark
            Positioned(
              bottom: 10,
              left: 20,
              right: 15,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.allPackage.name,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: textSizeLargeMedium,
                          ),
                        ),
                        Text(
                          widget.allPackage.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: textSizeSMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Bookmark logic (optional)
                    },
                    child: SvgPicture.asset(
                      bookmarkIcon,
                      height: 32,
                      width: 32,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
