import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../utils/constants.dart';

class NotificationService {
  static void showOrderNotification(
    BuildContext context,
    String title,
    String message, {
    Color? backgroundColor,
    IconData? icon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor ?? AppColors.primaryOrange,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
      ),
    );
  }

  static void showOrderStatusUpdate(
    BuildContext context,
    OrderModel order,
    OrderStatus newStatus,
  ) {
    String title;
    String message;
    IconData icon;
    Color backgroundColor;

    switch (newStatus) {
      case OrderStatus.confirmed:
        title = 'Order Confirmed';
        message = 'Your order #${order.id.substring(0, 8)} has been confirmed';
        icon = Icons.check_circle;
        backgroundColor = AppColors.successGreen;
        break;
      case OrderStatus.pickupReady:
        title = 'Order Ready';
        message = 'Your order is ready for pickup';
        icon = Icons.inventory;
        backgroundColor = AppColors.primaryOrange;
        break;
      case OrderStatus.inTransit:
        title = 'Order In Transit';
        message = 'Your order is on the way to you';
        icon = Icons.directions_bike;
        backgroundColor = AppColors.mutedGreen;
        break;
      case OrderStatus.delivered:
        title = 'Order Delivered';
        message = 'Your order has been delivered successfully';
        icon = Icons.check_circle;
        backgroundColor = AppColors.successGreen;
        break;
      case OrderStatus.cancelled:
        title = 'Order Cancelled';
        message = 'Your order has been cancelled';
        icon = Icons.cancel;
        backgroundColor = AppColors.errorRed;
        break;
      default:
        title = 'Order Updated';
        message = 'Your order status has been updated';
        icon = Icons.info;
        backgroundColor = AppColors.primaryOrange;
    }

    showOrderNotification(
      context,
      title,
      message,
      backgroundColor: backgroundColor,
      icon: icon,
    );
  }

  static void showRiderAssignmentNotification(
    BuildContext context,
    String riderName,
  ) {
    showOrderNotification(
      context,
      'New Delivery Assignment',
      'You have been assigned to deliver an order',
      backgroundColor: AppColors.infoBlue,
      icon: Icons.assignment,
    );
  }

  static void showNewOrderNotification(
    BuildContext context,
    OrderModel order,
  ) {
    showOrderNotification(
      context,
      'New Order Received',
      'Order #${order.id.substring(0, 8)} from ${order.buyerName}',
      backgroundColor: AppColors.primaryOrange,
      icon: Icons.shopping_bag,
    );
  }
}