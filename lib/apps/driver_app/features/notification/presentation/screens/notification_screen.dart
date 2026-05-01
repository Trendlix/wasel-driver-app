import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/widgets/custom_dialog_widget.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/doamin/entities/notification_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/presentation/manager/notification_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/presentation/manager/notification_states.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<NotificationCubit>().getNotifications();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final cubit = context.read<NotificationCubit>();
    final state = cubit.state;

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        state.getMoreNotificationsRequestStatus != RequestStatus.loading &&
        state.hasMore) {
      cubit.getNotifications(page: state.currentPage + 1);
    }
  }

  void _fetchMore() {
    final cubit = context.read<NotificationCubit>();
    final state = cubit.state;
    cubit.getNotifications(page: state.currentPage + 1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationCubit, NotificationStates>(
      listenWhen: (previous, current) =>
          previous.markAllNotificationsAsReadRequestStatus !=
          current.markAllNotificationsAsReadRequestStatus,
      listener: (context, state) {
        if (state.markAllNotificationsAsReadRequestStatus ==
            RequestStatus.error) {
          showError(
            context,
            state.markAllNotificationsAsReadErrorMessage ??
                "something went wrong",
          );
        } else if (state.markAllNotificationsAsReadRequestStatus ==
            RequestStatus.success) {
          showSuccess(context, "Notifications marked as read");
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          toolbarHeight: 80,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Notification',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
          ),
          centerTitle: false,
          elevation: 0,
        ),
        body: Column(
          children: [
            _buildHeaderActions(context),
            Expanded(
              child: BlocBuilder<NotificationCubit, NotificationStates>(
                builder: (context, state) {
                  final notifications = state.notifications;

                  // --- Shimmer Loading State ---
                  if (state.getNotificationsRequestStatus ==
                          RequestStatus.loading &&
                      (notifications == null || notifications.isEmpty)) {
                    return _buildShimmerLoading();
                  }

                  // --- Error State ---
                  if (state.getNotificationsRequestStatus ==
                          RequestStatus.error &&
                      (notifications == null || notifications.isEmpty)) {
                    return RefreshIndicator(
                      onRefresh: () =>
                          context.read<NotificationCubit>().getNotifications(),
                      color: AppColors.primary,
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: Text(
                                state.getNotificationsErrorMessage ?? "Error",
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // --- Empty State ---
                  if (notifications == null || notifications.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () =>
                          context.read<NotificationCubit>().getNotifications(),
                      color: AppColors.primary,
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: _buildEmptyState(),
                          ),
                        ],
                      ),
                    );
                  }

                  final newNotifications = notifications
                      .where((n) => n.readAt == null)
                      .toList();
                  final earlierNotifications = notifications
                      .where((n) => n.readAt != null)
                      .toList();

                  final List<dynamic> items = [];
                  if (newNotifications.isNotEmpty) {
                    items.add("NEW");
                    items.addAll(newNotifications);
                  }
                  if (earlierNotifications.isNotEmpty) {
                    items.add("EARLIER");
                    items.addAll(earlierNotifications);
                  }

                  return RefreshIndicator(
                    onRefresh: () =>
                        context.read<NotificationCubit>().getNotifications(),
                    color: AppColors.primary,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: items.length + (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == items.length) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child:
                                  state.getMoreNotificationsRequestStatus ==
                                      RequestStatus.loading
                                  ? const Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          "Loading more notifications...",
                                          style: TextStyle(
                                            color: AppColors.subTitleColor,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    )
                                  : state.getMoreNotificationsRequestStatus ==
                                        RequestStatus.error
                                  ? InkWell(
                                      onTap: _fetchMore,
                                      child: const Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.refresh,
                                            color: Colors.orange,
                                            size: 24,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "Failed to load more. Tap to retry",
                                            style: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          );
                        }

                        final item = items[index];
                        if (item == "NEW") {
                          return _buildSectionHeader("New");
                        } else if (item == "EARLIER") {
                          return _buildSectionHeader("Earlier");
                        } else {
                          final notification = item as NotificationEntity;
                          final isOffer =
                              notification.type.toLowerCase() == 'offer';
                          return _buildNotificationTile(
                            icon: isOffer ? Icons.local_offer : Icons.update,
                            iconColor: isOffer
                                ? const Color(0xFFF15A24)
                                : const Color(0xFF2E5AAC),
                            title: notification.title,
                            subtitle: notification.description,
                            time: isOffer
                                ? "${notification.createdAt.day}/${notification.createdAt.month}"
                                : "",
                            isRead: notification.readAt != null,
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(radius: 22, backgroundColor: Colors.white),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 120, height: 12, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 10,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(width: 180, height: 10, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: BlocBuilder<NotificationCubit, NotificationStates>(
              builder: (context, state) {
                final isLoading =
                    state.markAllNotificationsAsReadRequestStatus ==
                    RequestStatus.loading;
                final hasUnread =
                    state.notifications?.any((n) => n.readAt == null) ?? false;

                return TextButton(
                  onPressed: (isLoading || !hasUnread)
                      ? null
                      : () => context
                            .read<NotificationCubit>()
                            .markAllNotificationsAsRead(),
                  child: isLoading
                      ? const SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        )
                      : Text(
                          "Mark all as read",
                          style: TextStyle(
                            color: hasUnread ? AppColors.primary : Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                );
              },
            ),
          ),
          Flexible(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none,
                size: 18,
                color: Colors.black87,
              ),
              label: const Text(
                "Preferences",
                style: TextStyle(color: Colors.black87, fontSize: 13),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF7F7F7),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      color: const Color(0xFFF9F9F9),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildNotificationTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
    required bool isRead,
  }) {
    return Container(
      color: !isRead ? const Color(0xFFF1F6FF) : Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: iconColor,
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (!isRead)
                      const CircleAvatar(
                        radius: 4,
                        backgroundColor: Color(0xFF2E5AAC),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
                if (time.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    time,
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primaryLight,
                child: Icon(
                  Icons.notifications_none_outlined,
                  color: AppColors.primary,
                  size: 30,
                ),
              ),
              SizedBox(height: 14),
              Text(
                "No notifications yet",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "You're all caught up. Pull down to refresh and check for new updates.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: AppColors.subTitleColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
