import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/order_provider.dart';
import '../../models/product_model.dart';
import '../../utils/constants.dart';
import '../../widgets/product_card.dart';
import '../../widgets/animated_widgets.dart';
import 'product_detail_screen.dart';

class BuyerHomeContent extends StatefulWidget {
  const BuyerHomeContent({super.key});

  @override
  State<BuyerHomeContent> createState() => _BuyerHomeContentState();
}

class _BuyerHomeContentState extends State<BuyerHomeContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProductProvider>().loadProducts();
      context.read<OrderProvider>().loadOrders();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header Section
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: ResponsiveUtils.getResponsivePagePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(user),
                  SizedBox(height: ResponsiveUtils.isDesktop(context) 
                    ? AppSpacing.xl : AppSpacing.lg),
                  _buildSearchBar(productProvider),
                  SizedBox(height: ResponsiveUtils.isDesktop(context) 
                    ? AppSpacing.xl : AppSpacing.lg),
                  _buildCategoriesSection(),
                ],
              ),
            ),
          ),
          
          // Featured Products Header
          SliverToBoxAdapter(
            child: Container(
              padding: ResponsiveUtils.getResponsivePagePadding(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured Products',
                    style: ResponsiveUtils.isDesktop(context)
                      ? AppTextStyles.heading2
                      : AppTextStyles.heading3,
                  ),
                  if (productProvider.selectedCategory != null)
                    TextButton(
                      onPressed: () {
                        productProvider.filterByCategory(null);
                      },
                      child: const Text('Clear Filter'),
                    ),
                ],
              ),
            ),
          ),

          // Products Grid
          if (productProvider.isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (productProvider.products.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.search_off,
                      size: 80,
                      color: AppColors.grey,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'No products found',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: ResponsiveUtils.getResponsivePagePadding(context),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveUtils.getGridCrossAxisCount(context),
                  childAspectRatio: ResponsiveUtils.isDesktop(context) ? 0.8 : 0.7,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = productProvider.products[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailScreen(product: product),
                          ),
                        );
                      },
                    );
                  },
                  childCount: productProvider.products.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(user) {
    return ResponsiveUtils.isDesktop(context)
      ? _buildDesktopHeader(user)
      : _buildMobileHeader(user);
  }

  Widget _buildDesktopHeader(user) {
    return FadeInWidget(
      slideUp: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.headerGradientStart,
              AppColors.headerGradientEnd,
            ],
            stops: [0.0, 1.0],
          ),
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SlideInWidget(
                  direction: SlideDirection.left,
                  child: Text(
                    'Welcome back, ${user?.name.split(' ').first ?? 'User'}!',
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                FadeInWidget(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    'Discover amazing products from local sellers across Nigeria',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.white.withOpacity(0.9),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                FadeInWidget(
                  delay: const Duration(milliseconds: 400),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: AppColors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        user?.location ?? 'Location',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ScaleInWidget(
            delay: const Duration(milliseconds: 300),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white.withOpacity(0.3),
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.white,
                size: 48,
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildMobileHeader(user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${user?.name.split(' ').first ?? 'User'}!',
              style: AppTextStyles.heading2,
            ),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 16,
                  color: AppColors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  user?.location ?? 'Location',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: AppColors.primaryGreen,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(ProductProvider productProvider) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: ResponsiveUtils.isDesktop(context) ? 600 : double.infinity,
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          productProvider.searchProducts(value);
        },
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: AppColors.lightGrey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: ResponsiveUtils.isDesktop(context)
            ? AppTextStyles.heading2
            : AppTextStyles.heading3,
        ),
        const SizedBox(height: AppSpacing.md),
        ResponsiveUtils.isDesktop(context)
          ? _buildDesktopCategories()
          : _buildMobileCategories(),
      ],
    );
  }

  Widget _buildDesktopCategories() {
    final categories = [
      {'name': 'Food', 'icon': Icons.shopping_basket, 'category': ProductCategory.food},
      {'name': 'Electronics', 'icon': Icons.devices, 'category': ProductCategory.electronics},
      {'name': 'Fashion', 'icon': Icons.checkroom, 'category': ProductCategory.fashion},
      {'name': 'Home', 'icon': Icons.home, 'category': ProductCategory.home},
      {'name': 'Books', 'icon': Icons.book, 'category': ProductCategory.books},
      {'name': 'Sports', 'icon': Icons.sports, 'category': ProductCategory.sports},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtils.isLargeDesktop(context) ? 6 : 4,
        childAspectRatio: 1.2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return ScaleInWidget(
          delay: Duration(milliseconds: index * 150),
          child: _buildCategoryCard(
            category['name'] as String,
            category['icon'] as IconData,
            category['category'] as ProductCategory,
          ),
        );
      },
    );
  }

  Widget _buildMobileCategories() {
    final categories = [
      {'name': 'Food', 'icon': Icons.shopping_basket, 'category': ProductCategory.food},
      {'name': 'Electronics', 'icon': Icons.devices, 'category': ProductCategory.electronics},
      {'name': 'Fashion', 'icon': Icons.checkroom, 'category': ProductCategory.fashion},
      {'name': 'Home', 'icon': Icons.home, 'category': ProductCategory.home},
      {'name': 'Books', 'icon': Icons.book, 'category': ProductCategory.books},
      {'name': 'Sports', 'icon': Icons.sports, 'category': ProductCategory.sports},
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return FadeInWidget(
            delay: Duration(milliseconds: index * 100),
            child: _buildCategoryChip(
              category['name'] as String,
              category['icon'] as IconData,
              category['category'] as ProductCategory,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(String label, IconData icon, ProductCategory category) {
    final productProvider = Provider.of<ProductProvider>(context);
    final isSelected = productProvider.selectedCategory == category;

    return GestureDetector(
      onTap: () {
        productProvider.filterByCategory(isSelected ? null : category);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : AppColors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.lightGrey,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.white : AppColors.primaryGreen,
              size: 32,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.white : AppColors.darkGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, ProductCategory category) {
    final productProvider = Provider.of<ProductProvider>(context);
    final isSelected = productProvider.selectedCategory == category;

    return GestureDetector(
      onTap: () {
        productProvider.filterByCategory(isSelected ? null : category);
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : AppColors.lightGrey,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.white : AppColors.darkGrey,
              size: 32,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.white : AppColors.darkGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}