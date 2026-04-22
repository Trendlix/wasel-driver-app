import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/doamin/usecases/get_notifications_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/doamin/usecases/mark_all_notification_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/presentation/manager/notification_states.dart';

class NotificationCubit extends Cubit<NotificationStates> {
  final GetNotificationsUsecase _getNotificationsUsecase;
  final MarkAllNotificationUsecase _markAllNotificationUsecase;

  NotificationCubit(
    this._getNotificationsUsecase,
    this._markAllNotificationUsecase,
  ) : super(const NotificationStates());

  Future<void> getNotifications() async {
    emit(state.copyWith(getNotificationsRequestStatus: RequestStatus.loading));
    final result = await _getNotificationsUsecase();
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          getNotificationsRequestStatus: RequestStatus.error,
          getNotificationsErrorMessage: failure,
        ),
      ),
      (notifications) {
        final int notReadCount = notifications
            .where((notification) => notification.readAt == null)
            .length;

        emit(
          state.copyWith(
            getNotificationsRequestStatus: RequestStatus.success,
            notifications: notifications,
            notificationNotReadLength: notReadCount,
          ),
        );
      },
    );
  }

  Future<void> markAllNotificationsAsRead() async {
    emit(
      state.copyWith(
        markAllNotificationsAsReadRequestStatus: RequestStatus.loading,
      ),
    );
    final result = await _markAllNotificationUsecase();
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          markAllNotificationsAsReadRequestStatus: RequestStatus.error,
          markAllNotificationsAsReadErrorMessage: failure,
        ),
      ),
      (isMarked) => emit(
        state.copyWith(
          markAllNotificationsAsReadRequestStatus: RequestStatus.success,
        ),
      ),
    );
    await getNotifications();
  }
}
