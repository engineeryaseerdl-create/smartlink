import 'package:flutter/foundation.dart';
import '../models/notification_model.dart';
import '../services/api_service.dart';

class NotificationProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  int _unreadCount = 0;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _unreadCount;

  Future<void> loadNotifications({bool unreadOnly = false}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.get('/notifications', queryParams: {
        if (unreadOnly) 'unreadOnly': 'true',
      });

      if (response['success']) {
        _notifications = (response['notifications'] as List)
            .map((json) => NotificationModel.fromJson(json))
            .toList();
        _unreadCount = response['unreadCount'] ?? 0;
      }
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(List<String> notificationIds) async {
    try {
      await _apiService.put('/notifications/read', data: {
        'notificationIds': notificationIds,
      });

      // Update local state
      for (final id in notificationIds) {
        final index = _notifications.indexWhere((n) => n.id == id);
        if (index != -1) {
          _notifications[index] = NotificationModel(
            id: _notifications[index].id,
            title: _notifications[index].title,
            message: _notifications[index].message,
            type: _notifications[index].type,
            isRead: true,
            createdAt: _notifications[index].createdAt,
            data: _notifications[index].data,
          );
        }
      }

      _unreadCount = _notifications.where((n) => !n.isRead).length;
      notifyListeners();
    } catch (e) {
      debugPrint('Error marking notifications as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _apiService.put('/notifications/read-all');

      // Update local state
      _notifications = _notifications.map((n) => NotificationModel(
        id: n.id,
        title: n.title,
        message: n.message,
        type: n.type,
        isRead: true,
        createdAt: n.createdAt,
        data: n.data,
      )).toList();

      _unreadCount = 0;
      notifyListeners();
    } catch (e) {
      debugPrint('Error marking all notifications as read: $e');
    }
  }

  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    if (!notification.isRead) {
      _unreadCount++;
    }
    notifyListeners();
  }
}