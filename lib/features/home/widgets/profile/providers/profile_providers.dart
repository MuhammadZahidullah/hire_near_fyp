import 'package:flutter/material.dart';
import 'package:hire_near_fyp/data/models/user_model.dart';

class ProfileProvider extends ChangeNotifier {
  // State — dummy user for now
  UserModel _user = UserModel(
    name: 'Muhammad Zahidullah',
    email: 'zahid@gmail.com',
    location: 'Lower Dir, Maidan',
    bookings: 12,
    rating: 4.7,
    totalSpent: 3450,
    avatarUrl: null,
  );

  // Getters
  UserModel get user => _user;
  String get userName => _user.name;
  String get userEmail => _user.email;
  String get userLocation => _user.location;
  int get totalBookings => _user.bookings;
  double get rating => _user.rating;
  double get totalSpent => _user.totalSpent;
  String? get avatarUrl => _user.avatarUrl;

  // Methods

  // update whole profile
  void updateProfile({
    String? name,
    String? email,
    String? location,
    String? avatarUrl,
  }) {
    _user = _user.copyWith(
      name: name,
      email: email,
      location: location,
      avatarUrl: avatarUrl,
    );
    notifyListeners();
  }

  // update location only
  void updateLocation(String location) {
    _user = _user.copyWith(location: location);
    notifyListeners();
  }

  // update bookings count
  void incrementBookings() {
    _user = _user.copyWith(bookings: _user.bookings + 1);
    notifyListeners();
  }

  // update total spent
  void addToTotalSpent(double amount) {
    _user = _user.copyWith(totalSpent: _user.totalSpent + amount);
    notifyListeners();
  }
}
