import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/order_card.dart';
import '../shared/order_detail_screen.dart';

class RiderDeliveriesScreen extends StatefulWidget {
  const RiderDeliveriesScreen({super.key});

  @override
  State<RiderDeliveriesScreen> createState() => _RiderDeliveriesScreenState();
}

class _RiderDeliveriesScreenState extends State<RiderDeliveriesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<OrderProvider>().loadOrders(role: 'rider');
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final user = authProvider.currentUser;

    final myDeliveries = orderProvider.getOrdersForRider(user?.id ?? '');
    final activeDeliveries = myDeliveries.where((o) => 
      o.status != OrderStatus.delivered && o.status != OrderStatus.cancelled
    ).toList();
    final completedDeliveries = myDeliveries.where((o) => 
      o.status == OrderStatus.delivered
    ).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Deliveries'),
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDeliveryList(activeDeliveries, 'No active deliveries'),
            _buildDeliveryList(completedDeliveries, 'No completed deliveries'),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryList(List orders, String emptyMessage) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.delivery_dining, size: 80, color: AppColors.grey),
            const SizedBox(height: AppSpacing.md),
            Text(emptyMessage, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(
          order: order,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDetailScreen(order: order),
              ),
            );
          },
        );
      },
    );
  }
}