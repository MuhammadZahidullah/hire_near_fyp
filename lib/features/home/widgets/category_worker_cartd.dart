import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/auth/providers/auth_provider.dart';
import 'package:hire_near_fyp/feature/booking_confirm/models/confirm_booking_model.dart';
import 'package:hire_near_fyp/feature/booking_confirm/screens/confirm_booking_screen.dart';
import 'package:hire_near_fyp/feature/favorites/providers/favorites_provider.dart';
import 'package:hire_near_fyp/features/home/popular_workers/models/category_worker_model.dart';
import 'package:provider/provider.dart';

class CategoryWorkerCartd extends StatelessWidget {
  final CategoryWorkerModel worker;
  final VoidCallback onTap;

  const CategoryWorkerCartd({
    super.key,
    required this.worker,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavoritesProvider>();
    // Req 5: prevent self-favoriting — hide heart when viewing own profile.
    final currentUid =
        context.read<AuthProvider>().currentUser?.id ?? '';
    final isSelf =
        worker.workerId != null && worker.workerId == currentUid;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(Icons.person, size: 32, color: Colors.grey),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            worker.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        if (worker.isVerified)
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.verified,
                              color: Colors.blue,
                              size: 18,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      worker.role,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6C63FF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Heart button — hidden when viewing own profile (self-favorite guard)
              if (!isSelf)
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    context.read<FavoritesProvider>().toggleFavorite(worker);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      favProvider.isFavorite(worker.workerId)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: favProvider.isFavorite(worker.workerId)
                          ? Colors.red
                          : Colors.grey,
                      size: 24,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 18),
          // INFO ROW
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 18),

              const SizedBox(width: 4),

              Text(
                worker.rating.toString(),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Text(
                  '${worker.reviews} Reviews',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),
              ),

              const Icon(Icons.location_on, color: Colors.grey, size: 18),

              const SizedBox(width: 4),

              Text(
                worker.distance,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
            ],
          ),

          const SizedBox(height: 18),
          Row(
            children: [
              // PRICE CARD
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EEFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'PKR ${worker.price}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6C63FF),
                        ),
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        'Service Fee',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // VIEW PROFILE BUTTON
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    onPressed: () {
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

                    child: const Text(
                      'View Profile',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
