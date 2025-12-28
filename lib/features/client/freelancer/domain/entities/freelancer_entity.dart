import 'package:equatable/equatable.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/entities/service_entity.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/entities/review_entity.dart';

class FreelancerEntity extends Equatable {
  final String id;
  final String name;
  final String title;
  final String location;
  final String bio;
  final double rating;
  final int reviewsCount;
  final int projectsCount;
  final String responseTime;
  final String memberSince;
  final String imageUrl;
  final List<PortfolioItemEntity> portfolio;
  final List<ServiceEntity> services;
  final List<ReviewEntity> reviews;

  const FreelancerEntity({
    required this.id,
    required this.name,
    required this.title,
    required this.location,
    required this.bio,
    required this.rating,
    required this.reviewsCount,
    required this.projectsCount,
    required this.responseTime,
    required this.memberSince,
    required this.imageUrl,
    required this.portfolio,
    this.services = const [],
    this.reviews = const [],
  });

  @override
  List<Object> get props => [
    id,
    name,
    title,
    location,
    bio,
    rating,
    reviewsCount,
    projectsCount,
    responseTime,
    memberSince,
    imageUrl,
    portfolio,
    services,
    reviews,
  ];
}

class PortfolioItemEntity extends Equatable {
  final String id;
  final String title;
  final String category;
  final String imageUrl;

  const PortfolioItemEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
  });

  @override
  List<Object> get props => [id, title, category, imageUrl];
}
