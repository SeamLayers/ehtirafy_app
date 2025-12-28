import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/app_statistics.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/category_entity.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/photographer_entity.dart';
import 'package:ehtirafy_app/features/client/home/domain/usecases/get_app_statistics_usecase.dart';
import 'package:ehtirafy_app/features/client/home/domain/usecases/get_categories_usecase.dart';
import 'package:ehtirafy_app/features/client/home/domain/usecases/get_featured_photographers_usecase.dart';
import 'package:ehtirafy_app/features/client/home/presentation/cubits/home_state.dart';
import 'package:ehtirafy_app/features/shared/auth/data/datasources/user_local_data_source.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetFeaturedPhotographersUseCase getFeaturedPhotographersUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetAppStatisticsUseCase getAppStatisticsUseCase;
  final UserLocalDataSource userLocalDataSource;

  HomeCubit({
    required this.getFeaturedPhotographersUseCase,
    required this.getCategoriesUseCase,
    required this.getAppStatisticsUseCase,
    required this.userLocalDataSource,
  }) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());

    final user = await userLocalDataSource.getUser();

    // Fetch in parallel with partial success handling
    // We map each future to return a default value on failure instead of throwing
    final results = await Future.wait([
      // 0: Photographers
      getFeaturedPhotographersUseCase().then(
        (result) => result.fold(
          (l) => <PhotographerEntity>[], // Return empty list on failure
          (r) => r,
        ),
      ),
      // 1: Categories
      getCategoriesUseCase().then(
        (result) => result.fold(
          (l) => <CategoryEntity>[], // Return empty list on failure
          (r) => r,
        ),
      ),
      // 2: Statistics
      getAppStatisticsUseCase().then(
        (result) => result.fold(
          (l) => null, // Return null on failure
          (r) => r,
        ),
      ),
    ]);

    final photographers = results[0] as List<PhotographerEntity>;
    final categories = results[1] as List<CategoryEntity>;
    final stats = results[2] as AppStatistics?;

    // Always emit loaded state with whatever data we managed to get
    // We only rely on local user data which is already fetched safely above
    emit(
      HomeLoaded(
        featuredPhotographers: photographers,
        categories: categories,
        appStatistics: stats,
        userName: user?.name ?? 'عميلنا العزيز',
      ),
    );
  }
}
