import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:royaldusk_mobile_app/constants/app_colors.dart';
import 'package:royaldusk_mobile_app/models/wishlist_item.dart';
import 'package:royaldusk_mobile_app/models/add_to_wishlist_request.dart';
import 'package:royaldusk_mobile_app/models/update_wishlist_item_request.dart';
import 'package:royaldusk_mobile_app/models/wishlist_count.dart';
import 'package:royaldusk_mobile_app/services/auth_service.dart';
import 'package:royaldusk_mobile_app/services/wishlist_service.dart';
import 'package:royaldusk_mobile_app/utils/api_response.dart';

String _formatDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date).inDays;

  if (difference == 0) {
    return 'today';
  } else if (difference == 1) {
    return 'yesterday';
  } else if (difference < 7) {
    return '$difference days ago';
  } else if (difference < 30) {
    return '${(difference / 7).floor()} week${(difference / 7).floor() > 1 ? 's' : ''} ago';
  } else {
    return '${(difference / 30).floor()} month${(difference / 30).floor() > 1 ? 's' : ''} ago';
  }
}

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final WishlistService _wishlistService = WishlistService();

  // State variables
  WishlistItemType? _selectedItemType;
  WishlistPriority? _selectedPriority;
  bool _isGridView = false;
  bool _isLoading = false;
  bool _isInitialLoad = true;

  // Data
  List<WishlistItem> _wishlistItems = [];
  WishlistCount? _wishlistCount;
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMorePages = false;

  // Pagination
  final ScrollController _scrollController = ScrollController();

  final List<String> itemTypeOptions = ['All', 'Package', 'Tour'];
  final List<String> priorityOptions = ['All', 'High', 'Medium', 'Low'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();

    if (AuthService.isSignedIn) {
      _loadInitialData();
    }

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMorePages) {
      _loadMoreItems();
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _isInitialLoad = true;
    });

    try {
      // Load wishlist count
      await _loadWishlistCount();

      // Load wishlist items
      await _loadWishlistItems(reset: true);
    } catch (e) {
      _showErrorSnackBar('Failed to load wishlist data');
    } finally {
      setState(() {
        _isLoading = false;
        _isInitialLoad = false;
      });
    }
  }

  Future<void> _loadWishlistCount() async {
    final response = await _wishlistService.getWishlistCount();
    response.onSuccess((count) {
      setState(() {
        _wishlistCount = count;
      });
    }).onError((message, errorCode) {
      debugPrint('Error loading wishlist count: $message');
    });
  }

  Future<void> _loadWishlistItems({bool reset = false}) async {
    if (reset) {
      _currentPage = 1;
      _wishlistItems.clear();
    }

    setState(() {
      _isLoading = true;
    });

    final response = await _wishlistService.getWishlist(
      itemType: _selectedItemType,
      priority: _selectedPriority,
      page: _currentPage,
      limit: 20,
      sortBy: 'createdAt',
      sortOrder: 'desc',
    );

    response.onSuccess((wishlistResponse) {
      setState(() {
        if (reset) {
          _wishlistItems = wishlistResponse.items;
        } else {
          _wishlistItems.addAll(wishlistResponse.items);
        }
        _totalPages = wishlistResponse.totalPages;
        _hasMorePages = _currentPage < _totalPages;
        _currentPage++;
      });
    }).onError((message, errorCode) {
      _showErrorSnackBar('Failed to load wishlist items: $message');
    });

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadMoreItems() async {
    if (_hasMorePages && !_isLoading) {
      await _loadWishlistItems();
    }
  }

  Future<void> _refreshWishlist() async {
    await _loadInitialData();
  }

  void _onFilterChanged() {
    _loadWishlistItems(reset: true);
  }

  List<WishlistItem> get filteredItems {
    return _wishlistItems; // Filtering is now done server-side
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: _buildAppBar(),
      body: !AuthService.isSignedIn
          ? _buildGuestContent()
          : _isInitialLoad
              ? _buildLoadingContent()
              : _wishlistItems.isEmpty
                  ? _buildEmptyWishlist()
                  : _buildWishlistContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios,
            color: AppColors.darkGray, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        children: [
          const Text(
            'My Wishlist',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
          ),
          if (AuthService.isSignedIn && _wishlistCount != null)
            Text(
              '${_wishlistCount!.total} saved items',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.mediumGray,
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
      centerTitle: true,
      actions: AuthService.isSignedIn && _wishlistItems.isNotEmpty
          ? [
              IconButton(
                icon: Icon(
                  _isGridView ? Icons.view_list : Icons.grid_view,
                  color: AppColors.primaryOrange,
                  size: 24,
                ),
                onPressed: () {
                  setState(() {
                    _isGridView = !_isGridView;
                  });
                },
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.mediumGray),
                onSelected: (value) {
                  if (value == 'clear_all') {
                    _showClearAllDialog();
                  } else if (value == 'share') {
                    _shareWishlist();
                  } else if (value == 'refresh') {
                    _refreshWishlist();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'refresh',
                    child: Row(
                      children: [
                        Icon(Icons.refresh, size: 18),
                        SizedBox(width: 12),
                        Text('Refresh'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(Icons.share_outlined, size: 18),
                        SizedBox(width: 12),
                        Text('Share Wishlist'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'clear_all',
                    child: Row(
                      children: [
                        Icon(Icons.clear_all, size: 18, color: Colors.red),
                        SizedBox(width: 12),
                        Text('Clear All', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ]
          : null,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: const Color(0xFFF1F5F9),
        ),
      ),
    );
  }

  Widget _buildLoadingContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryOrange),
          ),
          SizedBox(height: 16),
          Text(
            'Loading your wishlist...',
            style: TextStyle(
              color: AppColors.mediumGray,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          _buildGuestPrompt(),
          _buildGuestBenefits(),
          _buildFeaturedPackages(),
        ],
      ),
    );
  }

  Widget _buildGuestPrompt() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryOrange.withValues(alpha: 0.2),
                  AppColors.lightOrange
                ],
              ),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.favorite_outline,
              size: 40,
              color: AppColors.primaryOrange,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Sign in to save your favorites',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGray,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Create a wishlist to save packages you love\nand book them later',
            style: TextStyle(
              color: AppColors.mediumGray,
              fontSize: 14,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/profile'),
              icon: const Icon(Icons.person_add, size: 18),
              label: const Text('Sign In'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/packages'),
            child: const Text(
              'Browse Packages',
              style: TextStyle(
                color: AppColors.primaryOrange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestBenefits() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Why create a wishlist?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGray,
              ),
            ),
          ),
          _buildBenefitItem(
            icon: Icons.bookmark_outline,
            title: 'Save for later',
            subtitle: 'Keep track of packages you\'re interested in',
          ),
          _buildBenefitItem(
            icon: Icons.compare_arrows,
            title: 'Compare easily',
            subtitle: 'Compare prices and features side by side',
          ),
          _buildBenefitItem(
            icon: Icons.share_outlined,
            title: 'Share with others',
            subtitle: 'Share your travel plans with family and friends',
          ),
          _buildBenefitItem(
            icon: Icons.notifications_outlined,
            title: 'Get price alerts',
            subtitle: 'Be notified when prices drop on saved packages',
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.lightOrange,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryOrange,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGray,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWishlist() {
    return RefreshIndicator(
      onRefresh: _refreshWishlist,
      color: AppColors.primaryOrange,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.lightOrange,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 48,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Your wishlist is empty',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Start exploring and save packages\nyou\'d like to book later',
                    style: TextStyle(
                      color: AppColors.mediumGray,
                      fontSize: 14,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/packages'),
                      icon: const Icon(Icons.explore, size: 18),
                      label: const Text('Explore Packages'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWishlistContent() {
    return Column(
      children: [
        if (_wishlistItems.length > 1) _buildFilters(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshWishlist,
            color: AppColors.primaryOrange,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _animationController,
                  child: _isGridView ? _buildGridView() : _buildListView(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Item Type Filter
          Row(
            children: [
              const Text(
                'Type: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGray,
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: itemTypeOptions.length,
                    itemBuilder: (context, index) {
                      final option = itemTypeOptions[index];
                      final isSelected =
                          (option == 'All' && _selectedItemType == null) ||
                              (_selectedItemType?.displayName == option);

                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(
                            option,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.mediumGray,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (option == 'All') {
                                _selectedItemType = null;
                              } else {
                                _selectedItemType = WishlistItemType.values
                                    .firstWhere(
                                        (type) => type.displayName == option);
                              }
                            });
                            _onFilterChanged();
                          },
                          backgroundColor: AppColors.lightGray,
                          selectedColor: AppColors.primaryOrange,
                          checkmarkColor: Colors.white,
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primaryOrange
                                : const Color(0xFFE5E7EB),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Priority Filter
          Row(
            children: [
              const Text(
                'Priority: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGray,
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: priorityOptions.length,
                    itemBuilder: (context, index) {
                      final option = priorityOptions[index];
                      final isSelected =
                          (option == 'All' && _selectedPriority == null) ||
                              (_selectedPriority?.displayName == option);

                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(
                            option,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.mediumGray,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (option == 'All') {
                                _selectedPriority = null;
                              } else {
                                _selectedPriority = WishlistPriority.values
                                    .firstWhere((priority) =>
                                        priority.displayName == option);
                              }
                            });
                            _onFilterChanged();
                          },
                          backgroundColor: AppColors.lightGray,
                          selectedColor: _selectedPriority?.color ??
                              AppColors.primaryOrange,
                          checkmarkColor: Colors.white,
                          side: BorderSide(
                            color: isSelected
                                ? (_selectedPriority?.color ??
                                    AppColors.primaryOrange)
                                : const Color(0xFFE5E7EB),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _wishlistItems.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _wishlistItems.length) {
          return _buildLoadingIndicator();
        }
        return _buildWishlistItemCard(_wishlistItems[index]);
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _wishlistItems.length + (_isLoading ? 2 : 0),
      itemBuilder: (context, index) {
        if (index >= _wishlistItems.length) {
          return _buildGridLoadingIndicator();
        }
        return _buildWishlistGridCard(_wishlistItems[index]);
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryOrange),
        ),
      ),
    );
  }

  Widget _buildGridLoadingIndicator() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryOrange),
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildWishlistItemCard(WishlistItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image section
          Stack(
            children: [
              Container(
                width: 120,
                height: 130,
                decoration: BoxDecoration(
                  color: AppColors.lightOrange,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(item.itemImageUrl),
                    fit: BoxFit.cover,
                    onError: (error, stackTrace) {
                      debugPrint('Error loading image: $error');
                    },
                  ),
                ),
              ),
              // Priority indicator
              if (item.priority != WishlistPriority.Low)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: item.priority.color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.priority.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              // Wishlist remove button
              Positioned(
                top: 6,
                right: 6,
                child: GestureDetector(
                  onTap: () => _removeFromWishlist(item),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 16,
                    ),
                  ),
                ),
              ),
              // Price drop indicator
              if (item.hasPriceDrop)
                Positioned(
                  bottom: 6,
                  left: 6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Price Drop!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Content section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.itemName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkGray,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.lightOrange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.itemType.icon,
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 12, color: AppColors.mediumGray),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          item.locationName,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.mediumGray,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.categoryName,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.mediumGray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Added ${_formatDate(item.createdAt)}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.mediumGray,
                    ),
                  ),
                  if (item.notes != null && item.notes!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.notes!,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.mediumGray,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.hasPriceDrop && item.priceWhenAdded != null)
                            Text(
                              '${item.currency} ${item.priceWhenAdded!.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.mediumGray,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Row(
                            children: [
                              Text(
                                '${item.currency} ${item.currentPrice.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryOrange,
                                ),
                              ),
                              if (item.hasPriceDrop) ...[
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '-${item.currency} ${item.savingsAmount.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 8,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => _updatePriority(item),
                            icon: Icon(
                              Icons.flag,
                              color: item.priority.color,
                              size: 16,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 24,
                              minHeight: 24,
                            ),
                          ),
                          const SizedBox(width: 4),
                          ElevatedButton(
                            onPressed: () => _viewItemDetails(item),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryOrange,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              minimumSize: const Size(0, 24),
                            ),
                            child: const Text(
                              'View',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistGridCard(WishlistItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.lightOrange,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(item.itemImageUrl),
                    fit: BoxFit.cover,
                    onError: (error, stackTrace) {
                      debugPrint('Error loading image: $error');
                    },
                  ),
                ),
              ),
              // Priority indicator
              if (item.priority != WishlistPriority.Low)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: item.priority.color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item.priority.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              // Remove button
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => _removeFromWishlist(item),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 16,
                    ),
                  ),
                ),
              ),
              // Price drop indicator
              if (item.hasPriceDrop)
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Price ↓',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Content section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.lightOrange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.itemType.icon,
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                      Text(
                        item.categoryName,
                        style: const TextStyle(
                          color: AppColors.primaryOrange,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.itemName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGray,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 10, color: AppColors.mediumGray),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          item.locationName,
                          style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.mediumGray,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (item.hasPriceDrop &&
                                item.priceWhenAdded != null)
                              Text(
                                '${item.currency} ${item.priceWhenAdded!.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: AppColors.mediumGray,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Row(
                              children: [
                                Text(
                                  '${item.currency} ${item.currentPrice.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryOrange,
                                  ),
                                ),
                                if (item.hasPriceDrop) ...[
                                  const SizedBox(width: 2),
                                  const Icon(
                                    Icons.trending_down,
                                    color: Colors.green,
                                    size: 10,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _viewItemDetails(item),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          minimumSize: const Size(0, 24),
                        ),
                        child: const Text(
                          'View',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Added ${_formatDate(item.createdAt)}',
                    style: const TextStyle(
                      fontSize: 8,
                      color: AppColors.mediumGray,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _removeFromWishlist(WishlistItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove from Wishlist'),
        content: Text('Remove "${item.itemName}" from your wishlist?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              // Show loading
              _showLoadingDialog();

              final response =
                  await _wishlistService.removeFromWishlist(item.id);

              // Hide loading
              Navigator.pop(context);

              response.onSuccess((_) {
                setState(() {
                  _wishlistItems.removeWhere((i) => i.id == item.id);
                  if (_wishlistCount != null) {
                    _wishlistCount = WishlistCount(
                        total: _wishlistCount!.total - 1,
                        packages: item.itemType == WishlistItemType.Package
                            ? _wishlistCount!.packages - 1
                            : _wishlistCount!.packages,
                        tours: item.itemType == WishlistItemType.Tour
                            ? _wishlistCount!.tours - 1
                            : _wishlistCount!.tours,
                        byPriority: WishlistPriorityCount(
                          low: item.priority == WishlistPriority.Low
                              ? _wishlistCount!.byPriority.low - 1
                              : _wishlistCount!.byPriority.low,
                          medium: item.priority == WishlistPriority.Medium
                              ? _wishlistCount!.byPriority.medium - 1
                              : _wishlistCount!.byPriority.medium,
                          high: item.priority == WishlistPriority.High
                              ? _wishlistCount!.byPriority.high - 1
                              : _wishlistCount!.byPriority.high,
                        ));
                  }
                });
                _showSuccessSnackBar('${item.itemName} removed from wishlist');
              }).onError((message, errorCode) {
                _showErrorSnackBar('Failed to remove item: $message');
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _updatePriority(WishlistItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Update Priority'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: WishlistPriority.values.map((priority) {
            return ListTile(
              leading: Icon(
                Icons.flag,
                color: priority.color,
              ),
              title: Text(priority.displayName),
              selected: item.priority == priority,
              onTap: () async {
                Navigator.pop(context);
                await _updateItemPriority(item, priority);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _updateItemPriority(
      WishlistItem item, WishlistPriority newPriority) async {
    _showLoadingDialog();

    final request = UpdateWishlistItemRequest(
      priority: newPriority,
      notes: item.notes,
    );

    final response =
        await _wishlistService.updateWishlistItem(item.id, request);

    Navigator.pop(context); // Hide loading

    response.onSuccess((updatedItem) {
      setState(() {
        final index = _wishlistItems.indexWhere((i) => i.id == item.id);
        if (index != -1) {
          _wishlistItems[index] = updatedItem;
        }
      });
      _showSuccessSnackBar('Priority updated to ${newPriority.displayName}');
    }).onError((message, errorCode) {
      _showErrorSnackBar('Failed to update priority: $message');
    });
  }

  void _viewItemDetails(WishlistItem item) {
    if (item.itemType == WishlistItemType.Package && item.packageId != null) {
      Navigator.pushNamed(context, '/package-details',
          arguments: item.packageId);
    } else if (item.itemType == WishlistItemType.Tour && item.tourId != null) {
      Navigator.pushNamed(context, '/tour-details', arguments: item.tourId);
    }

    // Update last viewed
    _wishlistService.updateLastViewed([item.id]);
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Wishlist'),
        content: const Text(
            'Are you sure you want to remove all items from your wishlist?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              _showLoadingDialog();

              final response = await _wishlistService.clearWishlist();

              Navigator.pop(context); // Hide loading

              response.onSuccess((_) {
                setState(() {
                  _wishlistItems.clear();
                  _wishlistCount = const WishlistCount(
                      total: 0,
                      packages: 0,
                      tours: 0,
                      byPriority:
                          WishlistPriorityCount(low: 0, medium: 0, high: 0));
                });
                _showSuccessSnackBar('Wishlist cleared');
              }).onError((message, errorCode) {
                _showErrorSnackBar('Failed to clear wishlist: $message');
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _shareWishlist() {
    // Implement share functionality
    _showSuccessSnackBar('Share functionality would be implemented here');
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.primaryOrange),
            ),
            SizedBox(width: 16),
            Text('Please wait...'),
          ],
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primaryOrange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildFeaturedPackages() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Popular Packages',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGray,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/packages'),
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: AppColors.primaryOrange,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 3,
              itemBuilder: (context, index) {
                return _buildFeaturedPackageCard(index);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFeaturedPackageCard(int index) {
    final packages = [
      {
        'name': 'Goa Beach Paradise',
        'location': 'Goa',
        'price': '12,999',
        'image': 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2',
      },
      {
        'name': 'Shimla Hill Station',
        'location': 'Shimla, HP',
        'price': '9,999',
        'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
      },
      {
        'name': 'Dubai Desert Safari',
        'location': 'Dubai, UAE',
        'price': '35,999',
        'image': 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c',
      },
    ];

    final package = packages[index];

    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.lightOrange,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              image: DecorationImage(
                image: NetworkImage(package['image'] as String),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package['name'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGray,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 10, color: AppColors.mediumGray),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          package['location'] as String,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.mediumGray,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    'AED ${package['price']}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper widget for wishlist button in other screens
class WishlistButton extends StatefulWidget {
  final WishlistItemType itemType;
  final String itemId;
  final VoidCallback? onToggle;

  const WishlistButton({
    super.key,
    required this.itemType,
    required this.itemId,
    this.onToggle,
  });

  @override
  State<WishlistButton> createState() => _WishlistButtonState();
}

class _WishlistButtonState extends State<WishlistButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final WishlistService _wishlistService = WishlistService();
  bool _isInWishlist = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _checkWishlistStatus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkWishlistStatus() async {
    if (!AuthService.isSignedIn) return;

    final response = await _wishlistService.checkItemInWishlist(
      widget.itemType,
      widget.itemId,
    );

    response.onSuccess((checkResponse) {
      setState(() {
        _isInWishlist = checkResponse.inWishlist;
      });
    });
  }

  Future<void> _toggleWishlist() async {
    if (!AuthService.isSignedIn) {
      Navigator.pushNamed(context, '/profile');
      return;
    }

    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    try {
      if (_isInWishlist) {
        // Find and remove the item
        final wishlistResponse = await _wishlistService.getWishlist(
          itemType: widget.itemType,
          limit: 1000, // Get all items to find the one to remove
        );

        await wishlistResponse.fold(
          (response) async {
            final item = response.items.firstWhere(
              (item) =>
                  (widget.itemType == WishlistItemType.Package &&
                      item.packageId == widget.itemId) ||
                  (widget.itemType == WishlistItemType.Tour &&
                      item.tourId == widget.itemId),
            );

            final removeResponse =
                await _wishlistService.removeFromWishlist(item.id);
            return removeResponse.fold(
              (_) {
                setState(() {
                  _isInWishlist = false;
                });
                _showSnackBar('Removed from wishlist', Colors.red);
                return null;
              },
              (message, errorCode, statusCode) {
                _showSnackBar('Failed to remove: $message', Colors.red);
                return null;
              },
            );
          },
          (message, errorCode, statusCode) {
            _showSnackBar('Failed to find item: $message', Colors.red);
            return null;
          },
        );
      } else {
        // Add to wishlist
        final request = AddToWishlistRequest(
          itemType: widget.itemType,
          packageId: widget.itemType == WishlistItemType.Package
              ? widget.itemId
              : null,
          tourId:
              widget.itemType == WishlistItemType.Tour ? widget.itemId : null,
          priority: WishlistPriority.Medium,
          notes: null,
        );

        final response = await _wishlistService.addToWishlist(request);

        response.onSuccess((item) {
          setState(() {
            _isInWishlist = true;
          });
          _showSnackBar('Added to wishlist', AppColors.primaryOrange);
        }).onError((message, errorCode) {
          _showSnackBar('Failed to add: $message', Colors.red);
        });
      }
    } catch (e) {
      _showSnackBar('An error occurred', Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });

      if (widget.onToggle != null) {
        widget.onToggle!();
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: _toggleWishlist,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryOrange),
                      ),
                    )
                  : Icon(
                      _isInWishlist ? Icons.favorite : Icons.favorite_border,
                      color: _isInWishlist ? Colors.red : Colors.grey,
                      size: 20,
                    ),
            ),
          ),
        );
      },
    );
  }
}
