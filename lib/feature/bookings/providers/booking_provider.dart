import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/bookings/data/booking_data.dart';
import 'package:hire_near_fyp/feature/bookings/models/booking_model.dart';

class BookingProvider extends ChangeNotifier {
  // final List<BookingModel> _bookings = BookingData.bookings;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final List<BookingModel> _bookings = [];
  List<BookingModel> get pendingBookings =>
      _bookings.where((b) => b.status == 'pending').toList();
  List<BookingModel> get completeBookings =>
      _bookings.where((b) => b.status == 'completed').toList();
  List<BookingModel> get cancelBooking =>
      _bookings.where((b) => b.status == 'canceled').toList();

  Future<void> addBooking(BookingModel booking) async {
    try {
      final user = _auth.currentUser;

      if (user == null) return;

      await _firestore.collection('bookings').add({
        'userId': user.uid,
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

      _bookings.add(booking);
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('==========================');
      debugPrint('BOOKING ERROR: $e');
      debugPrint(stackTrace.toString());
      debugPrint('==========================');
      rethrow;
    }
  }

  void cancelBookings(int id) {
    int index = _bookings.indexWhere((booking) => booking.id == id);

    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(status: 'cancelled');

      notifyListeners();
    }
  }
}
