import 'package:flutter/material.dart';
import 'package:hire_near_fyp/feature/bookings/models/booking_model.dart';

class WorkerBookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onComplete;
  final VoidCallback? onViewDetails;

  const WorkerBookingCard({
    super.key,
    required this.booking,
    this.onAccept,
    this.onReject,
    this.onComplete,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final customerDisplayName =
        (booking.customerName != null && booking.customerName!.trim().isNotEmpty)
            ? booking.customerName!.trim()
            : 'Customer';

    final serviceName =
        booking.role.trim().isNotEmpty ? booking.role.trim() : 'Service';

    final locationText = booking.location.trim().isNotEmpty
        ? booking.location.trim()
        : (booking.customerLocation != null &&
                booking.customerLocation!.trim().isNotEmpty
            ? booking.customerLocation!.trim()
            : 'Not available');

    final dateTimeText =
        "${booking.date.trim().isNotEmpty ? booking.date.trim() : 'Date not set'} • ${booking.time.trim().isNotEmpty ? booking.time.trim() : 'Time not set'}";

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      const Color(0xFF6C3CE1).withValues(alpha: 0.1),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF6C3CE1),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customerDisplayName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        serviceName,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.work_outline, size: 18),
                const SizedBox(width: 8),
                Text(serviceName),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(locationText),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 18),
                const SizedBox(width: 8),
                Text(dateTimeText),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                const Icon(Icons.payments_outlined, size: 18),
                const SizedBox(width: 8),
                Text(
                  "PKR ${booking.price}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            if (onAccept != null || onReject != null) ...[
              const SizedBox(height: 18),
              Row(
                children: [
                  if (onReject != null)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onReject,
                        child: const Text("Reject"),
                      ),
                    ),
                  if (onAccept != null && onReject != null)
                    const SizedBox(width: 12),
                  if (onAccept != null)
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C3CE1),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: onAccept,
                        child: const Text("Accept"),
                      ),
                    ),
                ],
              ),
            ] else if (onComplete != null) ...[
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onComplete,
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text(
                    "Complete Job",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: onViewDetails,
                child: const Text("View Details"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}