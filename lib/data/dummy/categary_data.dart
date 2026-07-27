import 'package:flutter/material.dart';
import 'package:hire_near_fyp/data/models/category_model.dart';
import 'package:hire_near_fyp/features/home/popular_workers/data/category_worker_data.dart';

class CategaryData {
  static List<CategoryModel> categories = [
    CategoryModel(
      color: Color(0xFFEDE7F6),
      iconData: Icons.maps_home_work_rounded,
      title: 'Messon',
      iconColor: Color(0xFF7C3AED),
      workers: CategoryWorkerData.messons,
    ),
    CategoryModel(
      color: Color(0xFFFEF3C7),
      iconData: Icons.electrical_services,
      title: 'Electrician',
      iconColor: Color(0xFFF59E0B),
      workers: CategoryWorkerData.electricians,
    ),
    CategoryModel(
      color: Color(0xFFEDE7F6),
      iconData: Icons.plumbing,
      title: 'Pulumber',
      iconColor: Color(0xFF6D28D9),
      workers: CategoryWorkerData.plumbers,
    ),
    CategoryModel(
      color: Color(0xFFE8F5E9),
      iconData: Icons.drive_eta,
      title: 'Driver',
      iconColor: Color(0xFF16A34A),
      workers: CategoryWorkerData.drivers,
    ),
    CategoryModel(
      color: Color(0xFFE3F2FD),
      iconData: Icons.cleaning_services,
      iconColor: Color(0xFF2563EB),
      title: 'Cleaner',
      workers: CategoryWorkerData.cleaners,
    ),
    CategoryModel(
      color: Color(0xFFFFF3E0),
      iconData: Icons.handyman,
      title: 'Carpenter',
      iconColor: Color(0xFFD97706),
      workers: CategoryWorkerData.carpenters,
    ),
    CategoryModel(
      color: Color(0xFFE0F7FA),
      iconData: Icons.build,
      title: 'Mechanic',
      iconColor: Color(0xFF0891B2),
      workers: CategoryWorkerData.mechanics,
    ),
    CategoryModel(
      color: Color(0xFFE8EAF6),
      iconData: Icons.grid_view,
      title: 'More',
      iconColor: Color(0xFF3949AB),
      workers: [], // empty for now
    ),
  ];
}
