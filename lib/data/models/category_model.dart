import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  final String title;
  final IconData iconData;
  final Color color;
  final Color iconColor;
  
  const CategoryModel({
    required this.color,
    required this.iconData,
    required this.title,
    required this.iconColor,
  });
}
