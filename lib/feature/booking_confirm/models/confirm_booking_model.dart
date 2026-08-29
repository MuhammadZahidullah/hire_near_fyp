class ConfirmBookingModel {
  final String? workerId;
  final String workerName;
  final String workerRole;
  final double workerRating;
  final int workerReviews;
  final bool isVerified;
  final int serviceCharge;
  final int bookingFee;
  final String location;
  final String date;
  final String time;
  final String service;
  final String imageUrl;

  // total is calculated automatically
  int get totalAmount => serviceCharge + bookingFee;

  const ConfirmBookingModel({
    this.workerId,
    required this.workerName,
    required this.workerRole,
    required this.workerRating,
    required this.workerReviews,
    required this.isVerified,
    required this.serviceCharge,
    required this.bookingFee,
    required this.location,
    required this.date,
    required this.time,
    required this.service,
    required this.imageUrl,
  });
}
