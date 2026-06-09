import 'package:flutter/material.dart';

class BookingTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final int pendingCount;
  final int completedCount;
  final int cancelledCount;

  const BookingTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.pendingCount,
    required this.completedCount,
    required this.cancelledCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTab(
            index: 0,
            label: 'Pending',
            icon: Icons.hourglass_empty,
            count: pendingCount,
            activeColor: Color(0xFF6C3CE1),
          ),
          _buildTab(
            index: 1,
            label: 'Completed',
            icon: Icons.check_circle_outline,
            count: completedCount,
            activeColor: Colors.green,
          ),
          _buildTab(
            index: 2,
            label: 'Cancelled',
            icon: Icons.cancel_outlined,
            count: cancelledCount,
            activeColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required int index,
    required String label,
    required IconData icon,
    required int count,
    required Color activeColor,
  }) {
    final bool isActive = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isActive ? activeColor : Colors.grey),
              SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? activeColor : Colors.grey,
                ),
              ),
              SizedBox(width: 4),
              // Count Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive ? activeColor : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
