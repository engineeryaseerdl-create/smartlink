import 'package:flutter/material.dart';
import '../../providers/product_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/widget_exports.dart';
import '../../models/product_model.dart';
import 'package:provider/provider.dart';

/// Enhanced buyer home screen showcasing the new UX features
class EnhancedBuyerHomeScreen extends StatefulWidget {
  const EnhancedBuyerHomeScreen({super.key});

  @override
  State<EnhancedBuyerHomeScreen> createState() => _EnhancedBuyerHomeScreenState();
}

class _EnhancedBuyerHomeScreenState extends State<EnhancedBuyerHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isConnected = true;
  String _selectedSort = 'newest';

  final List<String> _categories = [
    'All',
    'Electronics',
    'Fashion',
    'Home & Garden',
    'Sports',
    'Books',
    'Beauty',
    'Automotive',
  ];

  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _checkConnectivity();
  }

  void _loadProducts() async {
    setState(() => _isLoading = true);
    
    try {
      await context.read<ProductProvider>().fetchProducts();
    } catch (e) {
      if (mounted) {
        FloatingNotification.showError(
          context,
          'Failed to load products: ${e.toString()}',
          onRetry: _loadProducts,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _checkConnectivity() {
    // Simulate connectivity check
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && !_isConnected) {
        setState(() => _isConnected = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Connection status
          ConnectionStatusIndicator(
            isConnected: _isConnected,
            onRetry: () {
              setState(() => _isConnected = true);
              _loadProducts();
            },
          ),

          // Search and filters
          _buildSearchSection(),

          // Category pills
          _buildCategorySection(),

          // Breadcrumbs (when navigating deeper)
          if (_selectedCategory != 'All')
            BreadcrumbNavigation(
              items: [
                BreadcrumbItem(
                  title: 'Home',
                  icon: Icons.home,
                  onTap: () {
                    setState(() => _selectedCategory = 'All');
                  },
                ),
                BreadcrumbItem(
                  title: _selectedCategory,
                  isActive: true,
                ),
              ],
            ),

          // Product grid
          Expanded(
            child: _buildProductGrid(),
          ),
        ],
      ),
      floatingActionButton: _buildQuickActions(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Row(
        children: [
          Text('SmartLink'),
          SizedBox(width: AppSpacing.sm),
          BatteryStatusIndicator(
            batteryLevel: 0.75,
            isCharging: false,
          ),
        ],
      ),
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () {
            FloatingNotification.showSuccess(context, 'Wishlist feature coming soon!');
          },
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
        IconButton(
          icon: const Icon(Icons.tune),
          onPressed: _showAdvancedFilters,
        ),
      ],
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          VoiceSearchField(
            controller: _searchController,
            hintText: 'Search products, brands, categories...',
            onSearch: (query) {
              _performSearch(query);
            },
            onVoiceResult: (result) {
              FloatingNotification.showSuccess(
                context,
                'Voice search: $result',
              );
              _performSearch(result);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular products',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              GestureDetector(
                onTap: _showSortOptions,
                child: Row(
                  children: [
                    const Icon(Icons.sort, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      _getSortLabel(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          
          return GestureDetector(
            onTap: () {
              setState(() => _selectedCategory = category);
              _filterByCategory(category);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: AppSpacing.sm),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryGreen : Colors.grey[100],
                borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                border: isSelected 
                    ? null 
                    : Border.all(color: Colors.grey[300]!),
              ),
              child: Center(
                child: Text(
                  category,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (_isLoading && productProvider.products.isEmpty) {
          return const ProductGridSkeleton(itemCount: 6);
        }

        if (productProvider.products.isEmpty) {
          return EnhancedEmptyStateWidget(
            illustration: const EmptyCartIllustration(),
            title: 'No products found',
            message: _searchController.text.isEmpty
                ? 'Products will appear here when available'
                : 'No products match your search criteria',
            actionText: 'Refresh',
            onAction: _loadProducts,
            secondaryActionText: _searchController.text.isNotEmpty ? 'Clear Search' : null,
            onSecondaryAction: _searchController.text.isNotEmpty
                ? () {
                    _searchController.clear();
                    _loadProducts();
                  }
                : null,
          );
        }

        return PullToRefreshWrapper(
          onRefresh: _refreshProducts,
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(AppSpacing.md),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
            ),
            itemCount: productProvider.products.length + (_isLoading ? 2 : 0),
            itemBuilder: (context, index) {
              if (index >= productProvider.products.length) {
                return const EnhancedProductCardSkeleton();
              }

              final product = productProvider.products[index];
              return _buildEnhancedProductCard(product);
            },
          ),
        );
      },
    );
  }

  Widget _buildEnhancedProductCard(ProductModel product) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/product-detail',
          arguments: product.id,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with progressive loading
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppBorderRadius.lg),
                  topRight: Radius.circular(AppBorderRadius.lg),
                ),
                child: Stack(
                  children: [
                    ProgressiveImage(
                      imageUrl: product.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: AppSpacing.sm,
                      right: AppSpacing.sm,
                      child: HeartAnimation(
                        isLiked: context.watch<ProductProvider>().isFavorite(product.id),
                        onToggle: () {
                          _toggleFavorite(product);
                        },
                      ),
                    ),
                    if (product.discount > 0)
                      Positioned(
                        top: AppSpacing.sm,
                        left: AppSpacing.sm,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.errorRed,
                            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                          ),
                          child: Text(
                            '-${product.discount.toInt()}%',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Product details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    if (product.rating > 0)
                      Row(
                        children: [
                          ...List.generate(5, (index) => Icon(
                            index < product.rating.floor()
                                ? Icons.star
                                : Icons.star_border,
                            color: AppColors.gold,
                            size: 14,
                          )),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            '(${product.reviewCount})',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.discount > 0)
                              Text(
                                '₦${product.originalPrice.toStringAsFixed(0)}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            Text(
                              '₦${product.price.toStringAsFixed(0)}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        ButtonPressAnimation(
                          onPressed: () => _showAddToCartBottomSheet(product),
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryGreen,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return QuickActionButton(
      actions: [
        QuickAction(
          label: 'Add Product',
          icon: Icons.add,
          backgroundColor: AppColors.primaryGreen,
          onPressed: () {
            Navigator.pushNamed(context, '/add-product');
          },
        ),
        QuickAction(
          label: 'Scan QR',
          icon: Icons.qr_code_scanner,
          backgroundColor: AppColors.infoBlue,
          onPressed: () {
            FloatingNotification.showSuccess(context, 'QR Scanner opened!');
          },
        ),
        QuickAction(
          label: 'Voice Search',
          icon: Icons.mic,
          backgroundColor: AppColors.warningOrange,
          onPressed: _showVoiceSearch,
        ),
      ],
    );
  }

  // Helper methods
  void _performSearch(String query) {
    setState(() => _isLoading = true);
    
    context.read<ProductProvider>().searchProducts(query);
    setState(() => _isLoading = false);
  }

  void _filterByCategory(String category) {
    setState(() => _isLoading = true);
    
    if (category == 'All') {
      _loadProducts();
    } else {
      // Convert string category to ProductCategory enum
      ProductCategory? categoryEnum;
      if (category != 'All') {
        try {
          categoryEnum = ProductCategory.values.firstWhere(
            (e) => e.toString().split('.').last.toLowerCase() == category.toLowerCase()
          );
        } catch (e) {
          categoryEnum = null;
        }
      }
      context.read<ProductProvider>().filterByCategory(categoryEnum);
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshProducts() async {
    await context.read<ProductProvider>().fetchProducts();
  }

  void _toggleFavorite(ProductModel product) {
    context.read<ProductProvider>().toggleFavorite(product.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${context.read<ProductProvider>().isFavorite(product.id) ? "Added to" : "Removed from"} favorites'))
    );
  }

  void _showAddToCartBottomSheet(ProductModel product) {
    EnhancedBottomSheet.show(
      context: context,
      child: AddToCartBottomSheet(
        productId: product.id,
        productName: product.name,
        productImage: product.imageUrl,
        price: product.price,
        maxQuantity: product.stock,
        onAddToCart: () {
          context.read<ProductProvider>().addToCart(product.id, 1);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${product.name} added to cart!'))
          );
        },
      ),
    );
  }

  void _showVoiceSearch() {
    EnhancedBottomSheet.show(
      context: context,
      height: 400,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: VoiceInputWidget(
          onTextReceived: (text) {
            Navigator.pop(context);
            _searchController.text = text;
            _performSearch(text);
          },
          hint: 'Say your search query',
        ),
      ),
    );
  }

  void _showSortOptions() {
    EnhancedBottomSheet.show(
      context: context,
      child: SortBottomSheet(
        currentSort: _selectedSort,
        onSortSelected: (sort) {
          setState(() => _selectedSort = sort);
          _applySorting(sort);
        },
      ),
    );
  }

  void _showAdvancedFilters() {
    EnhancedBottomSheet.show(
      context: context,
      child: FilterBottomSheet(
        currentFilters: const {},
        onApplyFilters: (filters) {
          FloatingNotification.showSuccess(
            context,
            'Filters applied successfully!',
          );
          // Apply filters logic here
        },
      ),
    );
  }

  void _applySorting(String sort) {
    context.read<ProductProvider>().sortProducts(sort);
  }

  String _getSortLabel() {
    switch (_selectedSort) {
      case 'newest':
        return 'Newest';
      case 'price_low':
        return 'Price: Low to High';
      case 'price_high':
        return 'Price: High to Low';
      case 'rating':
        return 'Highest Rated';
      case 'popular':
        return 'Most Popular';
      default:
        return 'Sort';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}