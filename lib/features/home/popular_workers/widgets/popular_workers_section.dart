import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/booking_confirm/models/confirm_booking_model.dart';
import 'package:hire_near_fyp/feature/booking_confirm/screens/confirm_booking_screen.dart';
import 'package:hire_near_fyp/features/home/popular_workers/models/category_worker_model.dart';
import 'package:hire_near_fyp/features/home/popular_workers/widgets/worker_card.dart';

class PopularWorkersSection extends StatelessWidget {
  final List<CategoryWorkerModel> workers;
  const PopularWorkersSection({super.key, required this.workers});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular workers',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See all',
                  style: TextStyle(color: Colors.deepPurpleAccent),
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
                        location: worker.distance.isNotEmpty
                            ? worker.distance
                            : 'Your Location',
                        date: '12 May 2024',
                        time: '2:00 PM',
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

