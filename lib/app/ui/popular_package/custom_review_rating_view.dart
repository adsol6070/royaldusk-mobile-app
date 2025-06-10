import 'package:flutter/material.dart';
import '../../../constant/app_colors.dart';

class CustomReviewRatingViewScreen extends StatelessWidget {
  final int reviewCount; // 4200 from your JSON
  final double rating; // e.g. 4.8 or 4.5

  const CustomReviewRatingViewScreen({
    super.key,
    required this.reviewCount,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Optional static profile icon/avatar
        const CircleAvatar(
          radius: 16,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 14,
            backgroundImage: NetworkImage(
              'https://i.ibb.co/3zV4TCb/istockphoto-1208302982-612x612.jpg', // fallback or package imageUrl
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Rating + review count
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [orangeGradient1, orangeGradient2],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.star, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text(
                "$rating ($reviewCount+)",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
