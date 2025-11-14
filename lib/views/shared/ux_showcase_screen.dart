import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/widget_exports.dart';

/// Showcase screen demonstrating all the enhanced UX features
class UXShowcaseScreen extends StatefulWidget {
  const UXShowcaseScreen({super.key});

  @override
  State<UXShowcaseScreen> createState() => _UXShowcaseScreenState();
}

class _UXShowcaseScreenState extends State<UXShowcaseScreen>
    with TickerProviderStateMixin {
  int _currentTabIndex = 0;
  bool _isConnected = true;
  bool _isLiked = false;
  bool _showSuccess = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<TabItem> _tabs = [
    const TabItem(label: 'Loading', icon: Icons.refresh),
    const TabItem(label: 'States', icon: Icons.sentiment_satisfied),
    const TabItem(label: 'Actions', icon: Icons.touch_app),
    const TabItem(label: 'Navigation', icon: Icons.navigation),
    const TabItem(label: 'Media', icon: Icons.image),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UX Showcase'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.wifi_off),
            onPressed: () {
              setState(() {
                _isConnected = !_isConnected;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Connection status indicator
          ConnectionStatusIndicator(
            isConnected: _isConnected,
            onRetry: () {
              setState(() {
                _isConnected = true;
              });
            },
          ),

          // Tab content
          Expanded(
            child: IndexedStack(
              index: _currentTabIndex,
              children: [
                _buildLoadingShowcase(),
                _buildStatesShowcase(),
                _buildActionsShowcase(),
                _buildNavigationShowcase(),
                _buildMediaShowcase(),
              ],
            ),
          ),

          // Custom animated tab bar
          AnimatedTabBar(
            tabs: _tabs,
            currentIndex: _currentTabIndex,
            onTabSelected: (index) {
              setState(() {
                _currentTabIndex = index;
              });
            },
          ),
        ],
      ),
      floatingActionButton: QuickActionButton(
        actions: [
          QuickAction(
            label: 'Add Product',
            icon: Icons.add_shopping_cart,
            backgroundColor: AppColors.primaryGreen,
            onPressed: () {
              _showSuccessAnimation();
            },
          ),
          QuickAction(
            label: 'Search',
            icon: Icons.search,
            backgroundColor: AppColors.infoBlue,
            onPressed: () {
              _showVoiceSearch();
            },
          ),
          QuickAction(
            label: 'Filter',
            icon: Icons.filter_list,
            backgroundColor: AppColors.warningOrange,
            onPressed: () {
              _showFilterBottomSheet();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingShowcase() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Loading States & Skeleton Screens', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.lg),

          // Enhanced shimmer loading
          Text('Enhanced Product Cards:', style: AppTextStyles.heading4),
          const SizedBox(height: AppSpacing.md),
          Container(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) => Container(
                width: 180,
                margin: const EdgeInsets.only(right: AppSpacing.md),
                child: const EnhancedProductCardSkeleton(
                  showPrice: true,
                  showRating: true,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Order skeletons
          Text('Order Card Skeletons:', style: AppTextStyles.heading4),
          const SizedBox(height: AppSpacing.md),
          const OrderCardSkeleton(),
          const SizedBox(height: AppSpacing.md),
          const OrderCardSkeleton(),

          const SizedBox(height: AppSpacing.xl),

          // Wave loading animation
          Text('Wave Loading Animation:', style: AppTextStyles.heading4),
          const SizedBox(height: AppSpacing.md),
          const Center(child: WaveLoadingIndicator()),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildStatesShowcase() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Enhanced States', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.lg),

          // Empty states
          Text('Enhanced Empty States:', style: AppTextStyles.heading4),
          const SizedBox(height: AppSpacing.md),
          Container(
            height: 350,
            child: PageView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: EnhancedEmptyCartWidget(
                    onShopNow: () {
                      _showSuccessSnackbar('Navigating to shop!');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: EnhancedEmptyOrdersWidget(
                    onBrowse: () {
                      _showSuccessSnackbar('Browsing products!');
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: EnhancedEmptyProductsWidget(),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Error states
          Text('Error States:', style: AppTextStyles.heading4),
          const SizedBox(height: AppSpacing.md),
          EnhancedInlineErrorWidget(
            message: 'Failed to load products. Please check your connection.',
            onAction: () {
              _showSuccessSnackbar('Retrying...');
            },
            actionText: 'Retry',
            onDismiss: () {
              _showSuccessSnackbar('Error dismissed');
            },
          ),

          const SizedBox(height: AppSpacing.md),

          // Success notification
          EnhancedSuccessWidget(
            message: 'Product added to cart successfully!',
            onAction: () {
              _showSuccessSnackbar('Viewing cart...');
            },
            actionText: 'View Cart',
          ),

          const SizedBox(height: AppSpacing.xl),

          // Status indicators
          Text('Status Indicators:', style: AppTextStyles.heading4),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: OrderStatus.values.map((status) => StatusIndicator(
              status: status,
              animated: true,
            )).toList(),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildActionsShowcase() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Interactive Actions', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.lg),

          // Swipe actions
          Text('Swipe to Delete:', style: AppTextStyles.heading4),
          const SizedBox(height: AppSpacing.md),
          SwipeToDeleteWidget(
            onDelete: () {
              _showSuccessSnackbar('Item deleted!');
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shopping_bag),
                  const SizedBox(width: AppSpacing.md),
                  const Expanded(
                    child: Text('Swipe left to delete this item'),
                  ),
                  HeartAnimation(
                    isLiked: _isLiked,
                    onToggle: () {
                      setState(() {
                        _isLiked = !_isLiked;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Success animations
          Text('Success Animations:', style: AppTextStyles.heading4),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            child: Center(
              child: Column(
                children: [
                  if (_showSuccess)
                    Container(
                      height: 200,
                      child: const SuccessAnimationWidget(
                        title: 'Order Placed!',
                        subtitle: 'Your order has been confirmed',
                        showConfetti: true,
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: _showSuccessAnimation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Trigger Success Animation'),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Button animations
          Text('Button Micro-interactions:', style: AppTextStyles.heading4),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            alignment: WrapAlignment.spaceEvenly,
            children: [
              ButtonPressAnimation(
                onPressed: () {
                  _showSuccessSnackbar('Button pressed!');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: const Text(
                    'Press Me',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              RippleAnimation(
                onTap: () {
                  _showSuccessSnackbar('Ripple effect!');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.infoBlue,
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: const Text(
                    'Ripple',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildNavigationShowcase() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Navigation Elements', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.lg),

          // Breadcrumbs
          Text('Breadcrumb Navigation:', style: AppTextStyles.heading4),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            child: BreadcrumbNavigation(
              items: [
                BreadcrumbItem(
                  title: 'Home',
                  icon: Icons.home,
                  onTap: () => _showSuccessSnackbar('Home tapped'),
                ),
                BreadcrumbItem(
                  title: 'Electronics',
                  onTap: () => _showSuccessSnackbar('Electronics tapped'),
                ),
                BreadcrumbItem(
                  title: 'Smartphones',
                  onTap: () => _showSuccessSnackbar('Smartphones tapped'),
                ),
                const BreadcrumbItem(
                  title: 'iPhone 15',
                  isActive: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Progress tracking
          Text('Order Progress:', style: AppTextStyles.heading4),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: StatusProgressBar(
              steps: [
                const ProgressStep(
                  label: 'Order Placed',
                  icon: Icons.check_circle,
                ),
                const ProgressStep(
                  label: 'Processing',
                  icon: Icons.settings,
                ),
                const ProgressStep(
                  label: 'Shipped',
                  icon: Icons.local_shipping,
                ),
                const ProgressStep(
                  label: 'Delivered',
                  icon: Icons.home,
                ),
              ],
              currentStep: 2,
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Delivery tracking
          Text('Delivery Tracking:', style: AppTextStyles.heading4),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 400),
            child: SingleChildScrollView(
              child: DeliveryTrackingWidget(
                estimatedDelivery: 'Today, 3:00 PM',
                events: [
                  TrackingEvent(
                    title: 'Order Confirmed',
                    description: 'Your order has been received',
                    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
                    isCompleted: true,
                  ),
                  TrackingEvent(
                    title: 'Package Prepared',
                    description: 'Items are being packaged',
                    timestamp: DateTime.now().subtract(const Duration(hours: 1)),
                    isCompleted: true,
                  ),
                  TrackingEvent(
                    title: 'Out for Delivery',
                    description: 'Package is on its way',
                    timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
                    isCompleted: true,
                  ),
                  const TrackingEvent(
                    title: 'Delivered',
                    description: 'Package delivered',
                    isCompleted: false,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Stepper navigation
          Text('Multi-step Process:', style: AppTextStyles.heading4),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            child: StepperNavigation(
              steps: const [
                StepItem(title: 'Cart'),
                StepItem(title: 'Shipping'),
                StepItem(title: 'Payment'),
                StepItem(title: 'Confirmation'),
              ],
              currentStep: 1,
              onStepTapped: (index) {
                _showSuccessSnackbar('Step ${index + 1} tapped');
              },
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildMediaShowcase() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Media & Input', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.lg),

          // Voice search
          Text('Voice Search:', style: AppTextStyles.heading4),
          const SizedBox(height: AppSpacing.md),
          VoiceSearchField(
            controller: _searchController,
            hintText: 'Search products...',
            onSearch: (query) {
              setState(() {
                _searchQuery = query;
              });
              _showSuccessSnackbar('Searching for: $query');
            },
            onVoiceResult: (result) {
              _showSuccessSnackbar('Voice result: $result');
            },
          ),

          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text('Search Results for: "$_searchQuery"'),
            const SizedBox(height: AppSpacing.sm),
            const SearchResultsSkeleton(itemCount: 3),
          ],

          const SizedBox(height: AppSpacing.xl),

          // Progressive image loading
          Text('Progressive Image Loading:', style: AppTextStyles.heading4),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            child: ProductImageGallery(
              images: [
                'https://picsum.photos/400/300?random=1',
                'https://picsum.photos/400/300?random=2',
                'https://picsum.photos/400/300?random=3',
              ],
              height: 250,
              onImageChanged: (index) {
                _showSuccessSnackbar('Image ${index + 1} selected');
              },
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Avatar examples
          Text('Optimized Avatars:', style: AppTextStyles.heading4),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.md,
            alignment: WrapAlignment.spaceEvenly,
            children: [
              const OptimizedAvatar(
                name: 'John Doe',
                size: 60,
              ),
              const OptimizedAvatar(
                imageUrl: 'https://picsum.photos/100/100?random=4',
                name: 'Jane Smith',
                size: 60,
              ),
              OptimizedAvatar(
                name: 'Bob Wilson',
                size: 60,
                backgroundColor: AppColors.infoBlue.withOpacity(0.1),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // Horizontal scroll picker
          Text('Horizontal Picker:', style: AppTextStyles.heading4),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            child: HorizontalScrollPicker(
              items: ['Small', 'Medium', 'Large', 'X-Large', 'XX-Large'],
              selectedItem: 'Medium',
              onItemSelected: (item) {
                _showSuccessSnackbar('Selected: $item');
              },
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  void _showSuccessAnimation() {
    setState(() {
      _showSuccess = true;
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showSuccess = false;
        });
      }
    });
  }

  void _showSuccessSnackbar(String message) {
    FloatingNotification.showSuccess(context, message);
  }

  void _showVoiceSearch() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 400,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppBorderRadius.xl),
            topRight: Radius.circular(AppBorderRadius.xl),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: VoiceInputWidget(
            onTextReceived: (text) {
              Navigator.pop(context);
              setState(() {
                _searchController.text = text;
                _searchQuery = text;
              });
              _showSuccessSnackbar('Voice search: $text');
            },
            hint: 'Say something to search',
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    EnhancedBottomSheet.show(
      context: context,
      child: FilterBottomSheet(
        currentFilters: const {},
        onApplyFilters: (filters) {
          _showSuccessSnackbar('Filters applied: ${filters.keys.join(', ')}');
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}