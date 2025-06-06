import 'package:flutter/material.dart';

import 'app_widget.dart';

class RoundedImageView extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final double height;
  final double width;

  const RoundedImageView(
      {super.key,
      required this.imageUrl,
      required this.radius,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: commonCacheImageWidget(
        imageUrl,
        height,
        width: width,
        fit: BoxFit.cover,
      ),
    );
  }
}
