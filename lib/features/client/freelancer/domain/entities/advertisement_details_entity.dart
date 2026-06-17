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
  final String categoryName;
  final List<String> daysAvailability;
  final List<String> images;

  /// Advertiser mobile number used by the "Contact via Mobile" action.
  /// Empty when the backend does not expose it yet.
  final String ownerPhone;

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
    this.categoryName = '',
    this.daysAvailability = const [],
    this.images = const [],
    this.ownerPhone = '',
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
    categoryName,
    daysAvailability,
    images,
    ownerPhone,
  ];
}
