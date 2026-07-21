class ReviewModel {
  final int id;
  final int workerId;
  final String workerName;
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;

  ReviewModel({
    required this.id,
    required this.workerId,
    required this.workerName,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
