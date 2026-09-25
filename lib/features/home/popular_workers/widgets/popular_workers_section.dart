import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/booking_confirm/models/confirm_booking_model.dart';
import 'package:hire_near_fyp/feature/booking_confirm/screens/confirm_booking_screen.dart';
import 'package:hire_near_fyp/features/home/popular_workers/models/category_worker_model.dart';
import 'package:hire_near_fyp/features/home/popular_workers/widgets/worker_card.dart';
import 'package:hire_near_fyp/features/home/popular_workers/screens/popular_workers_screen.dart';

class PopularWorkersSection extends StatelessWidget {
  final List<CategoryWorkerModel> workers;
  const PopularWorkersSection({super.key, required this.workers});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular workers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PopularWorkersScreen(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'See all',
                  style: TextStyle(color: Color(0xFF6C3CE1), fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          itemCount: workers.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final worker = workers[index];
            return WorkerCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConfirmBookingScreen(
                      booking: ConfirmBookingModel(
                        workerId: worker.workerId,
                        workerName: worker.name,
                        workerRole: worker.role,
                        workerRating: worker.rating,
                        workerReviews: worker.reviews,
                        isVerified: worker.isVerified,
                        serviceCharge: worker.price,
                        bookingFee: 50,
                        location: '',
                        date: '',
                        time: '',
                        service: worker.role,
                        imageUrl: worker.imageUrl,
                      ),
                    ),
                  ),
                );
              },
              worker: worker,
            );
          },
        ),
      ],
    );
  }
}

