class ReviewModel {
  final String id;
  final String serviceId;
  final String userName;
  final String userInitials; // shown in avatar since we have no user photos
  final double rating;
  final String comment;
  final String date;

  const ReviewModel({
    required this.id,
    required this.serviceId,
    required this.userName,
    required this.userInitials,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
