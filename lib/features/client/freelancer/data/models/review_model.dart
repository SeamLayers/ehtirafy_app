import '../../domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.userName,
    super.userImage,
    required super.rating,
    required super.date,
    required super.comment,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString() ?? '',
      userName: json['user_name'] ?? json['client_name'] ?? 'Unknown',
      userImage: json['user_image'] ?? json['client_avatar'],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      date: json['date'] ?? json['created_at'] ?? '',
      comment: json['comment'] ?? json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_name': userName,
      'user_image': userImage,
      'rating': rating,
      'date': date,
      'comment': comment,
    };
  }
}
