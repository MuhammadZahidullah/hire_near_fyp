class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String type; // 'booking' 'cancel' 'general'
  final DateTime time;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.time,
    this.isRead = false, // default not read
  });

  // copyWith for updating isRead
  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      message: message,
      type: type,
      time: time,
      isRead: isRead ?? this.isRead,
    );
  }
}
