import 'package:equatable/equatable.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/photographer_entity.dart';

abstract class CategoryAdvertisementsState extends Equatable {
  const CategoryAdvertisementsState();

  @override
  List<Object?> get props => [];
}

class CategoryAdvertisementsInitial extends CategoryAdvertisementsState {}

class CategoryAdvertisementsLoading extends CategoryAdvertisementsState {}

class CategoryAdvertisementsLoaded extends CategoryAdvertisementsState {
  final List<PhotographerEntity> photographers;
  final String categoryName;

  const CategoryAdvertisementsLoaded({
    required this.photographers,
    required this.categoryName,
  });

  @override
  List<Object?> get props => [photographers, categoryName];
}

class CategoryAdvertisementsEmpty extends CategoryAdvertisementsState {
  final String categoryName;

  const CategoryAdvertisementsEmpty({required this.categoryName});

  @override
  List<Object?> get props => [categoryName];
}

class CategoryAdvertisementsError extends CategoryAdvertisementsState {
  final String message;

  const CategoryAdvertisementsError({required this.message});

  @override
  List<Object?> get props => [message];
}
