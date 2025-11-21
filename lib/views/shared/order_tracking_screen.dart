import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order_model.dart';
import '../../utils/constants.dart';
import '../../widgets/animated_widgets.dart';
import '../../widgets/responsive_wrapper.dart';
import '../../widgets/order_tracking_widget.dart';
import '../../providers/auth_provider.dart';
import '../buyer/rate_order_screen.dart';
import '../buyer/dispute_order_screen.dart';

class OrderTrackingScreen extends StatefulWidget {
  final OrderModel order;

  const OrderTrackingScreen({
    super.key,
    required this.order,
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.headerGradientStart,
                AppColors.headerGradientEnd,
              ],
            ),
          ),
        ),
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: ResponsiveContainer(
        child: SingleChildScrollView(
          padding: ResponsiveUtils.getResponsivePagePadding(context),
          child: FadeInWidget(
            slideUp: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Summary Card
                _buildOrderSummaryCard(),
                SizedBox(height: ResponsiveUtils.isDesktop(context) 
                  ? AppSpacing.xl : AppSpacing.lg),
                
                // Tracking Widget
                OrderTrackingWidget(
                  order: widget.order,
                  showFullHistory: true,
                ),
                
                SizedBox(height: ResponsiveUtils.isDesktop(context) 
                  ? AppSpacing.xl : AppSpacing.lg),
                
                // Delivery Info Card
                _buildDeliveryInfoCard(),
                
                if (widget.order.riderId != null) ...[
                  SizedBox(height: ResponsiveUtils.isDesktop(context) 
                    ? AppSpacing.xl : AppSpacing.lg),
                  _buildRiderInfoCard(),
                ],
                
                SizedBox(height: ResponsiveUtils.isDesktop(context) 
                  ? AppSpacing.xl : AppSpacing.lg),
                
                // Items Card
                _buildItemsCard(),
                
                // Action Buttons for Buyers
                if (_isBuyer() && widget.order.status == OrderStatus.delivered) ...[
                  SizedBox(height: ResponsiveUtils.isDesktop(context) 
                    ? AppSpacing.xl : AppSpacing.lg),
                  _buildActionButtons(),
                ],
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: widget.order.status == OrderStatus.inTransit
        ? PulsingWidget(
            child: FloatingActionButton.extended(
              onPressed: _callRider,
              icon: const Icon(Icons.phone),
              label: const Text('Call Rider'),
              backgroundColor: AppColors.primaryGreen,
            ),
          )
        : null,
    );
  }

  Widget _buildOrderSummaryCard() {
    return ScaleInWidget(
      child: Container(
        padding: EdgeInsets.all(ResponsiveUtils.isDesktop(context) 
          ? AppSpacing.lg : AppSpacing.md),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryGreen.withOpacity(0.1),
              AppColors.lightGreen.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          border: Border.all(
            color: AppColors.primaryGreen.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.shopping_bag,
                  color: AppColors.primaryGreen,
                  size: ResponsiveUtils.isDesktop(context) ? 28 : 24,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Order #${widget.order.id.substring(0, 8)}',
                    style: ResponsiveUtils.isDesktop(context)
                      ? AppTextStyles.heading2
                      : AppTextStyles.heading3,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    border: Border.all(
                      color: _getStatusColor(),
                    ),
                  ),
                  child: Text(
                    _getStatusText(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: _getStatusColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.isDesktop(context) 
              ? AppSpacing.md : AppSpacing.sm),
            
            if (ResponsiveUtils.isDesktop(context))
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryItem('Total', '₦${widget.order.totalAmount.toStringAsFixed(0)}'),
                  ),
                  Expanded(
                    child: _buildSummaryItem('Items', '${widget.order.items.length}'),
                  ),
                  Expanded(
                    child: _buildSummaryItem('Delivery', widget.order.deliveryType.toUpperCase()),
                  ),
                ],
              )
            else
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryItem('Total', '₦${widget.order.totalAmount.toStringAsFixed(0)}'),
                      ),
                      Expanded(
                        child: _buildSummaryItem('Items', '${widget.order.items.length}'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildSummaryItem('Delivery Type', widget.order.deliveryType.toUpperCase()),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.grey,
          ),
        ),
        Text(
          value,
          style: ResponsiveUtils.isDesktop(context)
            ? AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)
            : AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildDeliveryInfoCard() {
    return SlideInWidget(
      direction: SlideDirection.left,
      child: Container(
        padding: EdgeInsets.all(ResponsiveUtils.isDesktop(context) 
          ? AppSpacing.lg : AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppColors.primaryGreen,
                  size: ResponsiveUtils.isDesktop(context) ? 28 : 24,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Delivery Information',
                  style: ResponsiveUtils.isDesktop(context)
                    ? AppTextStyles.heading3
                    : AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.isDesktop(context) 
              ? AppSpacing.md : AppSpacing.sm),
            
            _buildInfoRow('From', widget.order.sellerLocation),
            const SizedBox(height: AppSpacing.sm),
            _buildInfoRow('To', widget.order.buyerLocation),
            const SizedBox(height: AppSpacing.sm),
            _buildInfoRow('Customer', widget.order.buyerName),
            const SizedBox(height: AppSpacing.sm),
            _buildInfoRow('Phone', widget.order.buyerPhone),
          ],
        ),
      ),
    );
  }

  Widget _buildRiderInfoCard() {
    return SlideInWidget(
      direction: SlideDirection.right,
      child: Container(
        padding: EdgeInsets.all(ResponsiveUtils.isDesktop(context) 
          ? AppSpacing.lg : AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.delivery_dining,
                  color: AppColors.primaryGreen,
                  size: ResponsiveUtils.isDesktop(context) ? 28 : 24,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Rider Information',
                  style: ResponsiveUtils.isDesktop(context)
                    ? AppTextStyles.heading3
                    : AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _callRider,
                  icon: const Icon(Icons.phone, size: 18),
                  label: const Text('Call'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.isDesktop(context) 
              ? AppSpacing.md : AppSpacing.sm),
            
            _buildInfoRow('Name', widget.order.riderName ?? 'Not assigned'),
            const SizedBox(height: AppSpacing.sm),
            _buildInfoRow('Delivery Type', widget.order.deliveryType.toUpperCase()),
            const SizedBox(height: AppSpacing.sm),
            _buildInfoRow('Status', _getStatusText()),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsCard() {
    return FadeInWidget(
      delay: const Duration(milliseconds: 600),
      child: Container(
        padding: EdgeInsets.all(ResponsiveUtils.isDesktop(context) 
          ? AppSpacing.lg : AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.inventory_2,
                  color: AppColors.primaryGreen,
                  size: ResponsiveUtils.isDesktop(context) ? 28 : 24,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Order Items',
                  style: ResponsiveUtils.isDesktop(context)
                    ? AppTextStyles.heading3
                    : AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.isDesktop(context) 
              ? AppSpacing.md : AppSpacing.sm),
            
            ...widget.order.items.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                      child: Image.network(
                        item.productImage,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 50,
                            color: AppColors.lightGrey,
                            child: const Icon(Icons.image),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productTitle,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Qty: ${item.quantity}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₦${(item.price * item.quantity).toStringAsFixed(0)}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: ResponsiveUtils.isDesktop(context) ? 120 : 80,
          child: Text(
            '$label:',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  bool _isBuyer() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return authProvider.currentUser?.role.toString().contains('buyer') ?? false;
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RateOrderScreen(order: widget.order),
                ),
              );
            },
            icon: const Icon(Icons.star),
            label: const Text('Rate Order'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DisputeOrderScreen(order: widget.order),
                ),
              );
            },
            icon: const Icon(Icons.report_problem),
            label: const Text('Report Issue'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.errorRed,
              side: const BorderSide(color: AppColors.errorRed),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (widget.order.status) {
      case OrderStatus.pending:
        return AppColors.warningOrange;
      case OrderStatus.confirmed:
        return AppColors.infoBlue;
      case OrderStatus.assigned:
        return AppColors.primaryGreen;
      case OrderStatus.pickedUp:
        return AppColors.primaryGreen;
      case OrderStatus.inTransit:
        return AppColors.primaryGreen;
      case OrderStatus.delivered:
        return AppColors.successGreen;
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

  String _getStatusText() {
    switch (widget.order.status) {
      case OrderStatus.pending:
        return 'Pending';
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

  void _callRider() {
    // Implement call functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Calling rider...'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }
}