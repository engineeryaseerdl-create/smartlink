import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/rider_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/order_card.dart';
import '../../widgets/cluster_selector.dart';
import '../../models/order_model.dart';

class SellerOrdersScreen extends StatefulWidget {
  const SellerOrdersScreen({super.key});

  @override
  State<SellerOrdersScreen> createState() => _SellerOrdersScreenState();
}

class _SellerOrdersScreenState extends State<SellerOrdersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<OrderProvider>().loadOrders(role: 'seller');
      context.read<RiderProvider>().loadRiders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final user = authProvider.currentUser;

    final orders = orderProvider.getOrdersForSeller(user?.id ?? '');

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('My Orders', style: AppTextStyles.heading2),
            const SizedBox(height: AppSpacing.lg),
            if (orderProvider.isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (orders.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_bag_outlined,
                          size: 80, color: AppColors.grey),
                      const SizedBox(height: AppSpacing.md),
                      Text('No orders yet',
                          style: AppTextStyles.bodyLarge
                              .copyWith(color: AppColors.grey)),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return OrderCard(
                      order: order,
                      isSellerView: true,
                      onTap: () {},
                      showSellerActions: true,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showAssignRiderDialog(BuildContext context, OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ClusterSelector(order: order),
      ),
    );
  }
}
