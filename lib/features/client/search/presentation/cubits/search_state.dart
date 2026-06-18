import 'package:equatable/equatable.dart';
import 'package:ehtirafy_app/features/client/search/domain/entities/search_result_entity.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<SearchResultEntity> searchHistory;
  final List<SearchResultEntity>? searchResults;
  final bool isSearching;
  final String selectedType;
  final String? lastQuery;

  const SearchLoaded({
    required this.searchHistory,
    this.searchResults,
    this.isSearching = false,
    this.selectedType = 'all',
    this.lastQuery,
  });

  SearchLoaded copyWith({
    List<SearchResultEntity>? searchHistory,
    List<SearchResultEntity>? searchResults,
    bool? isSearching,
    String? selectedType,
    String? lastQuery,
    bool clearResults = false,
  }) {
    return SearchLoaded(
      searchHistory: searchHistory ?? this.searchHistory,
      searchResults: clearResults
          ? null
          : (searchResults ?? this.searchResults),
      isSearching: isSearching ?? this.isSearching,
      selectedType: selectedType ?? this.selectedType,
      lastQuery: lastQuery ?? this.lastQuery,
    );
  }

  @override
  List<Object?> get props => [
    searchHistory,
    searchResults,
    isSearching,
    selectedType,
    lastQuery,
  ];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
