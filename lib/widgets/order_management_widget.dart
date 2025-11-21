import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order_model.dart';
import '../models/rider_model.dart';
import '../providers/order_provider.dart';
import '../providers/rider_provider.dart';
import '../utils/constants.dart';

class OrderManagementWidget extends StatefulWidget {
  final OrderModel order;
  final bool isSellerView;

  const OrderManagementWidget({
    super.key,
    required this.order,
    this.isSellerView = false,
  });

  @override
  State<OrderManagementWidget> createState() => _OrderManagementWidgetState();
}

class _OrderManagementWidgetState extends State<OrderManagementWidget> {
  bool _isUpdating = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(),
            const SizedBox(height: AppSpacing.md),
            _buildOrderStatus(),
            const SizedBox(height: AppSpacing.md),
            if (widget.isSellerView) _buildSellerActions(),
            if (!widget.isSellerView) _buildRiderActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order #${widget.order.id.substring(0, 8)}',
              style: AppTextStyles.heading5,
            ),
            Text(
              widget.order.buyerName,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey),
            ),
          ],
        ),
        Text(
          '₦${widget.order.totalAmount.toStringAsFixed(2)}',
          style: AppTextStyles.heading5.copyWith(color: AppColors.primaryOrange),
        ),
      ],
    );
  }

  Widget _buildOrderStatus() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        border: Border.all(color: _getStatusColor().withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(_getStatusIcon(), color: _getStatusColor(), size: 20),
          const SizedBox(width: AppSpacing.sm),
          Text(
            _getStatusText(),
            style: AppTextStyles.bodyMedium.copyWith(
              color: _getStatusColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerActions() {
    switch (widget.order.status) {
      case OrderStatus.pending:
        return _buildConfirmOrderButton();
      case OrderStatus.confirmed:
        return _buildAssignRiderButton();
      case OrderStatus.assigned:
        return _buildTrackingInfo();
      case OrderStatus.modification_requested:
        return _buildConfirmOrderButton();
      default:
        return _buildTrackingInfo();
    }
  }

  Widget _buildRiderActions() {
    if (widget.order.riderId == null) return const SizedBox.shrink();
    
    switch (widget.order.status) {
      case OrderStatus.assigned:
        return _buildPickupButton();
      case OrderStatus.inTransit:
        return _buildDeliveredButton();
      case OrderStatus.modification_requested:
        return _buildTrackingInfo();
      default:
        return _buildTrackingInfo();
    }
  }

  Widget _buildConfirmOrderButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isUpdating ? null : () => _updateOrderStatus(OrderStatus.confirmed),
        icon: const Icon(Icons.check_circle),
        label: const Text('Confirm Order'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.successGreen,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAssignRiderButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isUpdating ? null : () => _showRiderSelection(),
        icon: const Icon(Icons.delivery_dining),
        label: const Text('Assign Rider'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildMarkReadyButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isUpdating ? null : () => _updateOrderStatus(OrderStatus.assigned),
        icon: const Icon(Icons.inventory),
        label: const Text('Mark as Ready'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.infoBlue,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPickupButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isUpdating ? null : () => _updateOrderStatus(OrderStatus.inTransit),
        icon: const Icon(Icons.local_shipping),
        label: const Text('Mark as Picked Up'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.warningOrange,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInTransitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isUpdating ? null : () => _updateOrderStatus(OrderStatus.inTransit),
        icon: const Icon(Icons.directions_bike),
        label: const Text('Start Delivery'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDeliveredButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isUpdating ? null : () => _updateOrderStatus(OrderStatus.delivered),
        icon: const Icon(Icons.check_circle),
        label: const Text('Mark as Delivered'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.successGreen,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTrackingInfo() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.grey),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              _getTrackingMessage(),
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey),
            ),
          ),
        ],
      ),
    );
  }

  void _showRiderSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
              child: Text('Select Rider', style: AppTextStyles.heading3),
            ),
            Expanded(
              child: Consumer<RiderProvider>(
                builder: (context, riderProvider, child) {
                  final availableRiders = riderProvider.getAvailableRiders();
                  
                  if (availableRiders.isEmpty) {
                    return const Center(
                      child: Text('No available riders'),
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: availableRiders.length,
                    itemBuilder: (context, index) {
                      final rider = availableRiders[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primaryOrange,
                          child: Text(rider.name[0]),
                        ),
                        title: Text(rider.name),
                        subtitle: Text('${rider.vehicleType} • ${rider.location}'),
                        trailing: Text('⭐ ${rider.rating.toStringAsFixed(1)}'),
                        onTap: () => _assignRider(rider),
                      );
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

  Future<void> _assignRider(RiderModel rider) async {
    Navigator.pop(context);
    setState(() => _isUpdating = true);
    
    try {
      await context.read<OrderProvider>().assignRider(
        widget.order.id, 
        rider.id, 
        context: context,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to assign rider: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  Future<void> _updateOrderStatus(OrderStatus newStatus) async {
    setState(() => _isUpdating = true);
    
    try {
      await context.read<OrderProvider>().updateOrderStatus(
        widget.order.id,
        newStatus.toString().split('.').last,
        context: context,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update status: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  Color _getStatusColor() {
    switch (widget.order.status) {
      case OrderStatus.pending:
        return AppColors.warningOrange;
      case OrderStatus.confirmed:
      case OrderStatus.assigned:
      case OrderStatus.pickedUp:
      case OrderStatus.inTransit:
        return AppColors.primaryOrange;
      case OrderStatus.delivered:
      case OrderStatus.completed:
        return AppColors.successGreen;
      case OrderStatus.refunded:
        return AppColors.warningOrange;
      case OrderStatus.cancelled:
        return AppColors.errorRed;
      case OrderStatus.modification_requested:
        return AppColors.warningOrange;
    }
  }

  IconData _getStatusIcon() {
    switch (widget.order.status) {
      case OrderStatus.pending:
        return Icons.pending;
      case OrderStatus.confirmed:
        return Icons.check_circle;
      case OrderStatus.assigned:
        return Icons.inventory;
      case OrderStatus.pickedUp:
        return Icons.local_shipping;
      case OrderStatus.inTransit:
        return Icons.directions_bike;
      case OrderStatus.delivered:
        return Icons.check_circle;
      case OrderStatus.completed:
        return Icons.check_circle_outline;
      case OrderStatus.refunded:
        return Icons.money_off;
      case OrderStatus.cancelled:
        return Icons.cancel;
      case OrderStatus.modification_requested:
        return Icons.edit;
    }
  }

  String _getStatusText() {
    switch (widget.order.status) {
      case OrderStatus.pending:
        return 'Pending Confirmation';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.assigned:
        return 'Assigned to Rider';
      case OrderStatus.pickedUp:
        return 'Picked Up';
      case OrderStatus.inTransit:
        return 'In Transit';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.refunded:
        return 'Refunded';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.modification_requested:
        return 'Modification Requested';
    }
  }

  String _getTrackingMessage() {
    switch (widget.order.status) {
      case OrderStatus.delivered:
        return 'Order has been delivered successfully';
      case OrderStatus.cancelled:
        return 'Order has been cancelled';
      default:
        return 'Order is being processed';
    }
  }
}
