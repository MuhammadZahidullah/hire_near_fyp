import 'package:flutter/material.dart';
import 'package:hire_near_fyp/data/models/user_model.dart';
import 'package:hire_near_fyp/features/home/widgets/profile/stat_badge.dart';

class ProfilHeroCard extends StatelessWidget {
  final UserModel user; // ← add this
  final VoidCallback onEditTap;
  const ProfilHeroCard({
    super.key,
    required this.onEditTap,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            Color(0xFF5B3FE4), // dark purple (left)
            Color(0xFF7C5CF6), // light purple (right)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),

      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: Colors.white24,
                child: Text(
                  user.name[0], // first letter of name
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                // takes remaining space
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // align text to left
                  children: [
                    Text(
                      user.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.email,
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      user.location,
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: onEditTap,
                icon: const Icon(Icons.edit, color: Colors.white, size: 14),
                label: const Text(
                  "Edit Profile",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white38),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Stats Row with dividers
          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: StatBadge(
                    icon: Icons.calendar_today_outlined,
                    value: '${user.bookings}',
                    label: 'Bookings',
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.white30),
                Expanded(
                  child: StatBadge(
                    icon: Icons.star,
                    value: '${user.rating}',
                    label: 'Rating',
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.white30),
                Expanded(
                  child: StatBadge(
                    icon: Icons.account_balance_wallet,
                    value: 'PKR ${user.totalSpent.toInt()}',
                    label: 'Total Spent',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
