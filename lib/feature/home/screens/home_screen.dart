import 'package:flutter/material.dart';
import 'package:hire_near_fyp/core/widgets/search_bar.dart';
import 'package:hire_near_fyp/data/dummy/categary_data.dart';
import 'package:hire_near_fyp/feature/become_worker/become_worker_screen/become_worker_screen.dart';
import 'package:hire_near_fyp/feature/category/screens/category_screen.dart';
import 'package:hire_near_fyp/feature/search/providers/search_provider.dart';
import 'package:hire_near_fyp/features/home/popular_workers/data/worker_data.dart';
import 'package:hire_near_fyp/features/home/popular_workers/widgets/popular_workers_section.dart';
import 'package:hire_near_fyp/features/home/popular_workers/widgets/top_bar.dart';
import 'package:hire_near_fyp/features/home/widgets/become_worker_banner.dart';
import 'package:hire_near_fyp/features/home/widgets/category_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Search Provider
    final searchProvider = context.watch<SearchProvider>();
    final filteredWorkers = searchProvider.getFilteredWorkers(
      WorkerData.workerList,
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1 - Top Bar
            TopBar(
              location: 'Lower Dir, Maidan',
              // notificationCount: 3,
              userName: 'Developer Muhammad Zahidullah',
            ),

            // 2 - Search Bar
            AppSearchBar(
              hintText: 'Search a worker here',
              onChanged: (query) {
                context.read<SearchProvider>().updateQuery(query);
              },
            ),

            SizedBox(height: 20),

            // 3 - Categories Grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: CategaryData.categories.length,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  return CategoryCard(
                    category: CategaryData.categories[index],
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryScreen(
                            categoryName: CategaryData.categories[index].title,
                            categorySubtitle:
                                'Find trusted ${CategaryData.categories[index].title} near you',
                            categoryIcon:
                                CategaryData.categories[index].iconData,
                            iconColor: CategaryData.categories[index].iconColor,
                            iconBgColor: CategaryData.categories[index].color,
                            workers: CategaryData.categories[index].workers,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            SizedBox(height: 8),

            // 4 - Popular Workers or Empty State
            filteredWorkers.isEmpty
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
                          SizedBox(height: 4),
                          Text(
                            'Try searching with different keywords',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : PopularWorkersSection(workers: filteredWorkers),

            // 5 - Become Worker Banner
            BecomeWorkerBanner(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BecomeWorkerScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
