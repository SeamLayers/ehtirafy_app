import 'package:equatable/equatable.dart';

class SearchResultEntity extends Equatable {
  final String id;
  final String title;
  final String type; // 'history', 'freelancer', 'service'
  final String? imageUrl;
  final double? rating;
  final String? category;
  final int? reviewsCount;

  const SearchResultEntity({
    required this.id,
    required this.title,
    required this.type,
    this.imageUrl,
    this.rating,
    this.category,
    this.reviewsCount,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    type,
    imageUrl,
    rating,
    category,
    reviewsCount,
  ];
}
