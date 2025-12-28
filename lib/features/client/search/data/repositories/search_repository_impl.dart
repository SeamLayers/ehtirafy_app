import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import 'package:ehtirafy_app/features/client/search/data/datasources/search_local_data_source.dart';
import 'package:ehtirafy_app/features/client/search/data/datasources/search_remote_data_source.dart';
import 'package:ehtirafy_app/features/client/search/data/models/search_result_model.dart';
import 'package:ehtirafy_app/features/client/search/domain/entities/search_result_entity.dart';
import 'package:ehtirafy_app/features/client/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final SearchLocalDataSource localDataSource;

  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<SearchResultEntity>>> getSearchHistory() async {
    try {
      final history = await localDataSource.getSearchHistory();
      final results = history
          .map((query) => SearchResultModel.fromHistory(query))
          .toList();
      return Right(results);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SearchResultEntity>>> search(String query) async {
    try {
      final result = await remoteDataSource.search(query);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveSearchToHistory(String query) async {
    try {
      await localDataSource.saveSearch(query);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSearchFromHistory(String query) async {
    try {
      await localDataSource.deleteSearch(query);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearSearchHistory() async {
    try {
      await localDataSource.clearHistory();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
