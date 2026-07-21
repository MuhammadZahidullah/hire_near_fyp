import 'package:flutter/material.dart';
import 'package:hire_near_fyp/features/home/popular_workers/models/category_worker_model.dart';

class FavoritesProvider extends ChangeNotifier {
  // State
  final List<CategoryWorkerModel> _favorites = [];

  // Getters
  List<CategoryWorkerModel> get favorites => _favorites;

  int get favoritesCount => _favorites.length;

  // Check if worker is favorite
  bool isFavorite(int workerId) {
    return _favorites.any((w) => w.id == workerId);
  }

  // Toggle favorite
  void toggleFavorite(CategoryWorkerModel worker) {
    if (isFavorite(worker.id)) {
      // remove
      _favorites.removeWhere((w) => w.id == worker.id);
    } else {
      // add
      _favorites.add(worker);
    }
    notifyListeners();
  }

  // Clear all favorites
  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }
}
