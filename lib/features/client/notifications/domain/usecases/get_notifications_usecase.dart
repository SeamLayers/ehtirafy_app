import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import 'package:ehtirafy_app/features/client/notifications/domain/entities/notification_entity.dart';
import 'package:ehtirafy_app/features/client/notifications/domain/repositories/notifications_repository.dart';

class GetNotificationsUseCase {
  final NotificationsRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<Either<Failure, List<NotificationEntity>>> call() async {
    return await repository.getNotifications();
  }
}
