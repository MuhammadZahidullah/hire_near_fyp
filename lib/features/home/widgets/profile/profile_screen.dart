import 'package:flutter/material.dart';
import 'package:hire_near_fyp/data/models/user_model.dart';
import 'package:hire_near_fyp/features/home/widgets/profile/menu_item_tile.dart';
import 'package:hire_near_fyp/features/home/widgets/profile/menu_section.dart';
import 'package:hire_near_fyp/features/home/widgets/profile/profil_hero_card.dart';
import 'package:hire_near_fyp/features/home/widgets/profile/worker_banner.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // dark mode toggle state
  bool isDarkMode = true;

  // dummy user data
  final UserModel user = UserModel(
    name: "InamUllah",
    email: "Inamullah@gmail.com",
    location: "Matta, Swat",
    bookings: 12,
    rating: 4.7,
    totalSpent: 3450,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F6FB),
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

              WorkerBanner(onTap: () {}),
              const SizedBox(height: 24),

              MenuSection(
                items: [
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

                      activeColor: Color(0xFF5B3FE4),
                    ),
                  ),
                  MenuItemTile(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    onTap: () {},
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
                  MenuItemTile(
                    icon: Icons.logout,
                    label: 'Logout',
                    isDanger: true,
                    onTap: () {},
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
