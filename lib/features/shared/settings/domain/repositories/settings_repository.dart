import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/contact_info.dart';
import '../entities/static_page.dart';

abstract class SettingsRepository {
  Future<Either<Failure, StaticPage>> getPrivacyPolicy({String lang = 'ar'});
  Future<Either<Failure, StaticPage>> getTermsConditions({String lang = 'ar'});
  Future<Either<Failure, ContactInfo>> getContactUs();
}
