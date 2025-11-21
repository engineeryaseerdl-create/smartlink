import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/product_model.dart';

class PersonalizedSection extends StatelessWidget {
  final String userName;
  final List<ProductModel> recentlyViewed;
  final List<ProductModel> recommended;
  final List<String> favorites;

  const PersonalizedSection({
    super.key,
    required this.userName,
    required this.recentlyViewed,
    required this.recommended,
    required this.favorites,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWelcomeCard(),
        const SizedBox(height: AppSpacing.lg),
        if (recentlyViewed.isNotEmpty) _buildRecentlyViewed(),
        const SizedBox(height: AppSpacing.lg),
        _buildRecommendations(),
        const SizedBox(height: AppSpacing.lg),
        _buildQuickActions(),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryGreen.withOpacity(0.1), Colors.white],
        ),
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppColors.primaryGreen.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, $userName!',
                  style: AppTextStyles.heading3.copyWith(color: AppColors.primaryGreen),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Discover products tailored just for you',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: AppColors.primaryGreen, size: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentlyViewed() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recently Viewed', style: AppTextStyles.heading3),
            TextButton(
              onPressed: () {},
              child: const Text('View All', style: TextStyle(color: AppColors.primaryGreen)),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recentlyViewed.length,
            itemBuilder: (context, index) {
              final product = recentlyViewed[index];
              return _buildQuickProductCard(product);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.auto_awesome, color: AppColors.gold, size: 20),
            SizedBox(width: AppSpacing.sm),
            Text('Recommended for You', style: AppTextStyles.heading3),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recommended.length,
            itemBuilder: (context, index) {
              final product = recommended[index];
              return _buildQuickProductCard(product);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickProductCard(ProductModel product) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppBorderRadius.md),
                ),
              ),
              child: const Center(
                child: Icon(Icons.image, color: AppColors.textSecondary),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '₦${product.price.toStringAsFixed(0)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Actions', style: AppTextStyles.heading3),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(child: _buildActionCard('Favorites', Icons.favorite, '${favorites.length} items')),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: _buildActionCard('Orders', Icons.shopping_bag, 'Track orders')),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(child: _buildActionCard('Wishlist', Icons.bookmark, 'Saved items')),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: _buildActionCard('Reviews', Icons.star, 'Rate products')),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: AppColors.backgroundLight),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 32),
          const SizedBox(height: AppSpacing.sm),
          Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  final String productId;
  final bool initialIsFavorite;
  final Function(bool) onToggle;

  const FavoriteButton({
    super.key,
    required this.productId,
    required this.initialIsFavorite,
    required this.onToggle,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late bool _isFavorite;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initialIsFavorite;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFavorite,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : AppColors.textSecondary,
              size: 24,
            ),
          );
        },
      ),
    );
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    _animationController.forward().then((_) => _animationController.reverse());
    widget.onToggle(_isFavorite);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorite ? 'Added to favorites' : 'Removed from favorites'),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
