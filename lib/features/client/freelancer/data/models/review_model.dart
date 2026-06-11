import '../../domain/entities/review_entity.dart';

double _asDouble(dynamic v) {
  if (v is num) return v.toDouble();
  return double.tryParse(v?.toString() ?? '') ?? 0.0;
}

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
      userName:
          (json['user_name'] ?? json['client_name'])?.toString() ?? 'Unknown',
      userImage: (json['user_image'] ?? json['client_avatar'])?.toString(),
      rating: _asDouble(json['rating']),
      date: (json['date'] ?? json['created_at'])?.toString() ?? '',
      comment: (json['comment'] ?? json['description'])?.toString() ?? '',
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
