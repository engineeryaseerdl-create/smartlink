import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/product_model.dart';
import '../../utils/constants.dart';
import '../../widgets/product_card.dart';
import '../../widgets/skeleton_loader.dart';
import '../../widgets/quick_action_fab.dart';
import '../../widgets/voice_search.dart';
import '../../widgets/notification_stream.dart';
import 'product_detail_screen.dart';
import 'buyer_orders_screen.dart';
import 'cart_screen.dart';
import '../shared/profile_screen.dart';
import '../notifications_screen.dart';
import '../chat_screen.dart';

class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

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
    final List<Widget> pages = [
      _buildHomePage(),
      _buildCategoriesPage(),
      const BuyerOrdersScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0 ? QuickActionFAB(
        icon: const Icon(Icons.add),
        actions: [
          QuickAction(
            icon: const Icon(Icons.search),
            onPressed: () => _showQuickSearch(context),
            backgroundColor: Colors.blue,
          ),
          QuickAction(
            icon: const Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatListScreen(),
                ),
              );
            },
            backgroundColor: Colors.blue,
          ),
        ],
      ) : null,
      bottomNavigationBar: SafeArea(
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primaryGreen,
          unselectedItemColor: AppColors.textSecondary,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Categories',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Consumer<CartProvider>(
                builder: (context, cart, child) {
                  return Badge(
                    label: Text('${cart.totalItems}'),
                    isLabelVisible: cart.totalItems > 0,
                    child: const Icon(Icons.shopping_cart),
                  );
                },
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomePage() {
    final authProvider = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final user = authProvider.currentUser;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) {
            context.read<ProductProvider>().loadProducts();
          }
        },
        child: CustomScrollView(
          slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good ${_getGreeting()}!',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              user?.name.split(' ').first ?? 'User',
                              style: AppTextStyles.heading2.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: AppColors.primaryGreen,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    user?.location ?? 'Set Location',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.primaryGreen,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 16,
                                    color: AppColors.primaryGreen,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: AppColors.backgroundLight,
                              shape: BoxShape.circle,
                            ),
                            child: NotificationStream(
                              builder: (count) => IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const NotificationsScreen(),
                                    ),
                                  );
                                },
                                icon: Badge(
                                  label: Text('$count'),
                                  isLabelVisible: count > 0,
                                  backgroundColor: AppColors.errorRed,
                                  child: const Icon(
                                    Icons.notifications_outlined,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Consumer<CartProvider>(
                            builder: (context, cart, child) {
                              return Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.backgroundLight,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const CartScreen()),
                                    );
                                  },
                                  icon: Badge(
                                    label: Text('${cart.totalItems}'),
                                    isLabelVisible: cart.totalItems > 0,
                                    backgroundColor: AppColors.primaryGreen,
                                    child: const Icon(
                                      Icons.shopping_cart_outlined,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        productProvider.searchProducts(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search for products, brands, categories...',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.textSecondary,
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            VoiceSearchButton(
                              onResult: (result) {
                                _searchController.text = result;
                                productProvider.searchProducts(result);
                              },
                            ),
                            const SizedBox(width: 8),
                            Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.tune,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.md,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                    child: Container(
                      height: 110,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryGreen,
                            AppColors.darkGreen,
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -20,
                            top: -20,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Free Delivery',
                                        style: AppTextStyles.heading3.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'On orders above ₦5,000',
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          'Shop Now',
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.primaryGreen,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.local_shipping,
                                  size: 50,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Shop by Category',
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                        child: Text(
                          'See All',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCategoryChip(
                          'Groceries',
                          Icons.shopping_basket,
                          ProductCategory.groceries,
                        ),
                        _buildCategoryChip(
                          'Electronics',
                          Icons.devices,
                          ProductCategory.electronics,
                        ),
                        _buildCategoryChip(
                          'Phones',
                          Icons.smartphone,
                          ProductCategory.phones,
                        ),
                        _buildCategoryChip(
                          'Cars',
                          Icons.directions_car,
                          ProductCategory.cars,
                        ),
                        _buildCategoryChip(
                          'Appliances',
                          Icons.kitchen,
                          ProductCategory.appliances,
                        ),
                        _buildCategoryChip(
                          'Fashion',
                          Icons.checkroom,
                          ProductCategory.fashion,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Featured Products',
                        style: AppTextStyles.heading3,
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

                ],
              ),
            ),
          ),
          if (productProvider.isLoading)
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.md),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const ProductCardSkeleton(),
                  childCount: 6,
                ),
              ),
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
                      color: AppColors.mutedGreen,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'No products found',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.md),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
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
      ),
    );
  }

  Widget _buildCategoryChip(
      String label, IconData icon, ProductCategory category) {
    final productProvider = Provider.of<ProductProvider>(context);
    final isSelected = productProvider.selectedCategory == category;

    return GestureDetector(
      onTap: () {
        productProvider.filterByCategory(
            isSelected ? null : category);
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.primaryGreen : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.white : AppColors.textPrimary,
              size: 32,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesPage() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'All Categories',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                children: [
                  _buildFullCategoryCard(
                      'Groceries', Icons.shopping_basket, ProductCategory.groceries),
                  _buildFullCategoryCard(
                      'Electronics', Icons.devices, ProductCategory.electronics),
                  _buildFullCategoryCard(
                      'Phones', Icons.smartphone, ProductCategory.phones),
                  _buildFullCategoryCard(
                      'Cars', Icons.directions_car, ProductCategory.cars),
                  _buildFullCategoryCard(
                      'Appliances', Icons.kitchen, ProductCategory.appliances),
                  _buildFullCategoryCard(
                      'Fashion', Icons.checkroom, ProductCategory.fashion),
                  _buildFullCategoryCard(
                      'Furniture', Icons.chair, ProductCategory.furniture),
                  _buildFullCategoryCard(
                      'Other', Icons.more_horiz, ProductCategory.other),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullCategoryCard(
      String label, IconData icon, ProductCategory category) {
    return GestureDetector(
      onTap: () {
        context.read<ProductProvider>().filterByCategory(category);
        setState(() {
          _selectedIndex = 0;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
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
              color: AppColors.primaryGreen,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickSearch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Quick search...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                context.read<ProductProvider>().searchProducts(value);
              },
            ),
            const SizedBox(height: 16),
            const Expanded(
              child: Text('Search results will appear here'),
            ),
          ],
        ),
      ),
    );
  }
}
