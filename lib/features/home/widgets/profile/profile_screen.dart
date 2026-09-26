import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/auth/providers/auth_provider.dart';
import 'package:hire_near_fyp/feature/auth/screens/login_screen.dart';
import 'package:hire_near_fyp/feature/become_worker/become_worker_screen/become_worker_screen.dart';
import 'package:hire_near_fyp/feature/favorites/providers/favorites_provider.dart';
import 'package:hire_near_fyp/feature/notifications/screens/notifications_screen.dart';
import 'package:hire_near_fyp/feature/worker/screens/worker_dashboard.dart';
import 'package:hire_near_fyp/features/home/widgets/profile/edit_profile_screen.dart';
import 'package:hire_near_fyp/features/home/widgets/profile/menu_item_tile.dart';
import 'package:hire_near_fyp/features/home/widgets/profile/menu_section.dart';
import 'package:hire_near_fyp/features/home/widgets/profile/profil_hero_card.dart';
import 'package:hire_near_fyp/features/home/widgets/profile/providers/profile_providers.dart';
import 'package:hire_near_fyp/features/home/widgets/profile/worker_banner.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ProfileProvider>().loadProfile();
    });
  }

  // dummy user data

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final user = profileProvider.user;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isWorker = user.isWorker == true || user.activeRole == 'worker';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Profile",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 16),

              ProfilHeroCard(
                onEditTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditProfileScreen(),
                    ),
                  );
                },
                user: user,
              ),
              const SizedBox(height: 16),

              WorkerBanner(
                isWorker: isWorker,
                onTap: () {
                  if (isWorker) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WorkerDashboard(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BecomeWorkerScreen(),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 24),

              MenuSection(
                items: [
                  MenuItemTile(
                    icon: Icons.person_outline,
                    label: 'Personal Information',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfileScreen(),
                        ),
                      );
                    },
                  ),
                ],
                title: 'Account',
              ),
              // MenuSection(items: , title: title),
              const SizedBox(height: 16),

              MenuSection(
                title: 'Preferences',
                items: [
                  MenuItemTile(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              MenuSection(
                title: 'Support',
                items: [
                  MenuItemTile(
                    icon: Icons.info_outline,
                    label: 'About HireNear',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                            'About HireNear',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Local skilled services, made easier.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6C3CE1),
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'HireNear connects customers with local skilled workers, including electricians, plumbers, carpenters, mechanics, painters, and other service professionals.',
                                  style: TextStyle(height: 1.4),
                                ),
                                const SizedBox(height: 12),
                                const Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: 'HireNear began as a Final Year Project by '),
                                      TextSpan(
                                        text: 'Muhammad Zahidullah',
                                        style: TextStyle(fontWeight: FontWeight.w800),
                                      ),
                                      TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Ashfaq Khan',
                                        style: TextStyle(fontWeight: FontWeight.w800),
                                      ),
                                      TextSpan(text: ' and grew from an academic idea into a platform designed to address a real-world problem: connecting people who need services with skilled people who can provide them.'),
                                    ],
                                  ),
                                  style: TextStyle(height: 1.4),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Our vision is to continue improving HireNear beyond the classroom and create more opportunities for local skilled workers.',
                                  style: TextStyle(height: 1.4),
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF4F6FB),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Built locally. Designed for real needs. Growing beyond the classroom.',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black87,
                                      fontSize: 13,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Close',
                                style: TextStyle(color: Color(0xFF6C3CE1)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  MenuItemTile(
                    icon: Icons.logout,
                    label: 'Logout',
                    isDanger: true,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Log out?'),
                          content: const Text('Are you sure you want to log out of HireNear?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                // Step 0 — clear favorites so next user starts fresh
                                context.read<FavoritesProvider>().clearFavorites();

                                // Step 1 — logout from AuthProvider
                                context.read<AuthProvider>().logout();

                                // Step 2 — go to LoginScreen
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                                  (route) => false,
                                );
                              },
                              child: const Text(
                                'Log out',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ), // empty for now
    );
  }
}
