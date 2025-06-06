import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:royaldusk_mobile_app/constant/app_colors.dart';
import 'package:royaldusk_mobile_app/widgets/app_widget.dart';

import '../../../constant/app_images.dart';


class UserProfilePicture extends StatelessWidget {
  const UserProfilePicture({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ClipOval(
            child: commonCacheImageWidget(
              'https://i.ibb.co/JkbSSVZ/main-thumb-2130102404-200-ynberwrkslqbjankshjkcjagxxmtytsa.jpg',
              100.0, // Replace with your image URL
              width: 100.0,
              fit: BoxFit.cover,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 2, color: Colors.white),
                  gradient: const LinearGradient(
                      colors: [yellowGradient1, yellowGradient2])),
              child: SvgPicture.asset(
                editIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
