class BookingModel {
  final int id;
  final String? userId;

  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final String? customerLocation;

  final String? workerId;
  final String? workerSkill;
  final String? firestoreId;
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
    this.userId,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.customerLocation,
    this.workerId,
    this.workerSkill,
    this.firestoreId,
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
    String? userId,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? customerLocation,
    String? workerId,
    String? workerSkill,
    String? firestoreId,
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
      userId: userId ?? this.userId,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      customerLocation: customerLocation ?? this.customerLocation,
      workerId: workerId ?? this.workerId,
      workerSkill: workerSkill ?? this.workerSkill,
      firestoreId: firestoreId ?? this.firestoreId,
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
      'userId': userId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'customerLocation': customerLocation,
      'workerId': workerId,
      'workerSkill': workerSkill,
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
      userId: map['userId'] ?? map['customerId'],
      customerName: map['customerName'],
      customerEmail: map['customerEmail'],
      customerPhone: map['customerPhone'] ?? map['phone'],
      customerLocation: map['customerLocation'] ?? map['location'],
      workerId: map['workerId'],
      workerSkill: map['workerSkill'],
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
