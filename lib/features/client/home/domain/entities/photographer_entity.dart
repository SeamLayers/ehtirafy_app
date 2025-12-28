import 'package:equatable/equatable.dart';

class PhotographerEntity extends Equatable {
  final String id;
  final String name;
  final String category;
  final double rating;
  final int reviewsCount;
  final String location;
  final int price;
  final String imageUrl;
  final List<String> daysAvailability;
  final String freelancerId;

  const PhotographerEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.reviewsCount,
    required this.location,
    required this.price,
    required this.imageUrl,
    this.daysAvailability = const [],
    required this.freelancerId,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    rating,
    reviewsCount,
    location,
    price,
    imageUrl,
    daysAvailability,
    freelancerId,
  ];
}
