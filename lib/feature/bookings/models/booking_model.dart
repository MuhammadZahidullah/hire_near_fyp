class BookingModel {
  final int id;
  final String workerName;
  final String role;
  final String location;
  final String date;
  final String time;
  final int price;
  final String status;
  final String imageUrl;

  BookingModel({
    required this.id,
    required this.workerName,
    required this.role,
    required this.location,
    required this.date,
    required this.time,
    required this.price,
    required this.status,
    required this.imageUrl,
  });
}
