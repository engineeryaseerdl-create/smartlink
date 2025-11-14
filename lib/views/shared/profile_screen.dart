import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/constants.dart';
import 'onboarding_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = authProvider.currentUser;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(context).padding.bottom + AppSpacing.lg,
        ),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getRoleIcon(user?.role),
                size: 50,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(user?.name ?? 'User', style: AppTextStyles.heading2),
            Text(user?.email ?? '',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey)),
            if (user?.location != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, size: 16, color: AppColors.grey),
                  Text(user!.location!,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey)),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            _buildProfileCard(
              context,
              [
                _buildProfileItem(Icons.person, 'Name', user?.name ?? 'N/A'),
                _buildProfileItem(Icons.email, 'Email', user?.email ?? 'N/A'),
                if (user?.phone != null)
                  _buildProfileItem(Icons.phone, 'Phone', user!.phone!),
                _buildProfileItem(Icons.location_on, 'Location', user?.location ?? 'N/A'),
                _buildProfileItem(Icons.badge, 'Role',
                    user?.role.toString().split('.').last ?? 'N/A'),
                if (user?.rating != null)
                  _buildProfileItem(Icons.star, 'Rating',
                      '${user!.rating!.toStringAsFixed(1)} ⭐'),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildProfileCard(
              context,
              [
                ListTile(
                  leading: const Icon(Icons.notifications, color: AppColors.primaryGreen),
                  title: const Text('Notifications'),
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {},
                    activeThumbColor: AppColors.primaryGreen,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.dark_mode, color: AppColors.primaryGreen),
                  title: const Text('Dark Mode'),
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                    activeThumbColor: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildProfileCard(
              context,
              [
                ListTile(
                  leading: const Icon(Icons.settings, color: AppColors.primaryGreen),
                  title: const Text('Settings'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help, color: AppColors.primaryGreen),
                  title: const Text('Help & Support'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.info, color: AppColors.primaryGreen),
                  title: const Text('About SmartLink'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () async {
                await authProvider.logout();
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorRed,
                foregroundColor: AppColors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
              ),
              child: const Text('Logout', style: AppTextStyles.button),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getRoleIcon(dynamic role) {
    if (role?.toString().contains('buyer') ?? false) return Icons.shopping_cart;
    if (role?.toString().contains('seller') ?? false) return Icons.store;
    if (role?.toString().contains('rider') ?? false) return Icons.delivery_dining;
    return Icons.person;
  }

  Widget _buildProfileCard(BuildContext context, List<Widget> children) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.white : Colors.black).withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey)),
      subtitle: Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
    );
  }
}
