import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constant/app_colors.dart';
import '../../model/review.dart';
class CustomReviewRatingViewScreen extends StatelessWidget {
  final List<Review> reviewList;
  final double? ratting;

  const CustomReviewRatingViewScreen(
      {super.key, required this.reviewList, required this.ratting});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < reviewList.length; i++)
          Align(
            widthFactor: 0.7,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              // Child circle avatar
              child: CircleAvatar(
                radius: 14,
                backgroundImage:
                    NetworkImage(reviewList[i].profileUrl.toString()),
              ),
            ),
          ),
        Align(
          widthFactor: 0.7,
          child: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    gradient: const LinearGradient(
                        colors: [orangeGradient1, orangeGradient2]),
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  "$ratting+",
                  style: const TextStyle(
                      color: whiteColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600),
                ),
              ],
              // child:
            ),
          ),
        ),
      ],
    );
  }
}
