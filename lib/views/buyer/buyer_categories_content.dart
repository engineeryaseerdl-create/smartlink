import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../models/product_model.dart';
import '../../utils/constants.dart';

class BuyerCategoriesContent extends StatelessWidget {
  const BuyerCategoriesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: ResponsiveUtils.getResponsivePagePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All Categories',
              style: ResponsiveUtils.isDesktop(context)
                ? AppTextStyles.heading1
                : AppTextStyles.heading2,
            ),
            SizedBox(height: ResponsiveUtils.isDesktop(context) 
              ? AppSpacing.xl : AppSpacing.lg),
            _buildCategoriesGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid(BuildContext context) {
    final categories = [
      {'name': 'Food', 'icon': Icons.shopping_basket, 'category': ProductCategory.food, 'color': AppColors.successGreen},
      {'name': 'Electronics', 'icon': Icons.devices, 'category': ProductCategory.electronics, 'color': AppColors.infoBlue},
      {'name': 'Electronics', 'icon': Icons.smartphone, 'category': ProductCategory.electronics, 'color': AppColors.primaryGreen},
      {'name': 'Automotive', 'icon': Icons.directions_car, 'category': ProductCategory.automotive, 'color': AppColors.errorRed},
      {'name': 'Home', 'icon': Icons.kitchen, 'category': ProductCategory.home, 'color': AppColors.warningOrange},
      {'name': 'Fashion', 'icon': Icons.checkroom, 'category': ProductCategory.fashion, 'color': AppColors.gold},
      {'name': 'Books', 'icon': Icons.book, 'category': ProductCategory.books, 'color': AppColors.darkGreen},
      {'name': 'Sports', 'icon': Icons.sports, 'category': ProductCategory.sports, 'color': AppColors.grey},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtils.getGridCrossAxisCount(context),
        childAspectRatio: ResponsiveUtils.isDesktop(context) ? 1.2 : 1.0,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(
          context,
          category['name'] as String,
          category['icon'] as IconData,
          category['category'] as ProductCategory,
          category['color'] as Color,
        );
      },
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String label,
    IconData icon,
    ProductCategory category,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        context.read<ProductProvider>().filterByCategory(category);
        // Navigate back to home if on mobile, or update state if on desktop
        if (ResponsiveUtils.isMobile(context)) {
          Navigator.pop(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: ResponsiveUtils.isDesktop(context) ? 60 : 48,
              height: ResponsiveUtils.isDesktop(context) ? 60 : 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: ResponsiveUtils.isDesktop(context) ? 32 : 28,
              ),
            ),
            SizedBox(height: ResponsiveUtils.isDesktop(context) 
              ? AppSpacing.md : AppSpacing.sm),
            Text(
              label,
              textAlign: TextAlign.center,
              style: ResponsiveUtils.isDesktop(context)
                ? AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)
                : AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}