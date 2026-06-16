import 'package:flutter/material.dart';
import 'package:hire_near_fyp/data/dummy/categary_data.dart';
import 'package:hire_near_fyp/feature/booking_confirm/models/confirm_booking_model.dart';
import 'package:hire_near_fyp/feature/booking_confirm/screens/confirm_booking_screen.dart';
import 'package:hire_near_fyp/features/home/popular_workers/models/category_worker_model.dart';

class CategoryWorkerCartd extends StatelessWidget {
  final CategoryWorkerModel worker;
  final VoidCallback onTap;
  const CategoryWorkerCartd({
    super.key,
    required this.onTap,
    required this.worker,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],

        // boxShadow: BoxShadow(offset: Offset(4, 5))
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 30),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      worker.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 4),
                    worker.isVerified
                        ? Icon(Icons.verified, color: Colors.blue, size: 16)
                        : SizedBox(),
                  ],
                ),
                Text(
                  worker.role,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Color(0xFF6C3CE1), fontSize: 12),
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 15),
                    SizedBox(width: 3),
                    Text(worker.rating.toString()),
                    SizedBox(width: 3),
                    Text(
                      '(${worker.reviews} reviews)',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.grey, size: 14),
                    Text(worker.distance),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFFEDE7F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'PKR ${worker.price}',
                      style: TextStyle(
                        color: Color(0xFF6C3CE1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Service Charge',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              // In category_worker_cartd.dart
              ElevatedButton(
                onPressed: () {
                  print('VIEW PROFILE TAPPED');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfirmBookingScreen(
                        booking: ConfirmBookingModel(
                          workerName: worker.name,
                          workerRole: worker.role,
                          workerRating: worker.rating,
                          workerReviews: worker.reviews,
                          isVerified: worker.isVerified,
                          serviceCharge: worker.price,
                          bookingFee: 50,
                          location: 'Your Location',
                          date: '12 May 2024',
                          time: '2:00 PM',
                          service: worker.role,
                          imageUrl: worker.imageUrl,
                        ),
                      ),
                    ),
                  );
                },
                child: Text('View Profile'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
