import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';
import '../../../constant/app_colors.dart';
import '../../../constant/app_images.dart';
import '../../model/popular_packages.dart';
import '../popular_package/popular_package_detail_screen.dart';

class PopularCategoryView extends StatefulWidget {
  final PopularPackage popularPackage;

  const PopularCategoryView(this.popularPackage, {super.key});

  @override
  PopularCategoryViewScreenState createState() =>
      PopularCategoryViewScreenState();
}

class PopularCategoryViewScreenState extends State<PopularCategoryView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          PopularPackageDetailScreen(
            popularPackage: widget.popularPackage,
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
              child: commonCacheImageWidget(
                widget.popularPackage.imageUrl,
                200,
              ),
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
            if (widget.popularPackage.review > 0)
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
                            "${(widget.popularPackage.review / 1000).toStringAsFixed(1)}k"),
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
                          widget.popularPackage.name,
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
                          widget.popularPackage.description,
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
