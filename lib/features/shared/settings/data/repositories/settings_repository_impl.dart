import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../data/datasources/settings_remote_datasource.dart';
import '../../domain/entities/contact_info.dart';
import '../../domain/entities/static_page.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;

  SettingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ContactInfo>> getContactUs() async {
    try {
      final result = await remoteDataSource.getContactUs();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, StaticPage>> getPrivacyPolicy({
    String lang = 'ar',
  }) async {
    try {
      final result = await remoteDataSource.getPrivacyPolicy(lang: lang);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, StaticPage>> getTermsConditions({
    String lang = 'ar',
  }) async {
    try {
      final result = await remoteDataSource.getTermsConditions(lang: lang);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
