import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hire_near_fyp/feature/worker/providers/worker_provider.dart';
import 'package:hire_near_fyp/features/home/popular_workers/widgets/worker_card.dart';
import 'package:hire_near_fyp/feature/booking_confirm/screens/confirm_booking_screen.dart';
import 'package:hire_near_fyp/feature/booking_confirm/models/confirm_booking_model.dart';

class PopularWorkersScreen extends StatelessWidget {
  const PopularWorkersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
        title: const Text(
          'Popular Workers',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<WorkerProvider>(
        builder: (context, provider, child) {
          final workers = provider.rankedWorkers;

          if (workers.isEmpty) {
            return const Center(
              child: Text('No popular workers found.'),
            );
          }

          return ListView.builder(
            itemCount: workers.length,
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
          );
        },
      ),
    );
  }
}
