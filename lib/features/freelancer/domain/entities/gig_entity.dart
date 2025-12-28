import 'package:equatable/equatable.dart';

enum GigStatus { active, pending, inactive }

class GigEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String categoryName; // Localized category name from API
  final GigStatus status;
  final String coverImage;
  final DateTime? createdAt;
  final List<String> availability;
  final List<String> images;

  const GigEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    this.categoryName = '',
    required this.status,
    required this.coverImage,
    this.createdAt,
    this.availability = const [],
    this.images = const [],
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    price,
    category,
    categoryName,
    status,
    coverImage,
    createdAt,
    availability,
    images,
  ];
}
