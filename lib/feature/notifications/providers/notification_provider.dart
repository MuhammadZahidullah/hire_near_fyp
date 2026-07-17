import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/notifications/models/notifications_model.dart';

class NotificationProvider extends ChangeNotifier {
  // State
  List<NotificationModel> _notifications = [];
  NotificationProvider() {
    _notifications = [
      NotificationModel(
        id: 1,
        title: 'Booking Confirmed',
        message: 'Your booking with Usman Ali is confirmed',
        type: 'booking',
        time: DateTime.now().subtract(Duration(hours: 1)),
        isRead: false,
      ),
      NotificationModel(
        id: 2,
        title: 'Worker Nearby',
        message: 'Hamza Khan is 2.5 KM away from you',
        type: 'general',
        time: DateTime.now().subtract(Duration(hours: 2)),
        isRead: false,
      ),
      NotificationModel(
        id: 3,
        title: 'Booking Cancelled',
        message: 'Your booking has been cancelled',
        type: 'cancel',
        time: DateTime.now().subtract(Duration(hours: 3)),
        isRead: true,
      ),
    ];
  }
  // Getters
  List<NotificationModel> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  bool get hasUnread => unreadCount > 0;

  // Methods
  void addNotification(String title, String message, String type) {
    _notifications.insert(
      0, // ← insert at top
      NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        message: message,
        type: type,
        time: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void markAsRead(int id) {
    int index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    _notifications = _notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }
}
