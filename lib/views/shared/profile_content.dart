import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/constants.dart';
import 'settings_screen.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      body: SingleChildScrollView(
        padding: ResponsiveUtils.getResponsivePagePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: ResponsiveUtils.isDesktop(context)
                ? AppTextStyles.heading1
                : AppTextStyles.heading2,
            ),
            SizedBox(height: ResponsiveUtils.isDesktop(context) 
              ? AppSpacing.xl : AppSpacing.lg),
            
            // User Info Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(ResponsiveUtils.isDesktop(context) 
                ? AppSpacing.xl : AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ResponsiveUtils.isDesktop(context)
                ? _buildDesktopUserInfo(user)
                : _buildMobileUserInfo(user),
            ),
            
            SizedBox(height: ResponsiveUtils.isDesktop(context) 
              ? AppSpacing.xl : AppSpacing.lg),
            
            // Settings Section
            _buildSettingsSection(context, themeProvider, authProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopUserInfo(user) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGreen.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            _getUserIcon(user),
            color: AppColors.white,
            size: 48,
          ),
        ),
        const SizedBox(width: AppSpacing.xl),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.name ?? 'User',
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                user?.email ?? 'email@example.com',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _getRoleText(user),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (user?.location != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppColors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      user!.location!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileUserInfo(user) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: AppColors.primaryGreen,
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getUserIcon(user),
            color: AppColors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          user?.name ?? 'User',
          style: AppTextStyles.heading3,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          user?.email ?? 'email@example.com',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.grey,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          _getRoleText(user),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        if (user?.location != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                size: 16,
                color: AppColors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                user!.location!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context, ThemeProvider themeProvider, AuthProvider authProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: ResponsiveUtils.isDesktop(context)
            ? AppTextStyles.heading2
            : AppTextStyles.heading3,
        ),
        const SizedBox(height: AppSpacing.md),
        
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSettingsTile(
                icon: Icons.dark_mode,
                title: 'Dark Mode',
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (_) => themeProvider.toggleTheme(),
                ),
              ),
              const Divider(height: 1),
              _buildSettingsTile(
                icon: Icons.settings,
                title: 'App Settings',
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              _buildSettingsTile(
                icon: Icons.help,
                title: 'Help & Support',
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to help
                },
              ),
              const Divider(height: 1),
              _buildSettingsTile(
                icon: Icons.logout,
                title: 'Logout',
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  authProvider.logout();
                },
                isDestructive: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.errorRed : null,
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isDestructive ? AppColors.errorRed : null,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  IconData _getUserIcon(user) {
    if (user?.role?.toString() == 'UserRole.seller') {
      return Icons.store;
    } else if (user?.role?.toString() == 'UserRole.rider') {
      return Icons.delivery_dining;
    }
    return Icons.person;
  }

  String _getRoleText(user) {
    if (user?.role?.toString() == 'UserRole.seller') {
      return 'Seller';
    } else if (user?.role?.toString() == 'UserRole.rider') {
      return 'Rider';
    }
    return 'Buyer';
  }
}