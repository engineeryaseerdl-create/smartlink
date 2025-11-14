import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'custom_button.dart';
import 'animated_widgets.dart';

/// Enhanced empty state with custom illustrations and animations
class EnhancedEmptyStateWidget extends StatelessWidget {
  final Widget illustration;
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;
  final String? secondaryActionText;
  final VoidCallback? onSecondaryAction;

  const EnhancedEmptyStateWidget({
    super.key,
    required this.illustration,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
    this.secondaryActionText,
    this.onSecondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated illustration
            SlideInAnimation(
              child: illustration,
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // Title with fade in animation
            FadeInAnimation(
              delay: const Duration(milliseconds: 200),
              child: Text(
                title,
                style: AppTextStyles.heading2,
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Message with fade in animation
            FadeInAnimation(
              delay: const Duration(milliseconds: 400),
              child: Text(
                message,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Action buttons with slide up animation
            SlideInAnimation(
              direction: SlideDirection.bottom,
              delay: const Duration(milliseconds: 600),
              child: Column(
                children: [
                  if (actionText != null && onAction != null)
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: actionText!,
                        onPressed: onAction!,
                        icon: Icons.add,
                      ),
                    ),
                  
                  if (secondaryActionText != null && onSecondaryAction != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: onSecondaryAction,
                        child: Text(
                          secondaryActionText!,
                          style: AppTextStyles.buttonText.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom illustration widgets for different empty states
class EmptyCartIllustration extends StatefulWidget {
  const EmptyCartIllustration({super.key});

  @override
  State<EmptyCartIllustration> createState() => _EmptyCartIllustrationState();
}

class _EmptyCartIllustrationState extends State<EmptyCartIllustration>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _floatAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    _floatController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
                const Icon(
                  Icons.shopping_cart_outlined,
                  size: 60,
                  color: AppColors.primaryGreen,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class EmptyOrdersIllustration extends StatelessWidget {
  const EmptyOrdersIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: AppColors.infoBlue.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.infoBlue.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                size: 40,
                color: AppColors.infoBlue,
              ),
              const SizedBox(height: 4),
              Container(
                width: 30,
                height: 2,
                decoration: BoxDecoration(
                  color: AppColors.infoBlue.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(height: 2),
              Container(
                width: 20,
                height: 2,
                decoration: BoxDecoration(
                  color: AppColors.infoBlue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EmptySearchIllustration extends StatelessWidget {
  const EmptySearchIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.textSecondary,
                width: 3,
              ),
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            bottom: 35,
            right: 25,
            child: Transform.rotate(
              angle: 0.785398, // 45 degrees
              child: Container(
                width: 25,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyProductsIllustration extends StatelessWidget {
  const EmptyProductsIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: AppColors.gold.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                size: 50,
                color: AppColors.gold,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Enhanced empty states using the new illustrations
class EnhancedEmptyCartWidget extends StatelessWidget {
  final VoidCallback? onShopNow;

  const EnhancedEmptyCartWidget({super.key, this.onShopNow});

  @override
  Widget build(BuildContext context) {
    return EnhancedEmptyStateWidget(
      illustration: const EmptyCartIllustration(),
      title: 'Your cart is empty',
      message: 'Discover amazing products and add them to your cart to get started',
      actionText: onShopNow != null ? 'Start Shopping' : null,
      onAction: onShopNow,
      secondaryActionText: 'View Categories',
      onSecondaryAction: () {
        // Navigate to categories
      },
    );
  }
}

class EnhancedEmptyOrdersWidget extends StatelessWidget {
  final VoidCallback? onBrowse;

  const EnhancedEmptyOrdersWidget({super.key, this.onBrowse});

  @override
  Widget build(BuildContext context) {
    return EnhancedEmptyStateWidget(
      illustration: const EmptyOrdersIllustration(),
      title: 'No orders yet',
      message: 'Your order history will appear here once you make your first purchase',
      actionText: onBrowse != null ? 'Browse Products' : null,
      onAction: onBrowse,
      secondaryActionText: 'View Deals',
      onSecondaryAction: () {
        // Navigate to deals
      },
    );
  }
}

class EnhancedNoSearchResultsWidget extends StatelessWidget {
  final String searchQuery;
  final VoidCallback? onClearSearch;
  final VoidCallback? onBrowseCategories;

  const EnhancedNoSearchResultsWidget({
    super.key,
    required this.searchQuery,
    this.onClearSearch,
    this.onBrowseCategories,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedEmptyStateWidget(
      illustration: const EmptySearchIllustration(),
      title: 'No results found',
      message: 'We couldn\'t find anything matching "$searchQuery". Try different keywords or browse categories.',
      actionText: onClearSearch != null ? 'Clear Search' : null,
      onAction: onClearSearch,
      secondaryActionText: 'Browse Categories',
      onSecondaryAction: onBrowseCategories,
    );
  }
}

class EnhancedEmptyProductsWidget extends StatelessWidget {
  final VoidCallback? onAddProduct;

  const EnhancedEmptyProductsWidget({super.key, this.onAddProduct});

  @override
  Widget build(BuildContext context) {
    return EnhancedEmptyStateWidget(
      illustration: const EmptyProductsIllustration(),
      title: 'No products listed',
      message: 'Start your selling journey by adding your first product to the marketplace',
      actionText: onAddProduct != null ? 'Add Your First Product' : null,
      onAction: onAddProduct,
      secondaryActionText: 'Learn About Selling',
      onSecondaryAction: () {
        // Navigate to seller guide
      },
    );
  }
}