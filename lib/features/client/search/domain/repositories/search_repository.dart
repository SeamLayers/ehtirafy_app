import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import 'package:ehtirafy_app/features/client/search/domain/entities/search_result_entity.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<SearchResultEntity>>> getSearchHistory();
  Future<Either<Failure, List<SearchResultEntity>>> search(String query);
  Future<Either<Failure, void>> saveSearchToHistory(String query);
  Future<Either<Failure, void>> deleteSearchFromHistory(String query);
  Future<Either<Failure, void>> clearSearchHistory();
}
