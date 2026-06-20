import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/bookings/data/booking_data.dart';
import 'package:hire_near_fyp/feature/bookings/models/booking_model.dart';

class BookingProvider extends ChangeNotifier {
  final List<BookingModel> _bookings = BookingData.bookings;
  List<BookingModel> get pendingBookings =>
      _bookings.where((b) => b.status == 'pending').toList();
  List<BookingModel> get completeBookings =>
      _bookings.where((b) => b.status == 'complete').toList();
  List<BookingModel> get cancelBooking =>
      _bookings.where((b) => b.status == 'cancel').toList();

  void addBooking(BookingModel booking) {
    _bookings.add(booking);
    notifyListeners();
  }

  void cancelBookings(int id) {
    int index = _bookings.indexWhere((booking) => booking.id == id);

    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(status: 'cancelled');

      notifyListeners();
    }
  }
}
