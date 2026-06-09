import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/bookings/models/booking_model.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onTap;

  const BookingCard({super.key, required this.booking, required this.onTap});

  // status badge color
  Color _getStatusColor() {
    switch (booking.status) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // status badge bg color
  Color _getStatusBgColor() {
    switch (booking.status) {
      case 'pending':
        return Colors.orange.shade50;
      case 'completed':
        return Colors.green.shade50;
      case 'cancelled':
        return Colors.red.shade50;
      default:
        return Colors.grey.shade50;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left — Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 80,
                height: 80,
                color: Colors.grey.shade200,
                child: Icon(Icons.person, size: 40, color: Colors.grey),
              ),
            ),

            SizedBox(width: 12),

            // Middle — Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.workerName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    booking.role,
                    style: TextStyle(color: Color(0xFF6C3CE1), fontSize: 13),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          booking.location,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${booking.date} • ${booking.time}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: 8),

            // Right — Status + Price + Arrow
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusBgColor(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    booking.status[0].toUpperCase() +
                        booking.status.substring(1),
                    style: TextStyle(
                      color: _getStatusColor(),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'PKR ${booking.price}',
                  style: TextStyle(
                    color: Color(0xFF6C3CE1),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
