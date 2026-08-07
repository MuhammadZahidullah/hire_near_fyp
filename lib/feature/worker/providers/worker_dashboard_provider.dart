import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/bookings/models/booking_model.dart';

class WorkerDashboardProvider extends ChangeNotifier {
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<BookingModel> _bookings = [];

  List<BookingModel> get allBookings => _bookings;

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
    final snapshot = await _firestore.collection('bookings').get();

    _bookings.clear();

    for (final doc in snapshot.docs) {
      final booking = BookingModel.fromMap(doc.data()).copyWith(
        firestoreId: doc.id,
      );

      _bookings.add(booking);
    }

    notifyListeners();
  } catch (e) {
    debugPrint("Worker Dashboard Error: $e");
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
  } catch (e) {
    debugPrint("Complete Booking Error: $e");
  }
}
}
