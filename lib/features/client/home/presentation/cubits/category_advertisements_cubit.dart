import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ehtirafy_app/features/client/home/domain/usecases/get_advertisements_by_category_usecase.dart';
import 'package:ehtirafy_app/features/client/home/presentation/cubits/category_advertisements_state.dart';

class CategoryAdvertisementsCubit extends Cubit<CategoryAdvertisementsState> {
  final GetAdvertisementsByCategoryUseCase getAdvertisementsByCategoryUseCase;

  CategoryAdvertisementsCubit({
    required this.getAdvertisementsByCategoryUseCase,
  }) : super(CategoryAdvertisementsInitial());

  Future<void> loadAdvertisements({
    required String categoryId,
    required String categoryName,
  }) async {
    emit(CategoryAdvertisementsLoading());

    final result = await getAdvertisementsByCategoryUseCase(categoryId);

    result.fold(
      (failure) => emit(CategoryAdvertisementsError(message: failure.message)),
      (photographers) {
        if (photographers.isEmpty) {
          emit(CategoryAdvertisementsEmpty(categoryName: categoryName));
        } else {
          emit(
            CategoryAdvertisementsLoaded(
              photographers: photographers,
              categoryName: categoryName,
            ),
          );
        }
      },
    );
  }
}
