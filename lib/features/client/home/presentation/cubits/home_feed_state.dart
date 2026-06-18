import 'package:equatable/equatable.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/category_entity.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/photographer_entity.dart';

abstract class HomeFeedState extends Equatable {
  const HomeFeedState();

  @override
  List<Object?> get props => [];
}

class HomeFeedInitial extends HomeFeedState {}

class HomeFeedLoading extends HomeFeedState {}

class HomeFeedError extends HomeFeedState {
  final String message;
  const HomeFeedError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Loaded feed. [selectedCategoryId] == null means the "All" tab is active.
/// [isAdsLoading] is true while a category filter is being fetched (the
/// category strip stays visible, only the list area shows a spinner).
class HomeFeedLoaded extends HomeFeedState {
  final List<CategoryEntity> categories;
  final List<PhotographerEntity> ads;

  /// Freelancers directory (from all-freelancers-data) shown as a horizontal
  /// rail at the top of the home feed.
  final List<PhotographerEntity> freelancers;
  final int? selectedCategoryId;
  final bool isAdsLoading;
  final String userName;

  const HomeFeedLoaded({
    required this.categories,
    required this.ads,
    this.freelancers = const [],
    required this.selectedCategoryId,
    this.isAdsLoading = false,
    this.userName = '',
  });

  HomeFeedLoaded copyWith({
    List<CategoryEntity>? categories,
    List<PhotographerEntity>? ads,
    List<PhotographerEntity>? freelancers,
    int? selectedCategoryId,
    bool clearSelectedCategory = false,
    bool? isAdsLoading,
    String? userName,
  }) {
    return HomeFeedLoaded(
      categories: categories ?? this.categories,
      ads: ads ?? this.ads,
      freelancers: freelancers ?? this.freelancers,
      selectedCategoryId: clearSelectedCategory
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      isAdsLoading: isAdsLoading ?? this.isAdsLoading,
      userName: userName ?? this.userName,
    );
  }

  @override
  List<Object?> get props => [
    categories,
    ads,
    freelancers,
    selectedCategoryId,
    isAdsLoading,
    userName,
  ];
}
