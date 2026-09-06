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

  /// Saves editable profile fields to Firestore and updates local state.
  /// Returns null on success, or an error message string on failure.
  Future<String?> saveProfile({
    required String name,
    required String phone,
    required String location,
    // Worker-only fields (pass null for customer)
    String? skill,
    String? experience,
    int? price,
    String? description,
  }) async {
    // ── Validation ──────────────────────────────────────────────────────────
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return 'Name cannot be empty.';

    final isWorker = _user?.isWorker == true || _user?.activeRole == 'worker';
    if (isWorker) {
      final trimmedSkill = skill?.trim() ?? '';
      if (trimmedSkill.isEmpty) return 'Skill cannot be empty.';
      if (price == null || price <= 0) {
        return 'Price must be greater than 0.';
      }
    }

    // ── Build update map ─────────────────────────────────────────────────────
    final uid = _auth.currentUser?.uid;
    if (uid == null) return 'Not logged in.';

    final Map<String, dynamic> updates = {
      'name': trimmedName,
      'phone': phone.trim(),
      'location': location.trim(),
    };

    if (isWorker) {
      updates['skill'] = skill?.trim() ?? '';
      updates['experience'] = experience?.trim() ?? '';
      updates['price'] = price ?? 0;
      updates['description'] = description?.trim() ?? '';
    }

    try {
      await _firestore.collection('users').doc(uid).update(updates);

      // Update in-memory state immediately (Req 5)
      _user = _user?.copyWith(
        name: trimmedName,
        phone: phone.trim(),
        location: location.trim(),
        skill: isWorker ? (skill?.trim() ?? _user?.skill) : _user?.skill,
        experience: isWorker
            ? (experience?.trim() ?? _user?.experience)
            : _user?.experience,
        price: isWorker ? price : _user?.price,
        description: isWorker
            ? (description?.trim() ?? _user?.description)
            : _user?.description,
      );
      notifyListeners();
      return null; // success
    } catch (e) {
      debugPrint('[ProfileProvider] saveProfile error: $e');
      return 'Failed to save profile. Please try again.';
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
