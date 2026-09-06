import 'package:flutter/material.dart';
import 'package:hire_near_fyp/core/widgets/app_snack_bar.dart';
import 'package:hire_near_fyp/feature/bookings/models/booking_model.dart';
import 'package:hire_near_fyp/feature/review/models/review_model.dart';
import 'package:hire_near_fyp/feature/review/providers/review_provider.dart';
import 'package:provider/provider.dart';

class AddReviewSheet extends StatefulWidget {
  /// The completed booking being reviewed (Req 5, 7)
  final BookingModel booking;

  const AddReviewSheet({super.key, required this.booking});

  @override
  State<AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<AddReviewSheet> {
  double _selectedRating = 0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  /// Returns true if this booking has already been reviewed
  bool _alreadyReviewed(ReviewProvider provider) {
    final bookingId = widget.booking.firestoreId ?? '';
    return bookingId.isNotEmpty && provider.hasReviewedBooking(bookingId);
  }

  Future<void> _submit(ReviewProvider provider) async {
    // Validate rating
    if (_selectedRating == 0) {
      AppSnackBar.showWarning(context, 'Please select a rating');
      return;
    }

    // Validate comment
    if (_commentController.text.trim().isEmpty) {
      AppSnackBar.showWarning(context, 'Please write a comment');
      return;
    }

    // Guard: bookingId must exist (Req 6)
    final bookingId = widget.booking.firestoreId ?? '';
    if (bookingId.isEmpty) {
      AppSnackBar.showWarning(context, 'Booking ID missing. Cannot submit.');
      return;
    }

    // Guard: workerId must exist (Req 7)
    final workerId = widget.booking.workerId ?? '';
    if (workerId.isEmpty) {
      AppSnackBar.showWarning(context, 'Worker ID missing. Cannot submit.');
      return;
    }

    final customerId = widget.booking.userId ?? '';
    final customerName = (widget.booking.customerName != null &&
            widget.booking.customerName!.trim().isNotEmpty)
        ? widget.booking.customerName!.trim()
        : 'Anonymous';

    final review = ReviewModel(
      bookingId: bookingId,
      workerId: workerId,
      customerId: customerId,
      customerName: customerName,
      rating: _selectedRating,
      comment: _commentController.text.trim(),
      createdAt: DateTime.now(),
    );

    final success = await provider.submitReview(review);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      AppSnackBar.showSuccess(context, 'Review submitted successfully!');
    } else {
      AppSnackBar.showWarning(
        context,
        provider.submitError ?? 'Failed to submit review.',
      );
      provider.clearSubmitError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewProvider>(
      builder: (context, provider, _) {
        // Already reviewed state (Req 6)
        if (_alreadyReviewed(provider)) {
          return _AlreadyReviewedSheet(workerName: widget.booking.workerName);
        }

        final bottomInset = MediaQuery.of(context).viewInsets.bottom;
        final screenHeight = MediaQuery.of(context).size.height;

        return ConstrainedBox(
          // Cap sheet at 90 % of screen so it never exceeds the viewport,
          // while still shrinking naturally when content is small.
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.90,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              // Reserve room for the keyboard so nothing is hidden behind it.
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: bottomInset + 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Title
                  Text(
                    'Review ${widget.booking.workerName}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    widget.booking.role.isNotEmpty
                        ? widget.booking.role
                        : 'Service',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 12),

                  // Star Rating
                  const Text(
                    'Select Rating',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: provider.isSubmitting
                            ? null
                            : () {
                                setState(() {
                                  _selectedRating = index + 1.0;
                                });
                              },
                        child: Icon(
                          index < _selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 30,
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 12),

                  // Comment
                  const Text(
                    'Your Review',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _commentController,
                    maxLines: 3,
                    enabled: !provider.isSubmitting,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Share your experience...',
                      hintStyle: const TextStyle(fontSize: 13),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Color(0xFF6C3CE1)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Submit Button
                  GestureDetector(
                    onTap:
                        provider.isSubmitting ? null : () => _submit(provider),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: provider.isSubmitting
                            ? Colors.grey.shade400
                            : const Color(0xFF6C3CE1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: provider.isSubmitting
                          ? const Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : const Text(
                              'Submit Review',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Shown when the booking has already been reviewed
class _AlreadyReviewedSheet extends StatelessWidget {
  final String workerName;

  const _AlreadyReviewedSheet({required this.workerName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF6C3CE1), size: 64),
          const SizedBox(height: 16),
          const Text(
            'Already Reviewed',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'You have already submitted a review for $workerName.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C3CE1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
