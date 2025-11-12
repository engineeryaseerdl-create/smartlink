import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/rider_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/order_card.dart';
import '../../models/order_model.dart';
import '../buyer/order_detail_screen.dart';

class SellerOrdersScreen extends StatefulWidget {
  const SellerOrdersScreen({super.key});

  @override
  State<SellerOrdersScreen> createState() => _SellerOrdersScreenState();
}

class _SellerOrdersScreenState extends State<SellerOrdersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<RiderProvider>().loadRiders());
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
                      onTap: () {
                        if (order.status == OrderStatus.pending) {
                          _showAssignRiderDialog(context, order);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetailScreen(order: order),
                            ),
                          );
                        }
                      },
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
    final riderProvider = Provider.of<RiderProvider>(context, listen: false);
    final availableRiders = riderProvider.getAvailableRiders();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assign Rider'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select a rider to deliver this order:'),
            const SizedBox(height: AppSpacing.md),
            if (availableRiders.isEmpty)
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: const Text(
                  'No available riders at the moment. Please try again later.',
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...availableRiders.map((rider) => ListTile(
                  leading: CircleAvatar(
                    child: Text(rider.name.isNotEmpty ? rider.name[0] : '?'),
                  ),
                  title: Text(rider.name),
                  subtitle:
                      Text('${rider.vehicleType.toString().split('.').last.toUpperCase()} - ${rider.vehiclePlate}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: AppColors.gold, size: 16),
                      Text(' ${rider.rating}'),
                    ],
                  ),
                  onTap: () {
                    context
                        .read<OrderProvider>()
                        .assignRider(order.id, rider.id, rider.name);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Rider ${rider.name} assigned'),
                        backgroundColor: AppColors.successGreen,
                      ),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}
