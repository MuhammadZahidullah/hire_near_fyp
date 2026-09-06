import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hire_near_fyp/data/models/user_model.dart';
import 'package:hire_near_fyp/feature/review/providers/review_provider.dart';
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

  // Primary category keys (corresponding to the 7 main home categories)
  static const List<String> _primaryCategoryKeys = [
    'plumb',
    'mason',
    'elect',
    'carpent',
    'clean',
    'driv',
    'mechan',
  ];

  // Filter workers by category title / skill
  List<CategoryWorkerModel> getWorkersByCategory(String categoryTitle) {
    final cleanCategory = categoryTitle.trim().toLowerCase();
    if (cleanCategory.isEmpty || cleanCategory == 'all') {
      return _categoryWorkers;
    }

    String normalize(String s) {
      final str = s.toLowerCase().trim();
      if (str.contains('pulum') || str.contains('plumb')) return 'plumb';
      if (str.contains('messo') || str.contains('mason')) return 'mason';
      if (str.contains('elect')) return 'elect';
      if (str.contains('carpent')) return 'carpent';
      if (str.contains('clean')) return 'clean';
      if (str.contains('driv')) return 'driv';
      if (str.contains('mechan')) return 'mechan';
      return str;
    }

    // 'More' represents additional / extra skills outside the 7 primary categories
    if (cleanCategory == 'more') {
      return _categoryWorkers.where((worker) {
        final roleNorm = normalize(worker.role);
        final isPrimary = _primaryCategoryKeys.any(
          (key) => roleNorm.contains(key),
        );
        return !isPrimary;
      }).toList();
    }

    final target = normalize(cleanCategory);

    return _categoryWorkers.where((worker) {
      final roleNorm = normalize(worker.role);
      return roleNorm.contains(target) ||
          target.contains(roleNorm) ||
          worker.role.toLowerCase().contains(cleanCategory);
    }).toList();
  }

  // Fetch real workers from Firestore (Req 9 — real ratings from reviews)
  Future<void> fetchWorkers({ReviewProvider? reviewProvider}) async {
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

      // Build initial list with static rating as placeholder
      _categoryWorkers = _workers.map((user) {
        return CategoryWorkerModel(
          id: user.id.hashCode,
          workerId: user.id,
          name: user.name.isNotEmpty ? user.name : 'Worker',
          role: (user.skill != null && user.skill!.isNotEmpty)
              ? user.skill!
              : 'Worker',
          rating: user.rating > 0 ? user.rating : 0.0,
          reviews: user.bookings,
          distance: user.location.isNotEmpty ? user.location : 'Nearby',
          imageUrl: user.avatarUrl ?? '',
          isVerified: true,
          price: user.price ?? 0,
        );
      }).toList();

      _isLoading = false;
      notifyListeners();

      // Fetch real average ratings from reviews collection (Req 9)
      if (reviewProvider != null && _workers.isNotEmpty) {
        final workerIds =
            _workers.map((u) => u.id).where((id) => id.isNotEmpty).toList();

        final realRatings =
            await reviewProvider.fetchAverageRatingsForWorkers(workerIds);

        if (realRatings.isNotEmpty) {
          _categoryWorkers = _categoryWorkers.map((worker) {
            final realAvg = realRatings[worker.workerId];
            if (realAvg != null && realAvg > 0) {
              return CategoryWorkerModel(
                id: worker.id,
                workerId: worker.workerId,
                name: worker.name,
                role: worker.role,
                rating: double.parse(realAvg.toStringAsFixed(1)),
                reviews: worker.reviews,
                distance: worker.distance,
                imageUrl: worker.imageUrl,
                isVerified: worker.isVerified,
                price: worker.price,
              );
            }
            return worker;
          }).toList();

          notifyListeners();
        }
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      debugPrint("Fetch Workers Error: $e");
      notifyListeners();
    }
  }
}

