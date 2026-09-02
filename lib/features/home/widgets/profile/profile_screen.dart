import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/auth/providers/auth_provider.dart';
import 'package:hire_near_fyp/feature/auth/screens/login_screen.dart';
import 'package:hire_near_fyp/feature/become_worker/become_worker_screen/become_worker_screen.dart';
import 'package:hire_near_fyp/feature/notifications/screens/notifications_screen.dart';
import 'package:hire_near_fyp/feature/worker/screens/worker_dashboard.dart';
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
  // dark mode toggle state
  bool isDarkMode = true;

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

              ProfilHeroCard(onEditTap: () {}, user: user),
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
                  if (isWorker)
                    MenuItemTile(
                      icon: Icons.dashboard_outlined,
                      label: 'Worker Dashboard',
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WorkerDashboard(),
                          ),
                        );
                      },
                    ),
                  MenuItemTile(
                    icon: Icons.person_outline,
                    label: 'Persnal Information',
                    onTap: () {},
                  ),
                  MenuItemTile(
                    icon: Icons.location_on_outlined,
                    label: 'My Addresses',
                    onTap: () {},
                  ),
                  MenuItemTile(
                    icon: Icons.credit_card_outlined,
                    label: 'Payment Methods',
                    onTap: () {},
                  ),
                  MenuItemTile(
                    icon: Icons.lock_outline,
                    label: 'Privacy & Security',
                    onTap: () {},
                  ),
                ],
                title: 'Account',
              ),
              // MenuSection(items: , title: title),
              const SizedBox(height: 16),

              MenuSection(
                title: 'preferences',
                items: [
                  MenuItemTile(
                    icon: Icons.dark_mode_outlined,
                    label: 'Dark Mode',
                    onTap: () {},

                    trailing: Switch(
                      value: isDarkMode,
                      onChanged: (val) => setState(() => isDarkMode = val),

                      activeThumbColor: Color(0xFF5B3FE4),
                    ),
                  ),
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
                  MenuItemTile(
                    icon: Icons.language,
                    label: 'Language',
                    onTap: () {},
                    trailing: Text(
                      'English',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              MenuSection(
                title: 'Support',
                items: [
                  MenuItemTile(
                    icon: Icons.help_outline,
                    label: 'Help & Support',
                    onTap: () {},
                  ),
                  MenuItemTile(
                    icon: Icons.info_outline,
                    label: 'About HireNear',
                    onTap: () {},
                  ),
                  // ✅ New
                  MenuItemTile(
                    icon: Icons.logout,
                    label: 'Logout',
                    isDanger: true,
                    onTap: () {
                      // Step 1 — logout from AuthProvider
                      context.read<AuthProvider>().logout();

                      // Step 2 — go to LoginScreen
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false,
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
