import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/freelancer_portfolio_repository.dart';
import 'freelancer_portfolio_state.dart';

class FreelancerPortfolioCubit extends Cubit<FreelancerPortfolioState> {
  final FreelancerPortfolioRepository repository;

  FreelancerPortfolioCubit({required this.repository})
    : super(FreelancerPortfolioInitial());

  Future<void> loadPortfolio() async {
    emit(FreelancerPortfolioLoading());

    final result = await repository.getPortfolio();

    result.fold(
      (failure) => emit(FreelancerPortfolioError(failure.message)),
      (items) => emit(FreelancerPortfolioLoaded(items: items)),
    );
  }

  Future<void> addPortfolioItem({
    required String title,
    required String description,
    String? imagePath,
  }) async {
    emit(FreelancerPortfolioItemAdding());

    final result = await repository.addPortfolioItem(
      title: title,
      description: description,
      imagePath: imagePath,
    );

    result.fold((failure) => emit(FreelancerPortfolioError(failure.message)), (
      item,
    ) {
      emit(FreelancerPortfolioItemAdded(item));
      loadPortfolio();
    });
  }

  Future<void> updatePortfolioItem({
    required String id,
    required String title,
    required String description,
    String? imagePath,
  }) async {
    emit(
      FreelancerPortfolioItemAdding(),
    ); // Reuse Adding state or create Updating

    final result = await repository.updatePortfolioItem(
      id: id,
      title: title,
      description: description,
      imagePath: imagePath,
    );

    result.fold((failure) => emit(FreelancerPortfolioError(failure.message)), (
      item,
    ) {
      emit(
        FreelancerPortfolioItemAdded(item),
      ); // Reuse Added state or create Updated
      loadPortfolio();
    });
  }

  Future<void> deletePortfolioItem(String itemId) async {
    // Optimistic or waiting? Let's wait.
    // emit(FreelancerPortfolioLoading()); // Maybe not full loading?

    final result = await repository.deletePortfolioItem(itemId);

    result.fold((failure) => emit(FreelancerPortfolioError(failure.message)), (
      _,
    ) {
      loadPortfolio(); // Reload
    });
  }
}
