import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:hire_near_fyp/feature/bookings/models/booking_model.dart';
import 'package:hire_near_fyp/feature/notifications/providers/notification_provider.dart';

class BookingProvider extends ChangeNotifier {
  // final List<BookingModel> _bookings = BookingData.bookings;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final List<BookingModel> _bookings = [];
  bool _isLoading = false;
  String? _errorMessage;
  // Guard against concurrent duplicate booking submissions.
  bool _isAddingBooking = false;

  List<BookingModel> get allBookings => _bookings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<BookingModel> get pendingBookings =>
      _bookings.where((b) => b.status == 'pending' || b.status == 'accepted').toList();
  List<BookingModel> get completeBookings =>
      _bookings.where((b) => b.status == 'completed').toList();
  List<BookingModel> get cancelBooking =>
      _bookings.where((b) => b.status == 'cancelled' || b.status == 'rejected').toList();

  Future<void> addBooking(BookingModel booking) async {
    // Provider-level guard: reject concurrent duplicate submission attempts.
    if (_isAddingBooking) {
      debugPrint("ADD BOOKING ignored — already in progress");
      return;
    }
    _isAddingBooking = true;
    debugPrint("START ADD BOOKING");
    try {
      final user = _auth.currentUser;
      final customerUid = user?.uid ?? booking.userId;

      if (customerUid == null) {
        debugPrint("NO AUTHENTICATED USER");
        return;
      }

      if (customerUid == booking.workerId) {
        throw Exception("You cannot book your own service.");
      }

      debugPrint("BEFORE FIRESTORE");

      final docRef = await _firestore.collection('bookings').add({
        'id': booking.id,
        'userId': customerUid,
        'customerName': booking.customerName,
        'customerEmail': booking.customerEmail,
        'customerPhone': booking.customerPhone,
        'customerLocation': booking.customerLocation ?? booking.location,
        'workerId': booking.workerId,
        'workerSkill': booking.workerSkill,
        'workerName': booking.workerName,
        'role': booking.role,
        'location': booking.location,
        'date': booking.date,
        'time': booking.time,
        'price': booking.price,
        'status': booking.status,
        'imageUrl': booking.imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
      debugPrint("AFTER FIRESTORE");

      // Send notification to worker
      if (booking.workerId != null && booking.workerId!.trim().isNotEmpty) {
        final customerName = (booking.customerName != null &&
                booking.customerName!.trim().isNotEmpty)
            ? booking.customerName!.trim()
            : 'A customer';
        final service = booking.role.trim().isNotEmpty
            ? booking.role.trim()
            : (booking.workerSkill != null &&
                    booking.workerSkill!.trim().isNotEmpty
                ? booking.workerSkill!.trim()
                : 'Service');

        await NotificationProvider.sendNotification(
          userId: booking.workerId!.trim(),
          title: 'New Booking Request',
          message: 'New booking request from $customerName for $service.',
          type: 'booking_request',
          bookingId: booking.id.toString(),
        );
      }

      debugPrint("ADDING LOCAL");
      _bookings.add(booking.copyWith(
        userId: customerUid,
        firestoreId: docRef.id,
      ));

      notifyListeners();
      debugPrint("DONE");
    } catch (e, stackTrace) {
      debugPrint('==========================');
      debugPrint('BOOKING ERROR: $e');
      debugPrint(stackTrace.toString());
      debugPrint('==========================');
      rethrow;
    } finally {
      // Always release the guard so future bookings (including retries) can proceed.
      _isAddingBooking = false;
    }
  }

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
          .where('userId', isEqualTo: user.uid)
          .get();

      _bookings.clear();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final booking = BookingModel.fromMap(data).copyWith(
          firestoreId: doc.id,
        );
        _bookings.add(booking);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      debugPrint("Load Booking Error: $e");
      notifyListeners();
    }
  }

  Future<void> cancelBookings(int id) async {
    try {
      final index = _bookings.indexWhere((booking) => booking.id == id);

      if (index == -1) return;

      final booking = _bookings[index];

      // Update Firestore using document ID
      if (booking.firestoreId != null) {
        await _firestore.collection('bookings').doc(booking.firestoreId).update(
          {'status': 'cancelled'},
        );
      }

      // Reload latest data
      await loadBookings();
    } catch (e) {
      debugPrint("Cancel Booking Error: $e");
    }
  }

  Future<void> refreshBookings() async {
    _bookings.clear();
    await loadBookings();
  }
}
