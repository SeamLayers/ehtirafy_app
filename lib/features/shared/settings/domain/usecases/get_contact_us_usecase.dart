import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/contact_info.dart';
import '../repositories/settings_repository.dart';

class GetContactUsUseCase {
  final SettingsRepository repository;

  GetContactUsUseCase(this.repository);

  Future<Either<Failure, ContactInfo>> call() async {
    return await repository.getContactUs();
  }
}
