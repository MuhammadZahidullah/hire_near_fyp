import 'package:flutter/material.dart';
import 'package:hire_near_fyp/core/widgets/search_bar.dart';
import 'package:hire_near_fyp/feature/category/widgets/category_top_bar.dart';
import 'package:hire_near_fyp/feature/category/widgets/filter_chips_row.dart';
import 'package:hire_near_fyp/feature/category/widgets/post_job_banner.dart';
import 'package:hire_near_fyp/features/home/popular_workers/models/category_worker_model.dart';
import 'package:hire_near_fyp/features/home/widgets/buttom_nav_bar.dart';
import 'package:hire_near_fyp/features/home/widgets/category_worker_cartd.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryName;
  final String categorySubtitle;
  final IconData categoryIcon;
  final Color iconColor;
  final Color iconBgColor;
  final List<CategoryWorkerModel> workers;
  const CategoryScreen({
    super.key,
    required this.categoryName,
    required this.categorySubtitle,
    required this.categoryIcon,
    required this.iconColor,
    required this.iconBgColor,
    required this.workers,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ButtomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CategoryTopBar(
                title: widget.categoryName,
                subtitle: widget.categorySubtitle,
                icon: widget.categoryIcon,
                iconColor: widget.iconColor,
                iconBgColor: widget.iconBgColor,
                notificationCount: 3,
                onBackTap: () => Navigator.pop(context),
              ),
              AppSearchBar(hintText: 'search'),
              FilterChipsRow(
                onFilterSelected: (filter) {
                  //handle filters here
                },
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.workers.length,
                itemBuilder: (context, index) {
                  return CategoryWorkerCartd(
                    onTap: () {},
                    worker: widget.workers[index],
                  );
                },
              ),
              PostJobBanner(
                title: 'Can\'t find the right ${widget.categoryName}?',
                subtitle: 'Post a job and let workers come to you.',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
