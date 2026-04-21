import 'package:equatable/equatable.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/doamin/entities/notification_entity.dart';

class NotificationStates extends Equatable {
  // get notifications states
  final RequestStatus? getNotificationsRequestStatus;
  final String? getNotificationsErrorMessage;
  final List<NotificationEntity>? notifications;
  final int? notificationNotReadLength;
  // mark all notifications as read states
  final RequestStatus? markAllNotificationsAsReadRequestStatus;
  final String? markAllNotificationsAsReadErrorMessage;

  const NotificationStates({
    // get notifications states
    this.getNotificationsRequestStatus,
    this.getNotificationsErrorMessage,
    this.notifications,
    this.notificationNotReadLength,
    // mark all notifications as read states
    this.markAllNotificationsAsReadRequestStatus,
    this.markAllNotificationsAsReadErrorMessage,
  });

  NotificationStates copyWith({
    // get notifications states
    RequestStatus? getNotificationsRequestStatus,
    String? getNotificationsErrorMessage,
    List<NotificationEntity>? notifications,
    int? notificationNotReadLength,
    // mark all notifications as read states
    RequestStatus? markAllNotificationsAsReadRequestStatus,
    String? markAllNotificationsAsReadErrorMessage,
  }) {
    return NotificationStates(
      // get notifications states
      getNotificationsRequestStatus:
          getNotificationsRequestStatus ?? this.getNotificationsRequestStatus,
      getNotificationsErrorMessage:
          getNotificationsErrorMessage ?? this.getNotificationsErrorMessage,
      notifications: notifications ?? this.notifications,
      notificationNotReadLength:
          notificationNotReadLength ?? this.notificationNotReadLength,
      // mark all notifications as read states
      markAllNotificationsAsReadRequestStatus:
          markAllNotificationsAsReadRequestStatus ??
          this.markAllNotificationsAsReadRequestStatus,
      markAllNotificationsAsReadErrorMessage:
          markAllNotificationsAsReadErrorMessage ??
          this.markAllNotificationsAsReadErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    // get notifications states
    getNotificationsRequestStatus,
    getNotificationsErrorMessage,
    notifications,
    notificationNotReadLength,
    // mark all notifications as read states
    markAllNotificationsAsReadRequestStatus,
    markAllNotificationsAsReadErrorMessage,
  ];

  @override
  String toString() {
    final activeStates = <String>[];

    void addIfNotNull(String name, dynamic status, List<dynamic> details) {
      if (status != null) {
        activeStates.add('$name: $details');
      }
    }

    addIfNotNull('getNotifications', getNotificationsRequestStatus, [
      getNotificationsRequestStatus,
      getNotificationsErrorMessage,
      notifications,
      notificationNotReadLength,
    ]);

    addIfNotNull(
      'markAllNotificationsAsRead',
      markAllNotificationsAsReadRequestStatus,
      [
        markAllNotificationsAsReadRequestStatus,
        markAllNotificationsAsReadErrorMessage,
      ],
    );

    return activeStates.isEmpty
        ? 'NotificationStates(Idle)'
        : 'NotificationStates(\n    ${activeStates.join(',\n    ')}\n  )';
  }
}
