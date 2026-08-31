import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hire_near_fyp/data/models/user_model.dart';
import 'package:hire_near_fyp/features/home/popular_workers/models/category_worker_model.dart';

class WorkerProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<UserModel> _workers = [];
  List<CategoryWorkerModel> _categoryWorkers = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<UserModel> get workers => _workers;
  List<CategoryWorkerModel> get categoryWorkers => _categoryWorkers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Popular workers getter
  List<CategoryWorkerModel> get popularWorkers => _categoryWorkers;

  // Filter workers by category title / skill
  List<CategoryWorkerModel> getWorkersByCategory(String categoryTitle) {
    if (categoryTitle.trim().isEmpty || categoryTitle.toLowerCase() == 'all') {
      return _categoryWorkers;
    }
    return _categoryWorkers.where((worker) {
      return worker.role.toLowerCase().contains(categoryTitle.toLowerCase());
    }).toList();
  }

  // Fetch real workers from Firestore
  Future<void> fetchWorkers() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final snapshot = await _firestore
          .collection('users')
          .where('isWorker', isEqualTo: true)
          .get();

      _workers = snapshot.docs.map((doc) {
        final data = doc.data();
        if (data['id'] == null || (data['id'] as String).isEmpty) {
          data['id'] = doc.id;
        }
        return UserModel.fromMap(data);
      }).toList();

      _categoryWorkers = _workers.map((user) {
        return CategoryWorkerModel(
          id: user.id.hashCode,
          workerId: user.id,
          name: user.name.isNotEmpty ? user.name : 'Worker',
          role: (user.skill != null && user.skill!.isNotEmpty)
              ? user.skill!
              : 'Worker',
          rating: user.rating > 0 ? user.rating : 4.5,
          reviews: user.bookings,
          distance: user.location.isNotEmpty ? user.location : 'Nearby',
          imageUrl: user.avatarUrl ?? '',
          isVerified: true,
          price: user.price ?? 0,
        );
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      debugPrint("Fetch Workers Error: $e");
      notifyListeners();
    }
  }
}
