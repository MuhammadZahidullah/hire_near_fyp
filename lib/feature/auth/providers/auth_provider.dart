import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hire_near_fyp/data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // State
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;

  // Register with Firebase
  Future<void> register(
    String name,
    String email,
    String password,
    String phone,
    String role,
  ) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Step 1 — Create Firebase Auth user
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step 2 — Create UserModel
      UserModel newUser = UserModel(
        id: credential.user!.uid,
        name: name,
        email: email,
        phone: phone,
        location: 'Not set',
        activeRole: role,
        isWorker: role == 'worker',
        bookings: 0,
        rating: 0.0,
        totalSpent: 0,
      );

      // Step 3 — Save to Firestore
      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(newUser.toMap());

      // Step 4 — Set current user
      _currentUser = newUser;
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e.code);
      notifyListeners();
    }
  }

  // Login with Firebase
  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Step 1 — Firebase login
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step 2 — Fetch user from Firestore
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      // Step 3 — Set current user
      _currentUser = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e.code);
      notifyListeners();
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

//   Future<void> becomeWorker(UserModel updatedUser) async {
//   try {
//     await _firestore
//         .collection('users')
//         .doc(updatedUser.id)
//         .update(updatedUser.toMap());

//     _currentUser = updatedUser;
//     notifyListeners();
//   } catch (e) {
//     debugPrint("Become Worker Error: $e");
//   }
// }

  // Check auth state on app start
  Future<void> checkAuthState() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (doc.exists) {
        _currentUser = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        notifyListeners();
      }
    }
  }


  Future<void> becomeWorker({
  required String skill,
  required String experience,
  required int price,
  required String description,
}) async {
  try {
    final user = _auth.currentUser;

    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).update({
      'isWorker': true,
      'activeRole': 'worker',
      'skill': skill,
      'experience': experience,
      'price': price,
      'description': description,
    });

    _currentUser = _currentUser?.copyWith(
      isWorker: true,
      activeRole: 'worker',
      skill: skill,
      experience: experience,
      price: price,
      description: description,
    );

    notifyListeners();
  } catch (e) {
    debugPrint("Become Worker Error: $e");
  }
}

  // Firebase error messages
  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password';
      case 'email-already-in-use':
        return 'Email already registered';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      default:
        return 'Something went wrong';
    }
  }
}
