import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/doamin/entities/notification_entity.dart';
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

  Future<void> getNotifications({int page = 1, int limit = 10}) async {
    if (page == 1) {
      emit(
        state.copyWith(
          getNotificationsRequestStatus: RequestStatus.loading,
          getMoreNotificationsRequestStatus: RequestStatus.initial,
          currentPage: 1,
          hasMore: true,
        ),
      );
    } else {
      emit(
        state.copyWith(
          getMoreNotificationsRequestStatus: RequestStatus.loading,
        ),
      );
    }

    final result = await _getNotificationsUsecase(page: page, limit: limit);
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          getNotificationsRequestStatus: page == 1
              ? RequestStatus.error
              : state.getNotificationsRequestStatus,
          getMoreNotificationsRequestStatus: page > 1
              ? RequestStatus.error
              : state.getMoreNotificationsRequestStatus,
          getNotificationsErrorMessage: failure,
        ),
      ),
      (notifications) {
        final List<NotificationEntity> updatedNotifications = page == 1
            ? notifications
            : [...(state.notifications ?? []), ...notifications];

        final int notReadCount = updatedNotifications
            .where((notification) => notification.readAt == null)
            .length;

        emit(
          state.copyWith(
            getNotificationsRequestStatus: RequestStatus.success,
            getMoreNotificationsRequestStatus: RequestStatus.success,
            notifications: updatedNotifications,
            notificationNotReadLength: notReadCount,
            currentPage: page,
            hasMore: notifications.length == limit,
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
