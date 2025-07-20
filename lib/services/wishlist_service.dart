// services/wishlist_service.dart - Updated to use the new base classes
import 'package:royaldusk_mobile_app/models/wishlist_item.dart';
import 'package:royaldusk_mobile_app/models/add_to_wishlist_request.dart';
import 'package:royaldusk_mobile_app/models/update_wishlist_item_request.dart';
import 'package:royaldusk_mobile_app/models/wishlist_check_response.dart';
import 'package:royaldusk_mobile_app/models/wishlist_count.dart';
import 'package:royaldusk_mobile_app/models/wishlist_response.dart';
import 'package:royaldusk_mobile_app/services/api_service.dart';
import 'package:royaldusk_mobile_app/utils/api_response.dart';

class WishlistService extends ApiService {
  static const String _baseEndpoint = '/wishlist-service/api/wishlist';

  // Add item to wishlist
  Future<ApiResponse<WishlistItem>> addToWishlist(
    AddToWishlistRequest request,
  ) async {
    final response = await post(
      _baseEndpoint,
      body: request.toJson(),
    );

    return response.map((data) => WishlistItem.fromJson(data['wishlistItem']));
  }

  // Get user's wishlist
  Future<ApiResponse<WishlistResponse>> getWishlist({
    WishlistItemType? itemType,
    WishlistPriority? priority,
    int page = 1,
    int limit = 20,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
      'sortBy': sortBy,
      'sortOrder': sortOrder,
    };

    if (itemType != null) {
      queryParams['itemType'] = itemType.name;
    }

    if (priority != null) {
      queryParams['priority'] = priority.name;
    }

    final response = await get(
      _baseEndpoint,
      queryParams: queryParams,
    );

    return response.map((data) => WishlistResponse.fromJson(data));
  }

  // Get wishlist count
  Future<ApiResponse<WishlistCount>> getWishlistCount() async {
    final response = await get('$_baseEndpoint/count');
    return response.map((data) => WishlistCount.fromJson(data['counts']));
  }

  // Get wishlist items by priority
  Future<ApiResponse<List<WishlistItem>>> getWishlistByPriority(
    WishlistPriority priority,
  ) async {
    final response = await get('$_baseEndpoint/priority/${priority.name}');

    return response.map((data) => (data['items'] as List)
        .map((item) => WishlistItem.fromJson(item))
        .toList());
  }

  // Update wishlist item
  Future<ApiResponse<WishlistItem>> updateWishlistItem(
    String itemId,
    UpdateWishlistItemRequest request,
  ) async {
    final response = await patch(
      '$_baseEndpoint/item/$itemId',
      body: request.toJson(),
    );

    return response.map((data) => WishlistItem.fromJson(data['wishlistItem']));
  }

  // Remove item from wishlist
  Future<ApiResponse<void>> removeFromWishlist(String itemId) async {
    final response = await delete('$_baseEndpoint/item/$itemId');
    return response.map((_) => null);
  }

  // Clear entire wishlist
  Future<ApiResponse<void>> clearWishlist() async {
    final response = await delete(_baseEndpoint);
    return response.map((_) => null);
  }

  // Get specific wishlist item
  Future<ApiResponse<WishlistItem>> getWishlistItem(String itemId) async {
    final response = await get('$_baseEndpoint/item/$itemId');
    return response.map((data) => WishlistItem.fromJson(data['wishlistItem']));
  }

  // Check if item exists in wishlist
  Future<ApiResponse<WishlistCheckResponse>> checkItemInWishlist(
    WishlistItemType itemType,
    String itemId,
  ) async {
    final response = await get(
      '$_baseEndpoint/check/${itemType.name}/$itemId',
    );

    return response.map((data) => WishlistCheckResponse.fromJson(data));
  }

  // Bulk remove items
  Future<ApiResponse<void>> bulkRemoveItems(List<String> itemIds) async {
    final response = await post(
      '$_baseEndpoint/bulk/remove',
      body: {'itemIds': itemIds},
    );

    return response.map((_) => null);
  }

  // Bulk update priority
  Future<ApiResponse<void>> bulkUpdatePriority(
    List<String> itemIds,
    WishlistPriority priority,
  ) async {
    final response = await patch(
      '$_baseEndpoint/bulk/priority',
      body: {
        'itemIds': itemIds,
        'priority': priority.name,
      },
    );

    return response.map((_) => null);
  }

  // Update last viewed timestamp
  Future<ApiResponse<void>> updateLastViewed(List<String> itemIds) async {
    final response = await patch(
      '$_baseEndpoint/last-viewed',
      body: {'itemIds': itemIds},
    );

    return response.map((_) => null);
  }

  // Get wishlist analytics
  Future<ApiResponse<Map<String, dynamic>>> getWishlistAnalytics() async {
    final response = await get('$_baseEndpoint/analytics');
    return response.map((data) => data['analytics']);
  }
}

// Example usage in a widget or controller
class WishlistController {
  final WishlistService _wishlistService = WishlistService();

  Future<void> loadWishlist() async {
    final response = await _wishlistService.getWishlist();

    response.onSuccess((wishlistResponse) {
      // Handle successful response
      print('Loaded ${wishlistResponse.items.length} items');
    }).onError((message, errorCode) {
      // Handle error
      print('Error loading wishlist: $message');
    });
  }

  Future<void> addItemToWishlist(AddToWishlistRequest request) async {
    final response = await _wishlistService.addToWishlist(request);

    final result = response.fold(
      (wishlistItem) => 'Item added successfully: ${wishlistItem.id}',
      (message, errorCode, statusCode) => 'Failed to add item: $message',
    );

    print(result);
  }

  // Using dataOrThrow for cases where you want to handle errors at a higher level
  Future<List<WishlistItem>> getHighPriorityItems() async {
    try {
      final response = await _wishlistService.getWishlistByPriority(
        WishlistPriority.High,
      );
      return response.dataOrThrow;
    } on ApiException catch (e) {
      // Handle API exception
      print('API Error: ${e.message}');
      rethrow;
    }
  }
}
