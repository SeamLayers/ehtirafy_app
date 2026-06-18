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

  Future<void> search(String query, {String? type}) async {
    if (query.trim().isEmpty) return;

    if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;
      final effectiveType = type ?? currentState.selectedType;
      emit(currentState.copyWith(isSearching: true, selectedType: effectiveType));

      final result = await searchUseCase.search(query, type: effectiveType);

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
              selectedType: effectiveType,
              lastQuery: query,
            ),
          );
        },
      );
    }
  }

  /// Switches the active result type. If there's an active query, re-runs the
  /// search against the new type.
  Future<void> setType(String type) async {
    if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;
      if (currentState.selectedType == type) return;
      emit(currentState.copyWith(selectedType: type));

      final query = currentState.lastQuery;
      if (query != null && query.trim().isNotEmpty) {
        await search(query, type: type);
      }
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
