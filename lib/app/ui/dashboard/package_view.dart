import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:royaldusk_mobile_app/app/model/package.dart';
import 'package:royaldusk_mobile_app/app/ui/package/package_detail_screen.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/app_images.dart';
import '../../controller/my_saved_list_controller.dart';

class PackageView extends StatefulWidget {
  final Package package;

  const PackageView(this.package, {super.key});

  @override
  PackageViewScreenState createState() => PackageViewScreenState();
}

class PackageViewScreenState extends State<PackageView> {
  late MySavedController savedController;

  @override
  void initState() {
    super.initState();
    savedController = Get.put(MySavedController());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          PackageDetailScreen(
            package: widget.package,
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
                widget.package.imageUrl,
                200,
                width: double.infinity,
                fit: BoxFit.cover,
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

            // Rating badge (if exists)
            if (widget.package.review > 0)
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
                            "${(widget.package.review / 1000).toStringAsFixed(1)}k"),
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
                          widget.package.name,
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
                          widget.package.description,
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
                      savedController.togglePackageSave(widget.package);
                    },
                    child: GetBuilder<MySavedController>(
                      builder: (controller) => Obx(() {
                        bool isSaved =
                            controller.isPackageSaved(widget.package.id);
                        return Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: isSaved
                              ? Get.theme.primaryColor
                              : Colors.white.withOpacity(0.8),
                          size: 28,
                        );
                      }),
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
