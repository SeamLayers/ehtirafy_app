import 'package:ehtirafy_app/features/client/search/domain/entities/search_result_entity.dart';

class SearchResultModel extends SearchResultEntity {
  const SearchResultModel({
    required super.id,
    required super.title,
    required super.type,
    super.imageUrl,
    super.rating,
    super.category,
    super.reviewsCount,
  });

  /// Create from API response for freelancer search
  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      id: json['id']?.toString() ?? '',
      title: json['name']?.toString() ?? json['title']?.toString() ?? '',
      type: 'freelancer',
      imageUrl: json['avatar']?.toString() ?? json['image']?.toString(),
      rating: json['rating'] is num
          ? (json['rating'] as num).toDouble()
          : double.tryParse(json['rating']?.toString() ?? ''),
      category: json['category']?.toString() ?? json['title']?.toString(),
      reviewsCount: (json['reviews_count'] ?? json['reviewsCount']) is num
          ? (json['reviews_count'] ?? json['reviewsCount']).toInt()
          : int.tryParse(
              (json['reviews_count'] ?? json['reviewsCount'])?.toString() ?? '',
            ),
    );
  }

  /// Create from local history entry
  factory SearchResultModel.fromHistory(String query) {
    return SearchResultModel(id: query, title: query, type: 'history');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'imageUrl': imageUrl,
      'rating': rating,
      'category': category,
      'reviewsCount': reviewsCount,
    };
  }
}
