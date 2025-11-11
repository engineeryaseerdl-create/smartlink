import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/product_card.dart';
import '../buyer/product_detail_screen.dart';

class SellerProductsScreen extends StatelessWidget {
  const SellerProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final user = authProvider.currentUser;

    final myProducts = productProvider.products
        .where((p) => p.sellerId == user?.id)
        .toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('My Products', style: AppTextStyles.heading2),
            const SizedBox(height: AppSpacing.lg),
            if (productProvider.isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (myProducts.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inventory_2_outlined,
                          size: 80, color: AppColors.grey),
                      const SizedBox(height: AppSpacing.md),
                      Text('No products yet',
                          style: AppTextStyles.bodyLarge
                              .copyWith(color: AppColors.grey)),
                      const SizedBox(height: AppSpacing.sm),
                      Text('Tap the + button to add your first product',
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: AppColors.grey)),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  itemCount: myProducts.length,
                  itemBuilder: (context, index) {
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
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
