import 'package:equatable/equatable.dart';

class PortfolioItemEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String?
  image; // Nullable as it might not be in the response example, but likely exists
  final DateTime createdAt;

  const PortfolioItemEntity({
    required this.id,
    required this.title,
    required this.description,
    this.image,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, description, image, createdAt];
}
