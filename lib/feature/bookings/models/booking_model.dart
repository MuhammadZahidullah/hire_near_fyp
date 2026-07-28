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

  const BookingModel({
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

  // Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workerName': workerName,
      'role': role,
      'location': location,
      'date': date,
      'time': time,
      'price': price,
      'status': status,
      'imageUrl': imageUrl,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'] ?? 0,
      workerName: map['workerName'] ?? '',
      role: map['role'] ?? '',
      location: map['location'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      price: map['price'] ?? 0,
      status: map['status'] ?? 'pending',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
