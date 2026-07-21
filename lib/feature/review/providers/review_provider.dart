import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/review/models/review_model.dart';
//import your ReviewModel path;

class ReviewProvider extends ChangeNotifier {
  // State
  List<ReviewModel> _reviews = [];

  // Constructor — dummy reviews
  ReviewProvider() {
    _reviews = [
      ReviewModel(
        id: 1,
        workerId: 1,
        workerName: 'Usman Ali',
        userName: 'Muhammad Zahidullah',
        rating: 4.8,
        comment: 'Excellent work! Very professional and on time.',
        date: DateTime.now().subtract(Duration(days: 2)),
      ),
      ReviewModel(
        id: 2,
        workerId: 1,
        workerName: 'Usman Ali',
        userName: 'Inam Ullah',
        rating: 4.5,
        comment: 'Good work but came a bit late.',
        date: DateTime.now().subtract(Duration(days: 5)),
      ),
      ReviewModel(
        id: 3,
        workerId: 2,
        workerName: 'Hamza Khan',
        userName: 'Muhammad Zahidullah',
        rating: 4.9,
        comment: 'Amazing service! Highly recommended.',
        date: DateTime.now().subtract(Duration(days: 1)),
      ),
    ];
  }

  // Getters
  List<ReviewModel> get allReviews => _reviews;

  // get reviews for specific worker
  List<ReviewModel> getWorkerReviews(int workerId) {
    return _reviews.where((review) => review.workerId == workerId).toList();
  }

  // get average rating for worker
  double getAverageRating(int workerId) {
    final workerReviews = getWorkerReviews(workerId);

    if (workerReviews.isEmpty) return 0.0;

    double total = workerReviews.map((r) => r.rating).reduce((a, b) => a + b);

    return total / workerReviews.length;
  }

  // get review count for worker
  int getReviewCount(int workerId) {
    return getWorkerReviews(workerId).length;
  }

  // check if user already reviewed worker
  bool hasReviewed(int workerId, String userName) {
    return _reviews.any(
      (r) => r.workerId == workerId && r.userName == userName,
    );
  }

  // add review
  void addReview(ReviewModel review) {
    // check if already reviewed
    if (hasReviewed(review.workerId, review.userName)) {
      return; // cannot review twice
    }

    _reviews.add(review);
    notifyListeners();
  }

  // delete review
  void deleteReview(int id) {
    _reviews.removeWhere((r) => r.id == id);
    notifyListeners();
  }
}
