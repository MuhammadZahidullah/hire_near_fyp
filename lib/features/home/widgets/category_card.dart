import 'package:flutter/material.dart';
import 'package:hire_near_fyp/data/models/category_model.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback ontap;
  const CategoryCard({super.key, required this.category, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          // width: 80,
          // height: 80,
          margin: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: category.color.withValues(alpha: .6),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: category.color.withValues(alpha: 0.6)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(category.iconData, size: 28, color: category.iconColor),
              SizedBox(height: 8),
              Text(
                category.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
