import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    debugPrint("START ADD BOOKING");
    try {
      final user = _auth.currentUser;

      if (user == null) return;
      debugPrint("BEFORE FIRESTORE");

      final docRef = await _firestore.collection('bookings').add({
        
        'id': booking.id,
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
      debugPrint("AFTER FIRESTORE");
      debugPrint("ADDING LOCAL");
     debugPrint("LINE A");
      _bookings.add(
  booking.copyWith(
    firestoreId: docRef.id,
  ),
);

debugPrint("LINE C");

notifyListeners();
debugPrint("LINE C");
debugPrint("DONE");
    } catch (e, stackTrace) {
      debugPrint('==========================');
      debugPrint('BOOKING ERROR: $e');
      debugPrint(stackTrace.toString());
      debugPrint('==========================');
      rethrow;
    }
  }

  Future<void> loadBookings() async {
  try {
    final user = _auth.currentUser;

    if (user == null) return;

    final snapshot = await _firestore
        .collection('bookings')
        .where('userId', isEqualTo: user.uid)
        .get();

    _bookings.clear();

    for (var doc in snapshot.docs) {
      final data = doc.data();

      _bookings.add(
        BookingModel(
          id: data['id'] ?? 0,
           firestoreId: doc.id,
          workerName: data['workerName'],
          role: data['role'],
          location: data['location'],
          date: data['date'],
          time: data['time'],
          price: data['price'],
          status: data['status'],
          imageUrl: data['imageUrl'],
        ),
      );
    }

    notifyListeners();
  } catch (e) {
    debugPrint("Load Booking Error: $e");
  }
}

Future<void> cancelBookings(int id) async {
  try {
    final index = _bookings.indexWhere((booking) => booking.id == id);

    if (index == -1) return;

    final booking = _bookings[index];

    // Update Firestore using document ID
    if (booking.firestoreId != null) {
      await _firestore
          .collection('bookings')
          .doc(booking.firestoreId)
          .update({
        'status': 'cancelled',
      });
    }

    // Reload latest data
    await loadBookings();
  } catch (e) {
    debugPrint("Cancel Booking Error: $e");
  }
}
  }

