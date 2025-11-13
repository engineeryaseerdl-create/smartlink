import 'package:intl/intl.dart';

class Helpers {
  static String formatCurrency(double amount) {
    final formatter = NumberFormat('#,###');
    return '₦${formatter.format(amount)}';
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy hh:mm a').format(dateTime);
  }

  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${difference.inDays / 365 > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${difference.inDays / 30 > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  static String getOrderStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'pickupReady':
        return 'Pickup Ready';
      case 'inTransit':
        return 'In Transit';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  static String getCategoryName(String category) {
    switch (category) {
      case 'groceries':
        return 'Groceries';
      case 'electronics':
        return 'Electronics';
      case 'cars':
        return 'Cars';
      case 'phones':
        return 'Phones';
      case 'appliances':
        return 'Appliances';
      case 'fashion':
        return 'Fashion';
      case 'furniture':
        return 'Furniture';
      default:
        return 'Other';
    }
  }

  static String getFirstName(String? fullName, String defaultName) {
    if (fullName == null || fullName.isEmpty) return defaultName;
    final parts = fullName.split(' ');
    return parts.isNotEmpty ? parts.first : defaultName;
  }
}
