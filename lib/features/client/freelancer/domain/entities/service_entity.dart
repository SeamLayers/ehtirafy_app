import 'package:equatable/equatable.dart';

class ServiceEntity extends Equatable {
  final String id;
  final String title;
  final double price;
  final String description;

  const ServiceEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    this.imageUrl,
    this.daysAvailability = const [],
  });

  final String? imageUrl;
  final List<String> daysAvailability;

  @override
  List<Object?> get props => [
    id,
    title,
    price,
    description,
    imageUrl,
    daysAvailability,
  ];
}
