import 'package:equatable/equatable.dart';

class WorkDetailsEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String createdAt;
  final String updatedAt;
  final List<String> images;

  const WorkDetailsEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.images = const [],
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    description,
    createdAt,
    updatedAt,
    images,
  ];
}
