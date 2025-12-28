import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import 'package:ehtirafy_app/features/shared/reviews/domain/usecases/add_rate_usecase.dart';
import 'package:ehtirafy_app/features/shared/reviews/domain/usecases/get_user_rates_usecase.dart';
import 'package:ehtirafy_app/features/shared/reviews/presentation/cubits/reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final AddRateUseCase addRateUseCase;
  final GetUserRatesUseCase getUserRatesUseCase;

  ReviewsCubit({
    required this.addRateUseCase,
    required this.getUserRatesUseCase,
  }) : super(ReviewsInitial());

  Future<void> addRate({
    required String ratedUserId,
    required String advertisementId,
    required double rating,
    required String comment,
  }) async {
    emit(ReviewsLoading());
    final result = await addRateUseCase(
      ratedUserId: ratedUserId,
      advertisementId: advertisementId,
      rating: rating,
      comment: comment,
    );

    result.fold(
      (failure) => emit(ReviewsError(_mapFailureToMessage(failure))),
      (_) => emit(const ReviewsActionSuccess(AppStrings.success)),
    );
  }

  Future<void> getUserRates({required String userId}) async {
    emit(ReviewsLoading());
    final result = await getUserRatesUseCase(userId: userId);

    result.fold(
      (failure) => emit(ReviewsError(_mapFailureToMessage(failure))),
      (reviews) => emit(ReviewsLoaded(reviews)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return AppStrings.failureUnexpected;
  }
}
