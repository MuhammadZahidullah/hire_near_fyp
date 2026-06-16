import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/booking_confirm/models/confirm_booking_model.dart';

class WorkerSummaryCard extends StatelessWidget {
  final ConfirmBookingModel booking;

  const WorkerSummaryCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Worker Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 90,
              height: 100,
              color: Colors.grey.shade200,
              child: Icon(Icons.person, size: 50, color: Colors.grey),
            ),
          ),

          SizedBox(width: 14),

          // Worker Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  booking.workerName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: 4),

                // Role
                Text(
                  booking.workerRole,
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),

                SizedBox(height: 6),

                // Rating + Reviews Row
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      booking.workerRating.toString(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 6),
                    Container(
                      width: 1,
                      height: 12,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(width: 6),
                    Text(
                      '${booking.workerReviews} Reviews',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),

                SizedBox(height: 6),

                // Verified Badge
                if (booking.isVerified)
                  Row(
                    children: [
                      Icon(Icons.verified, color: Color(0xFF16A34A), size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Verified',
                        style: TextStyle(
                          color: Color(0xFF16A34A),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: 10),

                // Price Box
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rs. ${booking.serviceCharge}',
                        style: TextStyle(
                          color: Color(0xFF16A34A),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Service Charge',
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ],
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
