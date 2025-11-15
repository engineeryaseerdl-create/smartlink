import 'package:flutter/material.dart';
import '../utils/constants.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 60,
                color: AppColors.primaryGreen.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                ),
                child: Text(buttonText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class NoProductsFound extends StatelessWidget {
  final VoidCallback? onRefresh;

  const NoProductsFound({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.search_off,
      title: 'No Products Found',
      message: 'We couldn\'t find any products matching your search. Try adjusting your filters or search terms.',
      buttonText: 'Refresh',
      onButtonPressed: onRefresh,
    );
  }
}

class NoOrdersYet extends StatelessWidget {
  final VoidCallback? onStartShopping;

  const NoOrdersYet({super.key, this.onStartShopping});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.shopping_bag_outlined,
      title: 'No Orders Yet',
      message: 'You haven\'t placed any orders yet. Start shopping to see your orders here.',
      buttonText: 'Start Shopping',
      onButtonPressed: onStartShopping,
    );
  }
}

class EmptyCart extends StatelessWidget {
  final VoidCallback? onStartShopping;

  const EmptyCart({super.key, this.onStartShopping});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.shopping_cart_outlined,
      title: 'Your Cart is Empty',
      message: 'Add some products to your cart to get started with your shopping.',
      buttonText: 'Browse Products',
      onButtonPressed: onStartShopping,
    );
  }
}

class NoFavorites extends StatelessWidget {
  final VoidCallback? onBrowseProducts;

  const NoFavorites({super.key, this.onBrowseProducts});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.favorite_border,
      title: 'No Favorites Yet',
      message: 'Save products you love by tapping the heart icon. They\'ll appear here.',
      buttonText: 'Browse Products',
      onButtonPressed: onBrowseProducts,
    );
  }
}