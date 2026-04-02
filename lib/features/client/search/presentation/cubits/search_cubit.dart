import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import 'package:ehtirafy_app/features/client/search/domain/usecases/search_usecase.dart';
import 'package:ehtirafy_app/features/client/search/presentation/cubits/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchUseCase searchUseCase;

  SearchCubit({required this.searchUseCase}) : super(SearchInitial());

  Future<void> loadSearchHistory() async {
    emit(SearchLoading());
    final result = await searchUseCase.getSearchHistory();

    result.fold(
      (failure) => emit(SearchError(_mapFailureToMessage(failure))),
      (history) => emit(SearchLoaded(searchHistory: history)),
    );
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;

    if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;
      emit(currentState.copyWith(isSearching: true));

      final result = await searchUseCase.search(query);

      result.fold(
        (failure) => emit(SearchError(_mapFailureToMessage(failure))),
        (results) async {
          // Reload history since a new search was saved
          final historyResult = await searchUseCase.getSearchHistory();
          final updatedHistory = historyResult.getOrElse(
            () => currentState.searchHistory,
          );

          emit(
            SearchLoaded(
              searchHistory: updatedHistory,
              searchResults: results,
              isSearching: false,
            ),
          );
        },
      );
    }
  }

  Future<void> deleteFromHistory(String query) async {
    if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;

      await searchUseCase.deleteFromHistory(query);

      // Reload history
      final historyResult = await searchUseCase.getSearchHistory();
      historyResult.fold(
        (failure) => null,
        (history) => emit(currentState.copyWith(searchHistory: history)),
      );
    }
  }

  Future<void> clearHistory() async {
    if (state is SearchLoaded) {
      await searchUseCase.clearHistory();
      emit(const SearchLoaded(searchHistory: []));
    }
  }

  void clearSearchResults() {
    if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;
      emit(currentState.copyWith(clearResults: true));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure) {
      case ServerFailure _:
        return failure.message;
      case CacheFailure _:
        return AppStrings.failureCache;
      case NetworkFailure _:
        return AppStrings.failureNetwork;
      default:
        return AppStrings.failureUnexpected;
    }
  }
}
