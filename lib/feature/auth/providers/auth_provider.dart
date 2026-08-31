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

      debugPrint('=== [AuthProvider.register] Starting registration for $email ===');

      // Step 1 — Create Firebase Auth user
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      debugPrint('=== [AuthProvider.register] Auth created user UID: ${credential.user?.uid} ===');

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
      debugPrint('=== [AuthProvider.register] Before Firestore .set() on doc users/${credential.user!.uid} ===');
      debugPrint('=== [AuthProvider.register] Data payload: ${newUser.toMap()} ===');

      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(newUser.toMap());

      debugPrint('=== [AuthProvider.register] After Firestore .set() - Document created successfully ===');

      // Step 4 — Set current user
      _currentUser = newUser;
    } on FirebaseAuthException catch (e) {
      debugPrint('=== [AuthProvider.register] FirebaseAuthException caught ===');
      debugPrint('Code: ${e.code}');
      debugPrint('Message: ${e.message}');
      _errorMessage = _getErrorMessage(e.code);
    } on FirebaseException catch (e) {
      debugPrint('=== [AuthProvider.register] FirebaseException caught ===');
      debugPrint('Plugin: ${e.plugin}');
      debugPrint('Code: ${e.code}');
      debugPrint('Message: ${e.message}');
      _errorMessage = e.message ?? 'Database error: ${e.code}';
    } catch (e, stackTrace) {
      debugPrint('=== [AuthProvider.register] Generic Exception caught ===');
      debugPrint('Error: $e');
      debugPrint('StackTrace: $stackTrace');
      _errorMessage = 'Registration failed: ${e.toString()}';
    } finally {
      _isLoading = false;
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
      debugPrint("LOGIN USER: ${_currentUser!.name}");
      debugPrint("LOGIN EMAIL: ${_currentUser!.email}");
      debugPrint("LOGIN UID: ${_currentUser!.id}");
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
