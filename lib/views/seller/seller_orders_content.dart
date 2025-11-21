import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cluster_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/order_card.dart';
import '../../widgets/cluster_selector.dart';
import '../buyer/order_detail_screen.dart';

class SellerOrdersContent extends StatelessWidget {
  const SellerOrdersContent({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final clusterProvider = Provider.of<ClusterProvider>(context);
    final user = authProvider.currentUser;
    
    final myOrders = orderProvider.getOrdersForSeller(user?.id ?? '');
    final pendingOrders = myOrders.where((o) => o.riderId == null).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: ResponsiveUtils.getResponsivePagePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Orders',
                        style: ResponsiveUtils.isDesktop(context)
                          ? AppTextStyles.heading1
                          : AppTextStyles.heading2,
                      ),
                      if (pendingOrders.isNotEmpty)
                        ElevatedButton.icon(
                          onPressed: () => _showClusterSelector(context, clusterProvider),
                          icon: const Icon(Icons.group),
                          label: const Text('Assign Riders'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryOrange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: ResponsiveUtils.isDesktop(context) 
                    ? AppSpacing.xl : AppSpacing.lg),
                  if (pendingOrders.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.warningOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        border: Border.all(
                          color: AppColors.warningOrange.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.warningOrange,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              '${pendingOrders.length} order(s) need rider assignment',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.warningOrange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (pendingOrders.isNotEmpty)
                    const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
          
          if (myOrders.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: ResponsiveUtils.isDesktop(context) ? 120 : 80,
                      color: AppColors.grey,
                    ),
                    SizedBox(height: ResponsiveUtils.isDesktop(context) 
                      ? AppSpacing.lg : AppSpacing.md),
                    Text(
                      'No orders yet',
                      style: ResponsiveUtils.isDesktop(context)
                        ? AppTextStyles.heading3.copyWith(color: AppColors.grey)
                        : AppTextStyles.bodyLarge.copyWith(color: AppColors.grey),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Orders will appear here when customers purchase your products',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: ResponsiveUtils.getResponsivePagePadding(context),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final order = myOrders[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: OrderCard(
                        order: order,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailScreen(order: order),
                            ),
                          );
                        },
                        showSellerActions: true, // Show actions for seller
                      ),
                    );
                  },
                  childCount: myOrders.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showClusterSelector(BuildContext context, ClusterProvider clusterProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Select Rider Cluster',
                  style: AppTextStyles.heading3,
                ),
              ),
              Expanded(
                child: ClusterSelector(
                  scrollController: scrollController,
                  onClusterSelected: (cluster) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Contacted ${cluster.name} cluster'),
                        backgroundColor: AppColors.primaryOrange,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
