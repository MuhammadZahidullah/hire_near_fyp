import 'package:flutter/material.dart';
import 'package:hire_near_fyp/data/models/user_model.dart';
//import 'your UserModel path';

class AuthProvider extends ChangeNotifier {
  // State
  UserModel? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Dummy users for testing
  final List<Map<String, String>> _dummyUsers = [
    {
      'name': 'Muhammad Zahidullah',
      'email': 'zahid@gmail.com',
      'password': '123456',
    },
    {'name': 'Inam Ullah', 'email': 'inam@gmail.com', 'password': '123456'},
    {'name': 'Test User', 'email': 'test@gmail.com', 'password': '123456'},
  ];

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;

  // validate email
  bool _isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
  }

  // validate password
  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  // check dummy user exists
  bool _userExists(String email, String password) {
    return _dummyUsers.any(
      (user) => user['email'] == email && user['password'] == password,
    );
  }

  // get user name from dummy list
  String _getUserName(String email) {
    final user = _dummyUsers.firstWhere(
      (user) => user['email'] == email,
      orElse: () => {'name': 'User'},
    );
    return user['name'] ?? 'User';
  }

  // Login Method
  Future<void> login(String email, String password) async {
    // clear previous error
    _errorMessage = null;

    // Step 1 — validate email
    if (email.isEmpty) {
      _errorMessage = 'Email cannot be empty';
      notifyListeners();
      return;
    }

    if (!_isValidEmail(email)) {
      _errorMessage = 'Please enter valid email';
      notifyListeners();
      return;
    }

    // Step 2 — validate password
    if (password.isEmpty) {
      _errorMessage = 'Password cannot be empty';
      notifyListeners();
      return;
    }

    if (!_isValidPassword(password)) {
      _errorMessage = 'Password must be at least 6 characters';
      notifyListeners();
      return;
    }

    // Step 3 — set loading
    _isLoading = true;
    notifyListeners();

    // Step 4 — simulate network call
    await Future.delayed(Duration(seconds: 2));

    // Step 5 — check user exists
    if (!_userExists(email, password)) {
      _errorMessage = 'Invalid email or password';
      _isLoading = false;
      notifyListeners();
      return;
    }

    // Step 6 — login success
    _currentUser = UserModel(
      name: _getUserName(email),
      email: email,
      location: 'Lower Dir, Maidan',
      bookings: 0,
      rating: 0.0,
      totalSpent: 0,
    );
    _isLoggedIn = true;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  // Register Method
  Future<void> register(String name, String email, String password) async {
    // clear previous error
    _errorMessage = null;

    // Step 1 — validate name
    if (name.isEmpty) {
      _errorMessage = 'Name cannot be empty';
      notifyListeners();
      return;
    }

    // Step 2 — validate email
    if (email.isEmpty || !_isValidEmail(email)) {
      _errorMessage = 'Please enter valid email';
      notifyListeners();
      return;
    }

    // Step 3 — validate password
    if (!_isValidPassword(password)) {
      _errorMessage = 'Password must be at least 6 characters';
      notifyListeners();
      return;
    }

    // Step 4 — set loading
    _isLoading = true;
    notifyListeners();

    // Step 5 — simulate network call
    await Future.delayed(Duration(seconds: 2));

    // Step 6 — add to dummy users
    _dummyUsers.add({'name': name, 'email': email, 'password': password});

    // Step 7 — register success
    _currentUser = UserModel(
      name: name,
      email: email,
      location: 'Unknown',
      bookings: 0,
      rating: 0.0,
      totalSpent: 0,
    );
    _isLoggedIn = true;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  // Logout Method
  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    _errorMessage = null;
    notifyListeners();
  }

  // Clear Error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
