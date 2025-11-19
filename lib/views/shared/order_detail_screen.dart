import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/order_management_widget.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderModel order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late OrderModel currentOrder;

  @override
  void initState() {
    super.initState();
    currentOrder = widget.order;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    final isSellerView = user?.role.toString().split('.').last == 'seller';
    final isRiderView = user?.role.toString().split('.').last == 'rider';

    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${currentOrder.id.substring(0, 8)}'),
        backgroundColor: AppColors.primaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          // Get updated order from provider
          final updatedOrder = orderProvider.getOrderById(currentOrder.id);
          if (updatedOrder != null) {
            currentOrder = updatedOrder;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderSummary(),
                const SizedBox(height: AppSpacing.lg),
                _buildOrderItems(),
                const SizedBox(height: AppSpacing.lg),
                _buildDeliveryInfo(),
                const SizedBox(height: AppSpacing.lg),
                if (isSellerView || isRiderView)
                  OrderManagementWidget(
                    order: currentOrder,
                    isSellerView: isSellerView,
                  ),
                const SizedBox(height: AppSpacing.lg),
                _buildOrderTimeline(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Order Summary', style: AppTextStyles.heading4),
            const SizedBox(height: AppSpacing.md),
            _buildSummaryRow('Order ID', '#${currentOrder.id.substring(0, 8)}'),
            _buildSummaryRow('Date', _formatDate(currentOrder.createdAt)),
            _buildSummaryRow('Status', _getStatusText(currentOrder.status)),
            _buildSummaryRow('Total Amount', '₦${currentOrder.totalAmount.toStringAsFixed(2)}'),
            if (currentOrder.riderId != null)
              _buildSummaryRow('Rider', currentOrder.riderId ?? 'Not assigned'),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey)),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildOrderItems() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Order Items', style: AppTextStyles.heading4),
            const SizedBox(height: AppSpacing.md),
            ...currentOrder.items.map((item) => _buildOrderItem(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            ),
            child: item.productImage.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                    child: Image.network(
                      item.productImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
                    ),
                  )
                : const Icon(Icons.image),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productTitle, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                Text('Quantity: ${item.quantity}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey)),
              ],
            ),
          ),
          Text('₦${(item.price * item.quantity).toStringAsFixed(2)}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Delivery Information', style: AppTextStyles.heading4),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.person, color: AppColors.grey),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Customer', style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey)),
                      Text(currentOrder.buyerName, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                      Text(currentOrder.buyerPhone, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, color: AppColors.grey),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Delivery Address', style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey)),
                      Text(currentOrder.buyerLocation, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTimeline() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Order Timeline', style: AppTextStyles.heading4),
            const SizedBox(height: AppSpacing.md),
            _buildTimelineItem('Order Placed', currentOrder.createdAt, true),
            if (_isStatusReached(OrderStatus.confirmed))
              _buildTimelineItem('Order Confirmed', currentOrder.createdAt, true),
            if (_isStatusReached(OrderStatus.pickupReady))
              _buildTimelineItem('Ready for Pickup', currentOrder.createdAt, true),
            if (_isStatusReached(OrderStatus.inTransit))
              _buildTimelineItem('In Transit', currentOrder.createdAt, true),
            if (_isStatusReached(OrderStatus.delivered))
              _buildTimelineItem('Delivered', currentOrder.createdAt, true),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String title, DateTime time, bool isCompleted) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.successGreen : AppColors.grey.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 12)
                : null,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                Text(_formatDate(time), style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isStatusReached(OrderStatus status) {
    final statusOrder = [
      OrderStatus.pending,
      OrderStatus.confirmed,
      OrderStatus.pickupReady,
      OrderStatus.inTransit,
      OrderStatus.delivered,
    ];
    
    final currentIndex = statusOrder.indexOf(currentOrder.status);
    final targetIndex = statusOrder.indexOf(status);
    
    return currentIndex >= targetIndex;
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.pickupReady:
        return 'Ready for Pickup';
      case OrderStatus.inTransit:
        return 'In Transit';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.modification_requested:
        return 'Modification Requested';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}