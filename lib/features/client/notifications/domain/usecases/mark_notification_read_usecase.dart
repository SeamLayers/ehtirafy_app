import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import 'package:ehtirafy_app/features/client/notifications/domain/repositories/notifications_repository.dart';

class MarkNotificationReadUseCase {
  final NotificationsRepository repository;

  MarkNotificationReadUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.markAsRead(id);
  }
}
