import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class DesktopSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTap;
  final List<SidebarItem> items;

  const DesktopSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Container(
      height: double.infinity,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // App Logo/Title
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.link,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const Text(
                      AppConstants.appName,
                      style: AppTextStyles.heading3,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                // User Info
                if (user != null) ...[
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primaryGreen,
                        child: Icon(
                          _getUserIcon(user.role),
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              _getRoleText(user.role),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          // Navigation Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selectedIndex == index;
                
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  child: Material(
                    color: isSelected 
                      ? AppColors.primaryGreen.withOpacity(0.1)
                      : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                    child: InkWell(
                      onTap: () => onItemTap(index),
                      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.md,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item.icon,
                              color: isSelected 
                                ? AppColors.primaryGreen
                                : Theme.of(context).iconTheme.color,
                              size: 24,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Text(
                              item.label,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: isSelected 
                                  ? AppColors.primaryGreen
                                  : Theme.of(context).textTheme.bodyMedium?.color,
                                fontWeight: isSelected 
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Settings/Logout
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                _buildBottomNavItem(
                  icon: Icons.settings,
                  label: 'Settings',
                  onTap: () {
                    // Navigate to settings
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildBottomNavItem(
                  icon: Icons.logout,
                  label: 'Logout',
                  onTap: () {
                    authProvider.logout();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Builder(
      builder: (context) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: Theme.of(context).iconTheme.color,
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  label,
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getUserIcon(UserRole role) {
    switch (role) {
      case UserRole.buyer:
        return Icons.person;
      case UserRole.seller:
        return Icons.store;
      case UserRole.rider:
        return Icons.delivery_dining;
    }
  }

  String _getRoleText(UserRole role) {
    switch (role) {
      case UserRole.buyer:
        return 'Buyer';
      case UserRole.seller:
        return 'Seller';
      case UserRole.rider:
        return 'Rider';
    }
  }
}

class SidebarItem {
  final String label;
  final IconData icon;

  const SidebarItem({
    required this.label,
    required this.icon,
  });
}