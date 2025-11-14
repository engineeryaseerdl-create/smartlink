import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/product_card.dart';
import 'add_product_screen.dart';
import '../buyer/product_detail_screen.dart';

class SellerProductsContent extends StatelessWidget {
  const SellerProductsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    
    final myProducts = productProvider.products
        .where((p) => p.sellerId == user?.id)
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: ResponsiveUtils.getResponsivePagePadding(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Products',
                    style: ResponsiveUtils.isDesktop(context)
                      ? AppTextStyles.heading1
                      : AppTextStyles.heading2,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddProductScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Product'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.isDesktop(context) 
                          ? AppSpacing.lg : AppSpacing.md,
                        vertical: ResponsiveUtils.isDesktop(context) 
                          ? AppSpacing.md : AppSpacing.sm,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: SizedBox(height: ResponsiveUtils.isDesktop(context) 
              ? AppSpacing.xl : AppSpacing.lg),
          ),
          
          if (myProducts.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_outlined,
                      size: ResponsiveUtils.isDesktop(context) ? 120 : 80,
                      color: AppColors.grey,
                    ),
                    SizedBox(height: ResponsiveUtils.isDesktop(context) 
                      ? AppSpacing.lg : AppSpacing.md),
                    Text(
                      'No products yet',
                      style: ResponsiveUtils.isDesktop(context)
                        ? AppTextStyles.heading3.copyWith(color: AppColors.grey)
                        : AppTextStyles.bodyLarge.copyWith(color: AppColors.grey),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Add your first product to start selling',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddProductScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Product'),
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
                    final product = myProducts[index];
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
                      showActions: true, // Show edit/delete actions for seller
                      showAddToCart: false, // Sellers can't buy their own products
                    );
                  },
                  childCount: myProducts.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}