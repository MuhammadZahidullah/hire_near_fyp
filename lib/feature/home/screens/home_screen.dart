import 'package:flutter/material.dart';
import 'package:hire_near_fyp/core/widgets/search_bar.dart';
import 'package:hire_near_fyp/data/dummy/categary_data.dart';
import 'package:hire_near_fyp/feature/become_worker/become_worker_screen/become_worker_screen.dart';
import 'package:hire_near_fyp/feature/category/screens/category_screen.dart';
//import 'package:hire_near_fyp/features/home/popular_workers/data/category_worker_data.dart';
import 'package:hire_near_fyp/features/home/popular_workers/data/worker_data.dart';
import 'package:hire_near_fyp/features/home/popular_workers/widgets/popular_workers_section.dart';
import 'package:hire_near_fyp/features/home/popular_workers/widgets/top_bar.dart';
import 'package:hire_near_fyp/features/home/widgets/become_worker_banner.dart';
//import 'package:hire_near_fyp/features/home/widgets/buttom_nav_bar.dart';
import 'package:hire_near_fyp/features/home/widgets/category_card.dart';
//import 'package:hire_near_fyp/features/home/popular_workers/models/worker_model.dart';
//import 'package:hire_near_fyp/feature/become_worker/become_worker_screen/become_worker_screen.dart';
//import 'package:hire_near_fyp/feature/category/screens/category_screen.dart';
//import 'package:hire_near_fyp/feature/category/screens/category_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //final int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: ButtomNavBar(
      //   currentIndex: _selectedIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _selectedIndex = index;
      //     });
      //   },
      // ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopBar(
              location: 'Lower Dir, Maidan',
              notificationCount: 3,
              userName: 'Developer Muhammad Zahidullah',
            ),
            AppSearchBar(hintText: 'Search a worker here'),

            //Icon(Icons.keyboard_arrow_down_outlined),
            SizedBox(height: 20),
            // ✅ Replace with
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true, // ← key fix
                scrollDirection: Axis.vertical,
                itemCount: CategaryData.categories.length,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.9, // ← adjust
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
            PopularWorkersSection(workers: WorkerData.workerList),
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
