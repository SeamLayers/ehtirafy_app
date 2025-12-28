import 'package:equatable/equatable.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/app_statistics.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/category_entity.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/photographer_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<PhotographerEntity> featuredPhotographers;
  final List<CategoryEntity> categories;
  final AppStatistics? appStatistics;
  final String userName;

  HomeLoaded({
    required this.featuredPhotographers,
    required this.categories,
    this.appStatistics,
    this.userName = 'عميلنا العزيز',
  });

  @override
  List<Object> get props => [
    featuredPhotographers,
    categories,
    if (appStatistics != null) appStatistics!,
    userName,
  ];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
