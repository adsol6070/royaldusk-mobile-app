import 'package:flutter/material.dart';
import 'package:royaldusk_mobile_app/constant/app_colors.dart';

class CircleContainer extends StatelessWidget {
 final Color? color;

  const CircleContainer({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      // color: darkYellow,
      decoration: BoxDecoration(
          color: color ?? darkYellow,
          borderRadius: BorderRadius.circular(20),)
          // border: Border.all(width: 0, color: color ?? darkYellow)),
    );
  }
}
