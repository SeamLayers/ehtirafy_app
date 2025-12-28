import 'package:equatable/equatable.dart';

class AdvertisementDetailsEntity extends Equatable {
  final String id;
  final String categoryId;
  final String title;
  final String description;
  final int viewerCount;
  final String status;
  final double price;
  final String userId;
  final String createdAt;
  final List<String> daysAvailability;
  final List<String> images;

  const AdvertisementDetailsEntity({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.viewerCount,
    required this.status,
    required this.price,
    required this.userId,
    required this.createdAt,
    this.daysAvailability = const [],
    this.images = const [],
  });

  @override
  List<Object?> get props => [
    id,
    categoryId,
    title,
    description,
    viewerCount,
    status,
    price,
    userId,
    createdAt,
    daysAvailability,
    images,
  ];
}
