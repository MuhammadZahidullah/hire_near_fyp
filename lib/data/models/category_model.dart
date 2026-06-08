import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hire_near_fyp/features/home/popular_workers/models/category_worker_model.dart';

class CategoryModel {
  final String title;
  final IconData iconData;
  final Color color;
  final Color iconColor;
  final List<CategoryWorkerModel> workers;
  const CategoryModel({
    required this.color,
    required this.iconData,
    required this.title,
    required this.iconColor,
    required this.workers,
  });
}
