import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import 'package:ehtirafy_app/features/client/notifications/domain/entities/notification_entity.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
  Future<Either<Failure, void>> markAsRead(String id);
}
