import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/responsive_wrapper.dart';

class RiderOrdersContent extends StatelessWidget {
  const RiderOrdersContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: ResponsiveUtils.getResponsivePagePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Deliveries',
              style: ResponsiveUtils.isDesktop(context)
                ? AppTextStyles.heading1
                : AppTextStyles.heading2,
            ),
            SizedBox(height: ResponsiveUtils.isDesktop(context) 
              ? AppSpacing.xl : AppSpacing.lg),
            
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.isDesktop(context) 
                ? AppSpacing.xl * 2 : AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.delivery_dining_outlined,
                      size: ResponsiveUtils.isDesktop(context) ? 120 : 80,
                      color: AppColors.grey,
                    ),
                    SizedBox(height: ResponsiveUtils.isDesktop(context) 
                      ? AppSpacing.lg : AppSpacing.md),
                    Text(
                      'No deliveries yet',
                      style: ResponsiveUtils.isDesktop(context)
                        ? AppTextStyles.heading3.copyWith(color: AppColors.grey)
                        : AppTextStyles.bodyLarge.copyWith(color: AppColors.grey),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Your delivery history will appear here',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.grey,
                      ),
                      textAlign: TextAlign.center,
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
}