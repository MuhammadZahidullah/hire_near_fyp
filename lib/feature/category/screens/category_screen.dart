import 'package:flutter/material.dart';
import 'package:hire_near_fyp/core/widgets/search_bar.dart';
import 'package:hire_near_fyp/feature/category/provider/category_provider.dart';
import 'package:hire_near_fyp/feature/category/widgets/category_top_bar.dart';
import 'package:hire_near_fyp/feature/category/widgets/filter_chips_row.dart';
import 'package:hire_near_fyp/feature/category/widgets/post_job_banner.dart';
import 'package:hire_near_fyp/feature/search/providers/search_provider.dart';
import 'package:hire_near_fyp/features/home/popular_workers/models/category_worker_model.dart';
import 'package:hire_near_fyp/features/home/widgets/buttom_nav_bar.dart';
import 'package:hire_near_fyp/features/home/widgets/category_worker_cartd.dart';
import 'package:provider/provider.dart';

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
  void dispose() {
    context.read<SearchProvider>().clearSearch();
    context.read<CategoryProvider>().resetFilter();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();
    final filteredWorkers = searchProvider.getFilteredCategoryWorkers(
      widget.workers,
    );
    // Category Provider
    final categoryProvider = context.watch<CategoryProvider>();
    final sortedWorkers = categoryProvider.getSortedWorkers(
      filteredWorkers,
    ); // ← sorts already filtered
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
              AppSearchBar(
                hintText: 'Search ${widget.categoryName}...',
                onChanged: (query) {
                  context.read<SearchProvider>().updateQuery(query);
                },
              ),
              FilterChipsRow(
                onFilterSelected: (filter) {
                  //handle filters here

                  context.read<CategoryProvider>().setFilter(filter);
                },
              ),

              // ✅ New
              sortedWorkers.isEmpty
                  ? Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 60,
                              color: Colors.grey.shade300,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'No workers found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: sortedWorkers.length,
                      itemBuilder: (context, index) {
                        return CategoryWorkerCartd(
                          worker: sortedWorkers[index],
                          onTap: () {},
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
