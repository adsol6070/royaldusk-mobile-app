import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:royaldusk_mobile_app/constant/app_colors.dart';

import '../../../widgets/app_widget.dart';
import '../../model/facility.dart';



class FacilityCardScreen extends StatefulWidget {
  final Facility facility;
  final bool isDarkMode;

  const FacilityCardScreen(
      {super.key,
      required this.facility,
      required this.isDarkMode});

  @override
  FacilityCardScreenState createState() => FacilityCardScreenState();
}

class FacilityCardScreenState extends State<FacilityCardScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: (){},
          child: Container(
            decoration: BoxDecoration(
              color: widget.isDarkMode
                  ? Colors.white.withAlpha(77)
                  : appTextColorPrimary.withAlpha(77),
              borderRadius: BorderRadius.circular(12)
            ),
          
            // color: Colors.white,
            width: 100,
            height: 90,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      commonCacheImageWidget(
                        widget.facility.icon.toString(), 28.0,
                        width: 28.0,
                        color: widget.isDarkMode
                            ? Colors.white.withAlpha(128)
                            : appTextColorPrimary.withAlpha(128),

                        // Adjust the width as needed, // Adjust the height as needed
                        fit: BoxFit.contain,
                      ),
                      5.height,
                      Text(
                        widget.facility.name.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: textSizeSMedium,
                            fontWeight: FontWeight.w500,
                            color: widget.isDarkMode
                                ? whiteColor.withAlpha(153)
                                : appTextColorPrimary.withAlpha(153)),
                      ).center()
                    ],
                  ),
                )),
          ),
        ),
      ],
    );
  }
}
