import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/static_page.dart';
import '../repositories/settings_repository.dart';

class GetTermsConditionsUseCase {
  final SettingsRepository repository;

  GetTermsConditionsUseCase(this.repository);

  Future<Either<Failure, StaticPage>> call({String lang = 'ar'}) async {
    return await repository.getTermsConditions(lang: lang);
  }
}
