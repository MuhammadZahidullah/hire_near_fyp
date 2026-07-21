import 'package:flutter/material.dart';
import 'package:hire_near_fyp/core/widgets/app_snack_bar.dart';
import 'package:hire_near_fyp/feature/review/models/review_model.dart';
import 'package:hire_near_fyp/feature/review/providers/review_provider.dart';
import 'package:provider/provider.dart';
//import your ReviewProvider path;
//import your ReviewModel path;

class AddReviewSheet extends StatefulWidget {
  final int workerId;
  final String workerName;
  final String userName;

  const AddReviewSheet({
    super.key,
    required this.workerId,
    required this.workerName,
    required this.userName,
  });

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Review ${widget.workerName}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 16),

          // Star Rating
          Text(
            'Select Rating',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRating = index + 1.0;
                  });
                },
                child: Icon(
                  index < _selectedRating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 36,
                ),
              );
            }),
          ),

          SizedBox(height: 16),

          // Comment
          Text(
            'Your Review',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Write your experience...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF6C3CE1)),
              ),
            ),
          ),

          SizedBox(height: 20),

          // Submit Button
          GestureDetector(
            onTap: () {
              // validate
              if (_selectedRating == 0) {
                AppSnackBar.showWarning(context, 'Please select a rating');
                return;
              }

              if (_commentController.text.isEmpty) {
                AppSnackBar.showWarning(context, 'Please write a comment');
                return;
              }

              // add review
              context.read<ReviewProvider>().addReview(
                ReviewModel(
                  id: DateTime.now().millisecondsSinceEpoch,
                  workerId: widget.workerId,
                  workerName: widget.workerName,
                  userName: widget.userName,
                  rating: _selectedRating,
                  comment: _commentController.text.trim(),
                  date: DateTime.now(),
                ),
              );

              // close sheet
              Navigator.pop(context);

              // show success
              AppSnackBar.showSuccess(context, 'Review added successfully!');
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Color(0xFF6C3CE1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Submit Review',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}
