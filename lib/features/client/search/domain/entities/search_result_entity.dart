import 'package:equatable/equatable.dart';

class SearchResultEntity extends Equatable {
  final String id;
  final String title;
  final String type; // 'history', 'freelancer', 'service', 'work'
  final String? imageUrl;
  final double? rating;
  final String? category;
  final int? reviewsCount;
  final String? freelancerId;
  final int? price;

  const SearchResultEntity({
    required this.id,
    required this.title,
    required this.type,
    this.imageUrl,
    this.rating,
    this.category,
    this.reviewsCount,
    this.freelancerId,
    this.price,
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
    freelancerId,
    price,
  ];
}
