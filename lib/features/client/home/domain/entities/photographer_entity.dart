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

  /// Localized ad city (from the advertisements feed). Empty when the ad/
  /// freelancer has no city. Used both for display and client-side filtering.
  final String cityAr;
  final String cityEn;

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
    this.cityAr = '',
    this.cityEn = '',
  });

  /// Display location: prefers the ad's city (Arabic-first for this app, then
  /// English), falling back to the legacy [location] (country code).
  String get displayLocation {
    if (cityAr.trim().isNotEmpty) return cityAr.trim();
    if (cityEn.trim().isNotEmpty) return cityEn.trim();
    return location;
  }

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
    cityAr,
    cityEn,
  ];
}
