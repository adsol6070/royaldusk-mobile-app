import 'package:royaldusk_mobile_app/models/wish_list_item.dart';
import 'package:royaldusk_mobile_app/services/auth_service.dart';

// Simple Wishlist Service
class WishlistService {
  static final List<WishlistItem> _wishlistItems = [
    WishlistItem(
      id: '1',
      packageId: 'p1',
      name: 'Manali Adventure Tour',
      location: 'Manali, Himachal Pradesh',
      duration: '5 Days',
      price: 15999,
      originalPrice: 19999,
      rating: 4.5,
      reviewCount: 128,
      imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
      category: 'Adventure',
      addedDate: DateTime.now().subtract(const Duration(days: 3)),
    ),
    WishlistItem(
      id: '2',
      packageId: 'p2',
      name: 'Kerala Backwaters',
      location: 'Kerala',
      duration: '6 Days',
      price: 18999,
      originalPrice: 22999,
      rating: 4.6,
      reviewCount: 156,
      imageUrl: 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944',
      category: 'Cultural',
      addedDate: DateTime.now().subtract(const Duration(days: 7)),
    ),
    WishlistItem(
      id: '3',
      packageId: 'p3',
      name: 'Rajasthan Royal Heritage',
      location: 'Rajasthan',
      duration: '7 Days',
      price: 24999,
      originalPrice: 29999,
      rating: 4.7,
      reviewCount: 203,
      imageUrl: 'https://images.unsplash.com/photo-1477587458883-47145ed94245',
      category: 'Cultural',
      addedDate: DateTime.now().subtract(const Duration(days: 14)),
      isAvailable: false,
    ),
  ];

  static List<WishlistItem> get items =>
      AuthService.isSignedIn ? _wishlistItems : [];
  static int get itemCount => items.length;

  static void addItem(WishlistItem item) {
    if (!_wishlistItems
        .any((existing) => existing.packageId == item.packageId)) {
      _wishlistItems.insert(0, item);
    }
  }

  static void removeItem(String itemId) {
    _wishlistItems.removeWhere((item) => item.id == itemId);
  }

  static bool isInWishlist(String packageId) {
    return _wishlistItems.any((item) => item.packageId == packageId);
  }

  static void clearAll() {
    _wishlistItems.clear();
  }
}
