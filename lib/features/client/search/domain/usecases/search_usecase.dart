import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import 'package:ehtirafy_app/features/client/search/domain/entities/search_result_entity.dart';
import 'package:ehtirafy_app/features/client/search/domain/repositories/search_repository.dart';

class SearchUseCase {
  final SearchRepository repository;

  SearchUseCase(this.repository);

  Future<Either<Failure, List<SearchResultEntity>>> getSearchHistory() async {
    return await repository.getSearchHistory();
  }

  Future<Either<Failure, List<SearchResultEntity>>> search(String query) async {
    // Save to history before searching
    await repository.saveSearchToHistory(query);
    return await repository.search(query);
  }

  Future<Either<Failure, void>> deleteFromHistory(String query) async {
    return await repository.deleteSearchFromHistory(query);
  }

  Future<Either<Failure, void>> clearHistory() async {
    return await repository.clearSearchHistory();
  }
}
