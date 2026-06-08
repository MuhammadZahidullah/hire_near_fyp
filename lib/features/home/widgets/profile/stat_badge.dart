import 'package:flutter/material.dart';
import 'package:hire_near_fyp/constants/app_colors.dart';

class StatBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const StatBadge({super.key,required this.icon,
    required this.value,
    required this.label,});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color:Colors.white.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        
        children: [
         Icon(icon, color: Colors.white, size: 22),
    const SizedBox(width: 8),

          Column(children: [Icon(icon, color: Colors.white, size: 28),
          SizedBox(height: 8,),
          Text(value, style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),),
           const SizedBox(height: 4),
            Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
          
          ]),
        ],
      ),
    );
  }
}
