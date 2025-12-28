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
    // Handle rating as 'rate' (string) or 'rating' (number)
    double rating = 0.0;
    final rateData = json['rate'] ?? json['rating'];
    if (rateData is num) {
      rating = rateData.toDouble();
    } else if (rateData is String) {
      rating = double.tryParse(rateData) ?? 0.0;
    }

    // Format date from created_at
    String formattedDate = '';
    final createdAt = json['created_at'] ?? json['date'];
    if (createdAt != null) {
      try {
        final date = DateTime.parse(createdAt.toString());
        formattedDate =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      } catch (e) {
        formattedDate = createdAt.toString();
      }
    }

    return ReviewModel(
      id: json['id']?.toString() ?? '',
      userName: json['user_name'] ?? json['client_name'] ?? 'عميل',
      userImage: json['user_image'] ?? json['client_avatar'],
      rating: rating,
      date: formattedDate,
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
