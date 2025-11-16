import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/notification_model.dart';

class NotificationBellWidget extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onTap;

  const NotificationBellWidget({
    super.key,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Badge(
          label: Text('$unreadCount'),
          isLabelVisible: unreadCount > 0,
          backgroundColor: AppColors.errorRed,
          child: const Icon(
            Icons.notifications_outlined,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class NotificationListWidget extends StatelessWidget {
  final List<NotificationModel> notifications;
  final Function(String) onMarkAsRead;
  final VoidCallback onMarkAllAsRead;
  final bool isLoading;

  const NotificationListWidget({
    super.key,
    required this.notifications,
    required this.onMarkAsRead,
    required this.onMarkAllAsRead,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (notifications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: AppColors.textSecondary),
            SizedBox(height: AppSpacing.md),
            Text('No notifications yet', style: AppTextStyles.bodyLarge),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Mark All as Read Button
        if (notifications.any((n) => !n.isRead))
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onMarkAllAsRead,
                child: const Text('Mark All as Read'),
              ),
            ),
          ),
        
        // Notifications List
        Expanded(
          child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return NotificationTile(
                notification: notification,
                onTap: () => onMarkAsRead(notification.id),
              );
            },
          ),
        ),
      ],
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.transparent : AppColors.primaryGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: notification.isRead ? AppColors.borderLight : AppColors.primaryGreen.withOpacity(0.3),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getNotificationColor(notification.type),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          notification.title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(notification.createdAt),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        trailing: notification.isRead
            ? null
            : Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                ),
              ),
        onTap: onTap,
      ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'order_update':
        return AppColors.primaryGreen;
      case 'new_order':
        return Colors.blue;
      case 'payment':
        return AppColors.gold;
      case 'review':
        return Colors.orange;
      case 'system':
        return Colors.grey;
      case 'promotion':
        return Colors.purple;
      default:
        return AppColors.primaryGreen;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'order_update':
        return Icons.shopping_bag;
      case 'new_order':
        return Icons.add_shopping_cart;
      case 'payment':
        return Icons.payment;
      case 'review':
        return Icons.star;
      case 'system':
        return Icons.info;
      case 'promotion':
        return Icons.local_offer;
      default:
        return Icons.notifications;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}