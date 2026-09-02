import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type; // 'booking_request', 'booking_accepted', 'booking_rejected', 'job_completed', etc.
  final String? bookingId;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    this.userId = '',
    required this.title,
    required this.message,
    required this.type,
    this.bookingId,
    this.isRead = false,
    required this.createdAt,
  });

  // Backward compatibility alias for UI code using .time
  DateTime get time => createdAt;

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    String? type,
    String? bookingId,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      bookingId: bookingId ?? this.bookingId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      if (bookingId != null) 'bookingId': bookingId,
      'isRead': isRead,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic>? map, {String docId = ''}) {
    if (map == null) {
      return NotificationModel(
        id: docId,
        userId: '',
        title: '',
        message: '',
        type: 'general',
        bookingId: null,
        isRead: false,
        createdAt: DateTime.now(),
      );
    }

    DateTime parsedDate = DateTime.now();
    final rawCreatedAt = map['createdAt'];
    if (rawCreatedAt is Timestamp) {
      parsedDate = rawCreatedAt.toDate();
    } else if (rawCreatedAt is String) {
      parsedDate = DateTime.tryParse(rawCreatedAt) ?? DateTime.now();
    } else if (rawCreatedAt is int) {
      parsedDate = DateTime.fromMillisecondsSinceEpoch(rawCreatedAt);
    }

    return NotificationModel(
      id: (docId.isNotEmpty ? docId : (map['id']?.toString() ?? '')),
      userId: map['userId']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      message: map['message']?.toString() ?? '',
      type: map['type']?.toString() ?? 'general',
      bookingId: map['bookingId']?.toString(),
      isRead: map['isRead'] == true,
      createdAt: parsedDate,
    );
  }

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return NotificationModel.fromMap(data, docId: doc.id);
  }
}
