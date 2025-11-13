import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/responsive_wrapper.dart';
import '../../providers/rider_provider.dart';

class RiderDashboardContent extends StatelessWidget {
  const RiderDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final riderProvider = Provider.of<RiderProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      body: SingleChildScrollView(
        padding: ResponsiveUtils.getResponsivePagePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(user),
            SizedBox(height: ResponsiveUtils.isDesktop(context) 
              ? AppSpacing.xl : AppSpacing.lg),
            _buildStatsSection(),
            SizedBox(height: ResponsiveUtils.isDesktop(context) 
              ? AppSpacing.xl : AppSpacing.lg),
            _buildAvailableOrders(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(user) {
    return Builder(
      builder: (context) => ResponsiveUtils.isDesktop(context)
        ? _buildDesktopHeader(user)
        : _buildMobileHeader(user),
    );
  }

  Widget _buildDesktopHeader(user) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreen.withOpacity(0.1),
            AppColors.lightGreen.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ready to deliver, ${Helpers.getFirstName(user?.name, 'Rider')}!',
                  style: AppTextStyles.heading1.copyWith(
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Check available deliveries and manage your rides',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: AppColors.primaryGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delivery_dining,
              color: AppColors.white,
              size: 48,
            ),
          ),
        ],
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
              'Hello, ${Helpers.getFirstName(user?.name, 'Rider')}!',
              style: AppTextStyles.heading2,
            ),
            Text(
              'Ready for deliveries',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
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
            Icons.delivery_dining,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Overview',
            style: ResponsiveUtils.isDesktop(context)
              ? AppTextStyles.heading2
              : AppTextStyles.heading3,
          ),
          SizedBox(height: ResponsiveUtils.isDesktop(context) 
            ? AppSpacing.lg : AppSpacing.md),
          ResponsiveUtils.isDesktop(context)
            ? _buildDesktopStats()
            : _buildMobileStats(),
        ],
      ),
    );
  }

  Widget _buildDesktopStats() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      childAspectRatio: 1.5,
      crossAxisSpacing: AppSpacing.lg,
      mainAxisSpacing: AppSpacing.lg,
      children: [
        _buildStatCard('Deliveries', '5', Icons.delivery_dining, AppColors.primaryGreen, true),
        _buildStatCard('Earnings', '₦12,500', Icons.account_balance_wallet, AppColors.gold, true),
        _buildStatCard('Distance', '45km', Icons.route, AppColors.infoBlue, true),
        _buildStatCard('Rating', '4.8', Icons.star, AppColors.warningOrange, true),
      ],
    );
  }

  Widget _buildMobileStats() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatCard('Deliveries', '5', Icons.delivery_dining, AppColors.primaryGreen)),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: _buildStatCard('Earnings', '₦12,500', Icons.account_balance_wallet, AppColors.gold)),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(child: _buildStatCard('Distance', '45km', Icons.route, AppColors.infoBlue)),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: _buildStatCard('Rating', '4.8', Icons.star, AppColors.warningOrange)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, [bool isDesktop = false]) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? AppSpacing.sm : 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Icon(icon, color: color, size: isDesktop ? 24 : 16),
          ),
          const SizedBox(height: 2),
          Flexible(
            child: Text(
              value,
              style: isDesktop
                ? AppTextStyles.bodyMedium.copyWith(color: color, fontWeight: FontWeight.bold)
                : AppTextStyles.bodySmall.copyWith(color: color, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isDesktop ? 10 : 8,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableOrders() {
    return Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Orders',
            style: ResponsiveUtils.isDesktop(context)
              ? AppTextStyles.heading2
              : AppTextStyles.heading3,
          ),
          SizedBox(height: ResponsiveUtils.isDesktop(context) 
            ? AppSpacing.lg : AppSpacing.md),
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
                    Icons.local_shipping_outlined,
                    size: ResponsiveUtils.isDesktop(context) ? 80 : 60,
                    color: AppColors.primaryGreen.withOpacity(0.6),
                  ),
                  SizedBox(height: ResponsiveUtils.isDesktop(context) 
                    ? AppSpacing.lg : AppSpacing.md),
                  Text(
                    'No available orders',
                    style: ResponsiveUtils.isDesktop(context)
                      ? AppTextStyles.heading3.copyWith(color: AppColors.textPrimary)
                      : AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Check back later for delivery opportunities',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}