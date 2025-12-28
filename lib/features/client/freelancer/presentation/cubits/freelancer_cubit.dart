import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/usecases/get_freelancer_profile_usecase.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/cubits/freelancer_state.dart';
import 'package:ehtirafy_app/features/shared/reviews/domain/usecases/get_user_rates_usecase.dart';
import 'package:ehtirafy_app/features/client/freelancer/data/models/freelancer_model.dart';
import 'package:ehtirafy_app/features/client/freelancer/data/models/review_model.dart';

class FreelancerCubit extends Cubit<FreelancerState> {
  final GetFreelancerProfileUseCase getFreelancerProfileUseCase;
  final GetUserRatesUseCase? getUserRatesUseCase;

  FreelancerCubit({
    required this.getFreelancerProfileUseCase,
    this.getUserRatesUseCase,
  }) : super(FreelancerInitial());

  Future<void> getFreelancerProfile(String id) async {
    emit(FreelancerLoading());

    final result = await getFreelancerProfileUseCase(id);

    await result.fold(
      (failure) async => emit(FreelancerError(failure.message)),
      (freelancer) async {
        // Try to fetch reviews separately
        List<ReviewModel> reviews = [];
        if (getUserRatesUseCase != null) {
          final reviewsResult = await getUserRatesUseCase!(userId: id);
          reviewsResult.fold(
            (failure) => reviews = [], // Fail silently for reviews
            (data) {
              // Convert shared ReviewEntity to freelancer ReviewModel
              reviews = data
                  .map(
                    (r) => ReviewModel(
                      id: r.id,
                      userName: r.userName,
                      userImage: r.userImage,
                      rating: r.rating,
                      date: r.date,
                      comment: r.comment,
                    ),
                  )
                  .toList();
            },
          );
        }

        // Create updated freelancer with reviews
        final updatedFreelancer = FreelancerModel(
          id: freelancer.id,
          name: freelancer.name,
          title: freelancer.title,
          location: freelancer.location,
          bio: freelancer.bio,
          rating: freelancer.rating,
          reviewsCount: reviews.isNotEmpty
              ? reviews.length
              : freelancer.reviewsCount,
          projectsCount: freelancer.projectsCount,
          responseTime: freelancer.responseTime,
          memberSince: freelancer.memberSince,
          imageUrl: freelancer.imageUrl,
          portfolio: freelancer.portfolio.cast(),
          services: freelancer.services.cast(),
          reviews: reviews,
        );

        emit(FreelancerLoaded(updatedFreelancer));
      },
    );
  }
}
