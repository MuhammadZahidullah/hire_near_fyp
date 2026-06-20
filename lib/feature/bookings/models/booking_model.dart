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

  BookingModel copyWith({
    int? id,
    String? workerName,
    String? role,
    String? location,
    String? date,
    String? time,
    int? price,
    String? status,
    String? imageUrl,
  }) {
    return BookingModel(
      id: id ?? this.id,
      workerName: workerName ?? this.workerName,
      role: role ?? this.role,
      location: location ?? this.location,
      date: date ?? this.date,
      time: time ?? this.time,
      price: price ?? this.price,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
