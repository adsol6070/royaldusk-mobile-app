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
          // Adjust the radius as needed
          image: const DecorationImage(
            image: AssetImage(cardBg), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        width: double.infinity,
        height: 200,
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: commonCacheImageWidget(
                      widget.popularPackage.image.toString(), 200),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: const DecorationImage(
                      image: AssetImage(transparentBgImage), fit: BoxFit.fill),
                ),
                width: double.infinity,
              ),
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
                    child: Row(children: [
                      SvgPicture.asset(
                        starIcon,
                        height: 15,
                        width: 15,
                      ),
                      5.width,
                      Text(
                        widget.popularPackage.rating.toString(),
                      )
                    ]),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 20,
                right: 15,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.popularPackage.name.toString(),
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: textSizeLargeMedium),
                          ),
                          Text(
                            widget.popularPackage.details.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: textSizeSMedium),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
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
      ),
    );
  }
}
