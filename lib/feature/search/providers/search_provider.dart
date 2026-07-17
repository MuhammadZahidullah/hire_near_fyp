import 'package:flutter/material.dart';
import 'package:hire_near_fyp/features/home/popular_workers/models/category_worker_model.dart';
import 'package:hire_near_fyp/features/home/popular_workers/models/worker_model.dart';

class SearchProvider extends ChangeNotifier {
  // State
  String _searchQuery = '';
  bool _isSearching = false;

  // Getters
  String get searchQuery => _searchQuery;
  bool get isSearching => _isSearching;

  // Filter HomeScreen workers
  List<WorkerModel> getFilteredWorkers(List<WorkerModel> workers) {
    if (_searchQuery.isEmpty) return workers;

    return workers
        .where(
          (worker) =>
              worker.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              worker.role.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  // Filter CategoryScreen workers
  List<CategoryWorkerModel> getFilteredCategoryWorkers(
    List<CategoryWorkerModel> workers,
  ) {
    if (_searchQuery.isEmpty) return workers;

    return workers
        .where(
          (worker) =>
              worker.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              worker.role.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  // Methods
  void updateQuery(String query) {
    _searchQuery = query;
    _isSearching = query.isNotEmpty;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _isSearching = false;
    notifyListeners();
  }
}
