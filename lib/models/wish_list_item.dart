class WishlistItem {
  final String id;
  final String packageId;
  final String name;
  final String location;
  final String duration;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String category;
  final DateTime addedDate;
  final bool isAvailable;

  WishlistItem({
    required this.id,
    required this.packageId,
    required this.name,
    required this.location,
    required this.duration,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.category,
    required this.addedDate,
    this.isAvailable = true,
  });
}
