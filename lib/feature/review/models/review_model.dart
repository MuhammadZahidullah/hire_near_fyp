import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String? firestoreId; // Firestore document ID

  // Linking fields (Req 4)
  final String bookingId; // Firestore doc ID of the booking
  final String workerId; // Firebase Auth UID of the worker
  final String customerId; // Firebase Auth UID of the customer
  final String customerName; // display name

  // Review content
  final double rating; // 1–5
  final String comment;
  final DateTime createdAt;

  // Alias used by ReviewCard widget
  String get userName => customerName;
  DateTime get date => createdAt;

  const ReviewModel({
    this.firestoreId,
    required this.bookingId,
    required this.workerId,
    required this.customerId,
    required this.customerName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'workerId': workerId,
      'customerId': customerId,
      'customerName': customerName,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ReviewModel.fromMap(
    Map<String, dynamic> map, {
    String? firestoreId,
  }) {
    DateTime parsedDate;
    final raw = map['createdAt'];
    if (raw is Timestamp) {
      parsedDate = raw.toDate();
    } else if (raw is DateTime) {
      parsedDate = raw;
    } else {
      parsedDate = DateTime.now();
    }

    return ReviewModel(
      firestoreId: firestoreId,
      bookingId: map['bookingId'] as String? ?? '',
      workerId: map['workerId'] as String? ?? '',
      customerId: map['customerId'] as String? ?? '',
      customerName: map['customerName'] as String? ?? 'Anonymous',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      comment: map['comment'] as String? ?? '',
      createdAt: parsedDate,
    );
  }
}
