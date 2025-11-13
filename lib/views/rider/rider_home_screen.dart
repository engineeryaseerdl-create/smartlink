import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../models/order_model.dart';
import '../../widgets/custom_button.dart';
import '../shared/profile_screen.dart';

class RiderHomeScreen extends StatefulWidget {
  const RiderHomeScreen({super.key});

  @override
  State<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<OrderProvider>().loadOrders());
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildDeliveriesPage(),
      _buildEarningsPage(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.delivery_dining), label: 'Deliveries'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Earnings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildDeliveriesPage() {
    final authProvider = Provider.of<AuthProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final user = authProvider.currentUser;

    final deliveries = orderProvider.getOrdersForRider(user?.id ?? '');
    final activeDeliveries = deliveries
        .where((d) =>
            d.status != OrderStatus.delivered && d.status != OrderStatus.cancelled)
        .toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hello, ${Helpers.getFirstName(user?.name, 'Rider')}!',
                        style: AppTextStyles.heading2),
                    Text('Rider Dashboard',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.grey)),
                  ],
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delivery_dining, color: AppColors.white),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Active',
                    activeDeliveries.length.toString(),
                    Icons.local_shipping,
                    AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildStatCard(
                    'Completed',
                    deliveries
                        .where((d) => d.status == OrderStatus.delivered)
                        .length
                        .toString(),
                    Icons.done_all,
                    AppColors.successGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            const Text('Active Deliveries', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.md),
            if (activeDeliveries.isEmpty)
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.delivery_dining, size: 60, color: AppColors.grey),
                      const SizedBox(height: AppSpacing.md),
                      Text('No active deliveries',
                          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.grey)),
                    ],
                  ),
                ),
              )
            else
              ...activeDeliveries.map((delivery) => _buildDeliveryCard(delivery)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value, 
            style: AppTextStyles.bodyLarge.copyWith(
              color: color, 
              fontWeight: FontWeight.bold
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Text(
            label, 
            style: AppTextStyles.bodySmall.copyWith(color: color),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryCard(OrderModel delivery) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order #${delivery.id.length >= 8 ? delivery.id.substring(0, 8) : delivery.id}',
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.infoBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                ),
                child: Text(
                  delivery.status.toString().split('.').last,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.infoBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Icon(Icons.person, size: 16, color: AppColors.grey),
              const SizedBox(width: 4),
              Text(delivery.buyerName, style: AppTextStyles.bodyMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: AppColors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(delivery.buyerLocation,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (delivery.status == OrderStatus.pickupReady)
            CustomButton(
              text: 'Start Delivery',
              onPressed: () {
                context.read<OrderProvider>().updateOrderStatus(
                    delivery.id, OrderStatus.inTransit);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Delivery started!'),
                    backgroundColor: AppColors.successGreen,
                  ),
                );
              },
              width: double.infinity,
              height: 40,
            )
          else if (delivery.status == OrderStatus.inTransit)
            CustomButton(
              text: 'Mark as Delivered',
              onPressed: () {
                context.read<OrderProvider>().updateOrderStatus(
                    delivery.id, OrderStatus.delivered);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order delivered!'),
                    backgroundColor: AppColors.successGreen,
                  ),
                );
              },
              backgroundColor: AppColors.successGreen,
              width: double.infinity,
              height: 40,
            ),
        ],
      ),
    );
  }

  Widget _buildEarningsPage() {
    final authProvider = Provider.of<AuthProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final user = authProvider.currentUser;

    final deliveries = orderProvider.getOrdersForRider(user?.id ?? '');
    final completedDeliveries =
        deliveries.where((d) => d.status == OrderStatus.delivered).toList();
    final totalEarnings = completedDeliveries.length * 500.0;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Earnings', style: AppTextStyles.heading2),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryGreen, AppColors.darkGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Earnings',
                      style: TextStyle(color: AppColors.white, fontSize: 16)),
                  const SizedBox(height: AppSpacing.sm),
                  Text('₦${totalEarnings.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSpacing.sm),
                  Text('${completedDeliveries.length} completed deliveries',
                      style: const TextStyle(color: AppColors.white, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text('Recent Deliveries', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: completedDeliveries.isEmpty
                  ? Center(
                      child: Text('No completed deliveries yet',
                          style: AppTextStyles.bodyLarge
                              .copyWith(color: AppColors.grey)),
                    )
                  : ListView.builder(
                      itemCount: completedDeliveries.length,
                      itemBuilder: (context, index) {
                        final delivery = completedDeliveries[index];
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: AppColors.successGreen,
                            child: Icon(Icons.done, color: AppColors.white),
                          ),
                          title: Text('Order #${delivery.id.length >= 8 ? delivery.id.substring(0, 8) : delivery.id}'),
                          subtitle: Text(delivery.buyerLocation),
                          trailing: const Text('₦500',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryGreen)),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
