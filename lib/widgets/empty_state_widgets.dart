import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'custom_button.dart';

/// Generic empty state widget with illustration
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;
  final Color? iconColor;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
    this.iconColor,
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
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primaryGreen).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 80,
                color: iconColor ?? AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: AppTextStyles.heading3,
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
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xl),
              CustomButton(
                text: actionText!,
                onPressed: onAction!,
                icon: Icons.add,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty cart state
class EmptyCartWidget extends StatelessWidget {
  final VoidCallback? onShopNow;

  const EmptyCartWidget({super.key, this.onShopNow});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.shopping_cart_outlined,
      title: 'Your cart is empty',
      message: 'Add products to your cart to see them here',
      actionText: onShopNow != null ? 'Start Shopping' : null,
      onAction: onShopNow,
      iconColor: AppColors.mutedGreen,
    );
  }
}

/// Empty orders state
class EmptyOrdersWidget extends StatelessWidget {
  final VoidCallback? onBrowse;

  const EmptyOrdersWidget({super.key, this.onBrowse});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.shopping_bag_outlined,
      title: 'No orders yet',
      message: 'Your order history will appear here',
      actionText: onBrowse != null ? 'Browse Products' : null,
      onAction: onBrowse,
      iconColor: AppColors.infoBlue,
    );
  }
}

/// Empty products state (for sellers)
class EmptyProductsWidget extends StatelessWidget {
  final VoidCallback? onAddProduct;

  const EmptyProductsWidget({super.key, this.onAddProduct});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.inventory_2_outlined,
      title: 'No products listed',
      message: 'Add your first product to start selling',
      actionText: onAddProduct != null ? 'Add Product' : null,
      onAction: onAddProduct,
      iconColor: AppColors.gold,
    );
  }
}

/// Empty deliveries state (for riders)
class EmptyDeliveriesWidget extends StatelessWidget {
  const EmptyDeliveriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(
      icon: Icons.delivery_dining,
      title: 'No active deliveries',
      message: 'New delivery requests will appear here',
      iconColor: AppColors.primaryGreen,
    );
  }
}

/// No search results
class NoSearchResultsWidget extends StatelessWidget {
  final String searchQuery;
  final VoidCallback? onClearSearch;

  const NoSearchResultsWidget({
    super.key,
    required this.searchQuery,
    this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      title: 'No results found',
      message: 'We couldn\'t find anything for "$searchQuery"',
      actionText: onClearSearch != null ? 'Clear Search' : null,
      onAction: onClearSearch,
      iconColor: AppColors.textSecondary,
    );
  }
}

/// Network error state
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.wifi_off,
      title: 'No Internet Connection',
      message: 'Please check your internet connection and try again',
      actionText: onRetry != null ? 'Retry' : null,
      onAction: onRetry,
      iconColor: AppColors.errorRed,
    );
  }
}
