import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/category_entity.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/photographer_entity.dart';
import 'package:ehtirafy_app/features/client/home/domain/usecases/get_categories_usecase.dart';
import 'package:ehtirafy_app/features/client/home/domain/usecases/get_featured_photographers_usecase.dart';
import 'package:ehtirafy_app/features/client/home/domain/usecases/get_all_freelancers_usecase.dart';
import 'package:ehtirafy_app/features/client/home/domain/usecases/get_advertisements_by_category_usecase.dart';
import 'package:ehtirafy_app/features/shared/auth/data/datasources/user_local_data_source.dart';
import 'package:ehtirafy_app/features/client/home/presentation/cubits/home_feed_state.dart';

/// Drives the Haraj-style home feed: a scrollable category tab strip plus a
/// list of advertisements. The "All" tab (selectedCategoryId == null) shows
/// every advertisement; selecting a category filters the list to that category.
class HomeFeedCubit extends Cubit<HomeFeedState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetFeaturedPhotographersUseCase getFeaturedPhotographersUseCase;
  final GetAllFreelancersUseCase getAllFreelancersUseCase;
  final GetAdvertisementsByCategoryUseCase getAdvertisementsByCategoryUseCase;
  final UserLocalDataSource userLocalDataSource;

  HomeFeedCubit({
    required this.getCategoriesUseCase,
    required this.getFeaturedPhotographersUseCase,
    required this.getAllFreelancersUseCase,
    required this.getAdvertisementsByCategoryUseCase,
    required this.userLocalDataSource,
  }) : super(HomeFeedInitial());

  // Cache of all advertisements so returning to the "All" tab is instant.
  List<PhotographerEntity> _allAds = const [];

  Future<void> load() async {
    emit(HomeFeedLoading());

    final user = await userLocalDataSource.getUser();

    final results = await Future.wait([
      getCategoriesUseCase().then(
        (r) => r.fold((_) => <CategoryEntity>[], (list) => list),
      ),
      getFeaturedPhotographersUseCase().then(
        (r) => r.fold((_) => <PhotographerEntity>[], (list) => list),
      ),
      getAllFreelancersUseCase().then(
        (r) => r.fold((_) => <PhotographerEntity>[], (list) => list),
      ),
    ]);

    final categories = results[0] as List<CategoryEntity>;
    _allAds = results[1] as List<PhotographerEntity>;
    final freelancers = results[2] as List<PhotographerEntity>;

    emit(
      HomeFeedLoaded(
        categories: categories,
        ads: _allAds,
        freelancers: freelancers,
        selectedCategoryId: null,
        userName: user?.name ?? '',
      ),
    );
  }

  /// Select a category tab. Pass `null` to show all advertisements.
  Future<void> selectCategory(int? categoryId) async {
    final current = state;
    if (current is! HomeFeedLoaded) return;
    if (current.selectedCategoryId == categoryId && !current.isAdsLoading) {
      // Re-selecting the active tab is a no-op (avoids redundant fetches).
      if (categoryId != null) return;
    }

    // "All" tab → use the cached full list, no network call.
    if (categoryId == null) {
      emit(
        current.copyWith(
          ads: _allAds,
          clearSelectedCategory: true,
          isAdsLoading: false,
        ),
      );
      return;
    }

    emit(current.copyWith(selectedCategoryId: categoryId, isAdsLoading: true));

    final result = await getAdvertisementsByCategoryUseCase(
      categoryId.toString(),
    );

    final latest = state;
    if (latest is! HomeFeedLoaded) return;
    // Guard against out-of-order responses if the user tapped another tab.
    if (latest.selectedCategoryId != categoryId) return;

    result.fold(
      (_) => emit(latest.copyWith(ads: const [], isAdsLoading: false)),
      (ads) => emit(latest.copyWith(ads: ads, isAdsLoading: false)),
    );
  }

  /// Soft refresh for pull-to-refresh: re-fetches in place WITHOUT emitting
  /// HomeFeedLoading (so the category strip / scroll view stay mounted) and
  /// preserves the currently selected category tab.
  Future<void> refresh() async {
    final current = state;
    if (current is! HomeFeedLoaded) return load();

    final results = await Future.wait([
      getCategoriesUseCase().then(
        (r) => r.fold((_) => current.categories, (list) => list),
      ),
      getFeaturedPhotographersUseCase().then(
        (r) => r.fold((_) => _allAds, (list) => list),
      ),
      getAllFreelancersUseCase().then(
        (r) => r.fold((_) => current.freelancers, (list) => list),
      ),
    ]);
    final categories = results[0] as List<CategoryEntity>;
    _allAds = results[1] as List<PhotographerEntity>;
    final freelancers = results[2] as List<PhotographerEntity>;

    final selectedId = current.selectedCategoryId;
    if (selectedId == null) {
      emit(
        current.copyWith(
          categories: categories,
          ads: _allAds,
          freelancers: freelancers,
          isAdsLoading: false,
        ),
      );
      return;
    }

    final result = await getAdvertisementsByCategoryUseCase(
      selectedId.toString(),
    );
    final latest = state;
    if (latest is! HomeFeedLoaded || latest.selectedCategoryId != selectedId) {
      return;
    }
    result.fold(
      (_) => emit(
        latest.copyWith(
          categories: categories,
          freelancers: freelancers,
          isAdsLoading: false,
        ),
      ),
      (ads) => emit(
        latest.copyWith(
          categories: categories,
          ads: ads,
          freelancers: freelancers,
          isAdsLoading: false,
        ),
      ),
    );
  }
}
