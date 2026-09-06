import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/notifications/models/notifications_model.dart';

class NotificationProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<NotificationModel> _notifications = [];
  StreamSubscription<QuerySnapshot>? _subscription;
  StreamSubscription<User?>? _authSubscription;
  bool _isLoading = false;
  String? _errorMessage;

  NotificationProvider() {
    _listenToAuthChanges();
  }

  // Getters
  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  bool get hasUnread => unreadCount > 0;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _listenToAuthChanges() {
    // Check current auth user immediately
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      _initNotificationsListener(currentUser.uid);
    }

    // Listen to auth state changes
    _authSubscription = _auth.authStateChanges().listen((user) {
      if (user != null) {
        _initNotificationsListener(user.uid);
      } else {
        _subscription?.cancel();
        _subscription = null;
        _notifications.clear();
        notifyListeners();
      }
    });
  }

  void _initNotificationsListener(String userId) {
    _subscription?.cancel();
    _isLoading = true;
    _errorMessage = null;

    _subscription = _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen(
      (snapshot) {
        try {
          _notifications = snapshot.docs.map((doc) {
            return NotificationModel.fromFirestore(doc);
          }).toList();

          // Sort in-memory by createdAt descending
          _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          _isLoading = false;
          _errorMessage = null;
          notifyListeners();
        } catch (e) {
          debugPrint("Notification parse error: $e");
          _isLoading = false;
          notifyListeners();
        }
      },
      onError: (error) {
        debugPrint("Notification stream error: $error");
        _isLoading = false;
        _errorMessage = error.toString();
        notifyListeners();
      },
    );
  }

  Future<void> loadNotifications() async {
    final targetUid = _auth.currentUser?.uid;
    if (targetUid == null || targetUid.isEmpty) {
      _notifications.clear();
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final snapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: targetUid)
          .get();

      _notifications = snapshot.docs.map((doc) {
        return NotificationModel.fromFirestore(doc);
      }).toList();

      _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      debugPrint("Load notifications error: $e");
      notifyListeners();
    }
  }


  // Create notification in Firestore
  Future<void> addNotification(
    String title,
    String message,
    String type, {
    String? userId,
    String? bookingId,
  }) async {
    try {
      final recipientUid = userId ?? _auth.currentUser?.uid;
      if (recipientUid == null || recipientUid.isEmpty) {
        debugPrint("Cannot add notification: No recipient userId");
        return;
      }

      await sendNotification(
        userId: recipientUid,
        title: title,
        message: message,
        type: type,
        bookingId: bookingId,
      );
    } catch (e) {
      debugPrint("Add Notification Error: $e");
    }
  }

  // Static helper to create notification from any context/provider
  static Future<void> sendNotification({
    required String userId,
    required String title,
    required String message,
    required String type,
    String? bookingId,
  }) async {
    if (userId.trim().isEmpty) return;

    try {
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': userId.trim(),
        'title': title,
        'message': message,
        'type': type,
        if (bookingId != null) 'bookingId': bookingId,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
      debugPrint("Notification created in Firestore for user: $userId");
    } catch (e) {
      debugPrint("Send Notification Error: $e");
    }
  }

  // Mark single notification as read
  Future<void> markAsRead(dynamic id) async {
    final docId = id.toString();
    try {
      final index = _notifications.indexWhere((n) => n.id == docId);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
        notifyListeners();
      }

      if (docId.isNotEmpty) {
        await _firestore.collection('notifications').doc(docId).update({
          'isRead': true,
        });
      }
    } catch (e) {
      debugPrint("Mark Notification As Read Error: $e");
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final unreadDocs =
          _notifications.where((n) => !n.isRead && n.id.isNotEmpty).toList();

      if (unreadDocs.isEmpty) return;

      _notifications =
          _notifications.map((n) => n.copyWith(isRead: true)).toList();
      notifyListeners();

      final batch = _firestore.batch();
      for (final notif in unreadDocs) {
        batch.update(_firestore.collection('notifications').doc(notif.id), {
          'isRead': true,
        });
      }
      await batch.commit();
    } catch (e) {
      debugPrint("Mark All Notifications As Read Error: $e");
    }
  }

  // Clear all notifications
  Future<void> clearAll() async {
    try {
      final docsToDelete = List<NotificationModel>.from(_notifications);
      _notifications.clear();
      notifyListeners();

      final batch = _firestore.batch();
      for (final notif in docsToDelete) {
        if (notif.id.isNotEmpty) {
          batch.delete(_firestore.collection('notifications').doc(notif.id));
        }
      }
      await batch.commit();
    } catch (e) {
      debugPrint("Clear Notifications Error: $e");
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }
}
