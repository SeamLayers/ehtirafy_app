import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import 'package:ehtirafy_app/features/client/notifications/domain/entities/notification_entity.dart';
import 'package:ehtirafy_app/features/client/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:ehtirafy_app/features/client/notifications/presentation/cubits/notifications_state.dart';
import 'package:ehtirafy_app/features/client/notifications/domain/usecases/mark_notification_read_usecase.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationReadUseCase markNotificationReadUseCase;
  List<NotificationEntity> _allNotifications = [];

  NotificationsCubit({
    required this.getNotificationsUseCase,
    required this.markNotificationReadUseCase,
  }) : super(NotificationsInitial());

  Future<void> getNotifications() async {
    emit(NotificationsLoading());
    final result = await getNotificationsUseCase();
    result.fold(
      (failure) => emit(NotificationsError(_mapFailureToMessage(failure))),
      (notifications) {
        _allNotifications = notifications;
        emit(NotificationsLoaded(notifications: notifications));
      },
    );
  }

  void filterNotifications(String filter) {
    if (state is NotificationsLoaded) {
      if (filter == 'unread') {
        final unread = _allNotifications.where((n) => n.isUnread).toList();
        emit(NotificationsLoaded(notifications: unread, filter: filter));
      } else {
        emit(
          NotificationsLoaded(notifications: _allNotifications, filter: filter),
        );
      }
    }
  }

  Future<void> markAsRead(String id) async {
    final index = _allNotifications.indexWhere((n) => n.id == id);
    if (index != -1 && _allNotifications[index].isUnread) {
      await markNotificationReadUseCase(id);

      // Re-fetch to update state
      await getNotifications();
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.message;
      case CacheFailure:
        return AppStrings.failureCache;
      case NetworkFailure:
        return AppStrings.failureNetwork;
      default:
        return AppStrings.failureUnexpected;
    }
  }
}
