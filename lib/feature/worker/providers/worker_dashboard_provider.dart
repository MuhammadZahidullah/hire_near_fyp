import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/bookings/models/booking_model.dart';
import 'package:hire_near_fyp/feature/notifications/providers/notification_provider.dart';

class WorkerDashboardProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<BookingModel> _bookings = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<BookingModel> get allBookings => _bookings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<BookingModel> get pendingBookings =>
      _bookings.where((b) => b.status == 'pending').toList();

  List<BookingModel> get acceptedBookings =>
      _bookings.where((b) => b.status == 'accepted').toList();

  List<BookingModel> get completedBookings =>
      _bookings.where((b) => b.status == 'completed').toList();

  List<BookingModel> get rejectedBookings =>
      _bookings.where((b) => b.status == 'rejected').toList();

  Future<void> loadBookings() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        _bookings.clear();
        notifyListeners();
        return;
      }

      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final snapshot = await _firestore
          .collection('bookings')
          .where('workerId', isEqualTo: user.uid)
          .get();

      _bookings.clear();

      for (final doc in snapshot.docs) {
        final booking = BookingModel.fromMap(doc.data()).copyWith(
          firestoreId: doc.id,
        );

        _bookings.add(booking);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      debugPrint("Worker Dashboard Error: $e");
      notifyListeners();
    }
  }

  Future<void> acceptBooking(int bookingId) async {
    try {
      final index = _bookings.indexWhere((b) => b.id == bookingId);

      if (index == -1) return;

      final booking = _bookings[index];

      if (booking.firestoreId == null) return;

      await _firestore
          .collection('bookings')
          .doc(booking.firestoreId)
          .update({
        'status': 'accepted',
      });

      _bookings[index] = booking.copyWith(
        status: 'accepted',
      );

      notifyListeners();

      // Send notification to customer
      if (booking.userId != null && booking.userId!.trim().isNotEmpty) {
        final workerName = booking.workerName.trim().isNotEmpty
            ? booking.workerName.trim()
            : 'Worker';
        final service = booking.role.trim().isNotEmpty
            ? booking.role.trim()
            : (booking.workerSkill != null &&
                    booking.workerSkill!.trim().isNotEmpty
                ? booking.workerSkill!.trim()
                : 'Service');

        await NotificationProvider.sendNotification(
          userId: booking.userId!.trim(),
          title: 'Booking Accepted',
          message: 'Your booking for $service has been accepted by $workerName.',
          type: 'booking_accepted',
          bookingId: booking.id.toString(),
        );
      }
    } catch (e) {
      debugPrint("Accept Booking Error: $e");
    }
  }

  Future<void> rejectBooking(int bookingId) async {
    try {
      final index = _bookings.indexWhere((b) => b.id == bookingId);

      if (index == -1) return;

      final booking = _bookings[index];

      if (booking.firestoreId == null) return;

      await _firestore
          .collection('bookings')
          .doc(booking.firestoreId)
          .update({
        'status': 'rejected',
      });

      _bookings[index] = booking.copyWith(
        status: 'rejected',
      );

      notifyListeners();

      // Send notification to customer
      if (booking.userId != null && booking.userId!.trim().isNotEmpty) {
        final workerName = booking.workerName.trim().isNotEmpty
            ? booking.workerName.trim()
            : 'Worker';
        final service = booking.role.trim().isNotEmpty
            ? booking.role.trim()
            : (booking.workerSkill != null &&
                    booking.workerSkill!.trim().isNotEmpty
                ? booking.workerSkill!.trim()
                : 'Service');

        await NotificationProvider.sendNotification(
          userId: booking.userId!.trim(),
          title: 'Booking Rejected',
          message: 'Your booking for $service was rejected by $workerName.',
          type: 'booking_rejected',
          bookingId: booking.id.toString(),
        );
      }
    } catch (e) {
      debugPrint("Reject Booking Error: $e");
    }
  }

  Future<void> completeBooking(int bookingId) async {
    try {
      final index = _bookings.indexWhere((b) => b.id == bookingId);

      if (index == -1) return;

      final booking = _bookings[index];

      if (booking.firestoreId == null) return;

      await _firestore
          .collection('bookings')
          .doc(booking.firestoreId)
          .update({
        'status': 'completed',
      });

      _bookings[index] = booking.copyWith(
        status: 'completed',
      );

      notifyListeners();

      // Send notification to customer
      if (booking.userId != null && booking.userId!.trim().isNotEmpty) {
        final workerName = booking.workerName.trim().isNotEmpty
            ? booking.workerName.trim()
            : 'Worker';
        final service = booking.role.trim().isNotEmpty
            ? booking.role.trim()
            : (booking.workerSkill != null &&
                    booking.workerSkill!.trim().isNotEmpty
                ? booking.workerSkill!.trim()
                : 'Service');

        await NotificationProvider.sendNotification(
          userId: booking.userId!.trim(),
          title: 'Job Completed',
          message: 'Your job for $service has been completed by $workerName.',
          type: 'job_completed',
          bookingId: booking.id.toString(),
        );
      }
    } catch (e) {
      debugPrint("Complete Booking Error: $e");
    }
  }
}
