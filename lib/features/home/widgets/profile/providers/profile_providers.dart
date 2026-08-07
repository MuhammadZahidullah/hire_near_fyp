import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_near_fyp/data/models/user_model.dart';

class ProfileProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _user;
  // State — dummy user for now
  //UserModel? _user;

  // Getters
  UserModel? get user => _user;
  String get userName => _user?.name ?? '';
  String get userEmail => _user?.email ?? '';
  String get userLocation => _user?.location ?? '';
  int get totalBookings => _user?.bookings ?? 0;
  double get rating => _user?.rating ?? 0.0;
  double get totalSpent => _user?.totalSpent ?? 0;
  String? get avatarUrl => _user?.avatarUrl;
  // Methods

  Future<void> loadProfile() async {
    try {
      final firebaseUser = _auth.currentUser;

      if (firebaseUser == null) return;

      final doc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (doc.exists) {
        _user = UserModel.fromMap(doc.data()!);
        debugPrint("PROFILE USER: ${_user!.name}");
        debugPrint("PROFILE EMAIL: ${_user!.email}");
        debugPrint("PROFILE UID: ${_user!.id}");
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Profile Load Error: $e");
    }
  }

  // update whole profile
  void updateProfile({
    String? name,
    String? email,
    String? location,
    String? avatarUrl,
  }) {
    _user = _user?.copyWith(
      name: name,
      email: email,
      location: location,
      avatarUrl: avatarUrl,
    );
    notifyListeners();
  }

  // update location only
  void updateLocation(String location) {
    _user = _user?.copyWith(location: location);
    notifyListeners();
  }

  // update bookings count
  void incrementBookings() {
    _user = _user!.copyWith(bookings: _user!.bookings + 1);
    notifyListeners();
  }

  // update total spent
  void addToTotalSpent(double amount) {
    _user = _user!.copyWith(totalSpent: _user!.totalSpent + amount);
    notifyListeners();
  }
}
