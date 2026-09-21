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

  // All ranked workers
  List<CategoryWorkerModel> get rankedWorkers {
    if (_categoryWorkers.isEmpty) return [];

    final sortedList = List<CategoryWorkerModel>.from(_categoryWorkers);

    sortedList.sort((a, b) {
      final scoreA = _calculatePopularityScore(a);
      final scoreB = _calculatePopularityScore(b);

      final scoreDiff = scoreB.compareTo(scoreA); // Descending
      if (scoreDiff != 0) return scoreDiff;

      // Tie-breaking
      final bookingDiff = b.completedBookings.compareTo(a.completedBookings);
      if (bookingDiff != 0) return bookingDiff;

      final ratingDiff = b.rating.compareTo(a.rating);
      if (ratingDiff != 0) return ratingDiff;

      final reviewDiff = b.reviews.compareTo(a.reviews);
      if (reviewDiff != 0) return reviewDiff;

      return a.name.compareTo(b.name); // Ascending alphabetical
    });

    return sortedList;
  }

  // Popular workers getter (top 5)
  List<CategoryWorkerModel> get popularWorkers => rankedWorkers.take(5).toList();

  double _calculatePopularityScore(CategoryWorkerModel worker) {
    final completedScore = worker.completedBookings / (worker.completedBookings + 10);
    final ratingScore = (worker.rating / 5.0).clamp(0.0, 1.0);
    final reviewScore = worker.reviews / (worker.reviews + 10);

    return (completedScore * 0.50) + (ratingScore * 0.40) + (reviewScore * 0.10);
  }

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

      final workerIds =
          _workers.map((u) => u.id).where((id) => id.isNotEmpty).toList();

      // Build initial list with placeholders for rating, reviews, and completedBookings
      _categoryWorkers = _workers.map((user) {
        return CategoryWorkerModel(
          id: user.id.hashCode,
          workerId: user.id,
          name: user.name.isNotEmpty ? user.name : 'Worker',
          role: (user.skill != null && user.skill!.isNotEmpty)
              ? user.skill!
              : 'Worker',
          rating: 0.0,
          reviews: 0,
          completedBookings: 0,
          distance: user.location.isNotEmpty ? user.location : 'Nearby',
          imageUrl: user.avatarUrl ?? '',
          isVerified: true,
          price: user.price ?? 0,
        );
      }).toList();

      _isLoading = false;
      notifyListeners();

      if (workerIds.isNotEmpty) {
        // Fetch real average ratings and review counts
        Map<String, ({double rating, int count})> realRatings = {};
        if (reviewProvider != null) {
          realRatings = await reviewProvider.fetchRatingsAndCountsForWorkers(workerIds);
        }

        // Fetch completed bookings count for workers
        final Map<String, int> completedBookingsCount = {};
        try {
          const batchSize = 30;
          for (var i = 0; i < workerIds.length; i += batchSize) {
            final batch = workerIds.skip(i).take(batchSize).toList();
            final snapshot = await _firestore
                .collection('bookings')
                .where('workerId', whereIn: batch)
                .where('status', isEqualTo: 'completed')
                .get();

            for (final doc in snapshot.docs) {
              final wid = doc.data()['workerId'] as String? ?? '';
              if (wid.isNotEmpty) {
                completedBookingsCount[wid] = (completedBookingsCount[wid] ?? 0) + 1;
              }
            }
          }
        } catch (e) {
          debugPrint('WorkerProvider fetch completed bookings error: $e');
        }

        // Update category workers with actual data
        _categoryWorkers = _categoryWorkers.map((worker) {
          final wid = worker.workerId ?? '';
          final ratingData = realRatings[wid];
          final completedBookings = completedBookingsCount[wid] ?? 0;
          
          return CategoryWorkerModel(
            id: worker.id,
            workerId: wid,
            name: worker.name,
            role: worker.role,
            rating: ratingData != null ? double.parse(ratingData.rating.toStringAsFixed(1)) : 0.0,
            reviews: ratingData != null ? ratingData.count : 0,
            completedBookings: completedBookings,
            distance: worker.distance,
            imageUrl: worker.imageUrl,
            isVerified: worker.isVerified,
            price: worker.price,
          );
        }).toList();

        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      debugPrint("Fetch Workers Error: $e");
      notifyListeners();
    }
  }
}

