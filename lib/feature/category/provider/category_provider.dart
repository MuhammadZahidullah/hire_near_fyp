import 'package:flutter/material.dart';
import 'package:hire_near_fyp/features/home/popular_workers/models/category_worker_model.dart';

class CategoryProvider extends ChangeNotifier {
  // State
  String _selectedFilter = 'All';

  // Getter
  String get selectedFilter => _selectedFilter;

  // Set Filter
  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  // Reset filter when leaving screen
  void resetFilter() {
    _selectedFilter = 'All';
    notifyListeners();
  }

  // Get sorted workers based on filter
  List<CategoryWorkerModel> getSortedWorkers(
    List<CategoryWorkerModel> workers,
  ) {
    // make a copy so original list not changed
    List<CategoryWorkerModel> sorted = List.from(workers);

    switch (_selectedFilter) {
      case 'All':
        return sorted;

      case 'Nearby':
        sorted.sort((a, b) {
          // parse distance string to number
          // '2.5 KM' → 2.5
          double aDistance = double.parse(
            a.distance.replaceAll(RegExp(r'[^0-9.]'), ''),
          );
          double bDistance = double.parse(
            b.distance.replaceAll(RegExp(r'[^0-9.]'), ''),
          );
          return aDistance.compareTo(bDistance);
        });
        return sorted;

      case 'Top Rated':
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        return sorted;

      case 'Low to High':
        sorted.sort((a, b) => a.price.compareTo(b.price));
        return sorted;

      case 'High to Low':
        sorted.sort((a, b) => b.price.compareTo(a.price));
        return sorted;

      default:
        return sorted;
    }
  }
}
