import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/review/models/review_model.dart';

class ReviewProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // State
  final Map<String, List<ReviewModel>> _reviewsByWorker = {};
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  String? _submitError;

  // Getters
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  String? get submitError => _submitError;

  /// Reviews already loaded for a worker
  List<ReviewModel> getWorkerReviews(String workerId) {
    return _reviewsByWorker[workerId] ?? [];
  }

  /// Average rating computed from loaded reviews
  double getAverageRating(String workerId) {
    final reviews = getWorkerReviews(workerId);
    if (reviews.isEmpty) return 0.0;
    final total = reviews.fold<double>(0.0, (acc, r) => acc + r.rating);
    return total / reviews.length;
  }

  int getReviewCount(String workerId) {
    return getWorkerReviews(workerId).length;
  }

  /// Check if a specific booking has already been reviewed (Req 6)
  bool hasReviewedBooking(String bookingId) {
    for (final reviews in _reviewsByWorker.values) {
      if (reviews.any((r) => r.bookingId == bookingId)) return true;
    }
    return false;
  }

  /// Fetch reviews for a given worker from Firestore (Req 8 — persists after restart)
  Future<void> fetchReviewsForWorker(String workerId) async {
    if (workerId.isEmpty) return;

    // Avoid re-fetching if already loaded
    if (_reviewsByWorker.containsKey(workerId)) return;

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final snapshot = await _firestore
          .collection('reviews')
          .where('workerId', isEqualTo: workerId)
          .orderBy('createdAt', descending: true)
          .get();

      _reviewsByWorker[workerId] = snapshot.docs.map((doc) {
        return ReviewModel.fromMap(doc.data(), firestoreId: doc.id);
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      debugPrint('ReviewProvider.fetchReviewsForWorker error: $e');
      notifyListeners();
    }
  }

  /// Fetch reviews for all given worker IDs (used by WorkerProvider for bulk rating)
  Future<Map<String, double>> fetchAverageRatingsForWorkers(
    List<String> workerIds,
  ) async {
    final Map<String, double> result = {};
    if (workerIds.isEmpty) return result;

    try {
      // Firestore whereIn supports up to 30 items
      const batchSize = 30;
      for (var i = 0; i < workerIds.length; i += batchSize) {
        final batch = workerIds.skip(i).take(batchSize).toList();
        final snapshot = await _firestore
            .collection('reviews')
            .where('workerId', whereIn: batch)
            .get();

        // Group by workerId and compute average
        final Map<String, List<double>> ratingsByWorker = {};
        for (final doc in snapshot.docs) {
          final data = doc.data();
          final wid = data['workerId'] as String? ?? '';
          final rating = (data['rating'] as num?)?.toDouble() ?? 0.0;
          if (wid.isNotEmpty) {
            ratingsByWorker.putIfAbsent(wid, () => []).add(rating);
          }
        }

        for (final entry in ratingsByWorker.entries) {
          final avg =
              entry.value.reduce((a, b) => a + b) / entry.value.length;
          result[entry.key] = avg;
          // Cache locally
          // (full models not available here, so skip _reviewsByWorker update)
        }
      }
    } catch (e) {
      debugPrint('ReviewProvider.fetchAverageRatingsForWorkers error: $e');
    }

    return result;
  }

  /// Submit a new review to Firestore (Req 3, 4, 6)
  Future<bool> submitReview(ReviewModel review) async {
    // Guard: bookingId must not be empty
    if (review.bookingId.isEmpty) {
      _submitError = 'Invalid booking. Cannot submit review.';
      notifyListeners();
      return false;
    }

    // Guard: one review per booking (Req 6)
    if (hasReviewedBooking(review.bookingId)) {
      _submitError = 'You have already reviewed this booking.';
      notifyListeners();
      return false;
    }

    // Guard: workerId must match (Req 7)
    if (review.workerId.isEmpty) {
      _submitError = 'Invalid worker. Cannot submit review.';
      notifyListeners();
      return false;
    }

    try {
      _isSubmitting = true;
      _submitError = null;
      notifyListeners();

      await _firestore
          .collection('reviews')
          .doc(review.bookingId)
          .set(review.toMap());

      // Cache locally so UI updates immediately (Req 8 on restart re-fetches)
      final saved = ReviewModel.fromMap(
        review.toMap(),
        firestoreId: review.bookingId,
      );

      _reviewsByWorker.putIfAbsent(review.workerId, () => []).insert(0, saved);

      _isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSubmitting = false;
      _submitError = e.toString();
      debugPrint('ReviewProvider.submitReview error: $e');
      notifyListeners();
      return false;
    }
  }

  /// Force re-fetch for a worker (e.g. after submitting review)
  Future<void> refreshWorkerReviews(String workerId) async {
    _reviewsByWorker.remove(workerId);
    await fetchReviewsForWorker(workerId);
  }

  void clearSubmitError() {
    _submitError = null;
    notifyListeners();
  }
}
