import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/enums/app_enums.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_images.dart';
import 'package:wasel_driver/apps/core/widgets/custom_dialog_widget.dart';
import 'package:wasel_driver/apps/core/widgets/error_retry_widget.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/data/model/inbox_model.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/domain/entity/ibox_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/presentation/manager/inbox_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/presentation/manager/inbox_states.dart';
import 'package:wasel_driver/apps/driver_app/features/inbox/presentation/widgets/inbox_shimmer_widget.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/presentation/manager/profile_cubit.dart';

class InboxScreen extends StatefulWidget {
  final bool isFromProfile;

  const InboxScreen({super.key, this.isFromProfile = false});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  int selectedTabIndex = 0;
  final Color primaryBlue = AppColors.primary;
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<InboxCubit>().getOffersInbox(InboxStatus.offers);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 200) return;

    final cubit = context.read<InboxCubit>();
    if (selectedTabIndex == 0) {
      cubit.getOffersInbox(InboxStatus.offers, isLoadMore: true);
    } else if (selectedTabIndex == 1) {
      cubit.getSupportInbox(InboxStatus.support, isLoadMore: true);
    } else {
      cubit.getUpdatesInbox(InboxStatus.updates, isLoadMore: true);
    }
  }

  Future<void> _onRefresh() async {
    final cubit = context.read<InboxCubit>();
    if (selectedTabIndex == 0) {
      await cubit.getOffersInbox(InboxStatus.offers);
    } else if (selectedTabIndex == 1) {
      await cubit.getSupportInbox(InboxStatus.support);
    } else {
      await cubit.getUpdatesInbox(InboxStatus.updates);
    }
  }

  void _fetchInboxForTab(int index) {
    final cubit = context.read<InboxCubit>();
    if (index == 0) cubit.getOffersInbox(InboxStatus.offers);
    if (index == 1) cubit.getSupportInbox(InboxStatus.support);
    if (index == 2) cubit.getUpdatesInbox(InboxStatus.updates);
  }

  void _onTabTapped(int index) {
    if (selectedTabIndex == index) return;
    setState(() => selectedTabIndex = index);
    _fetchInboxForTab(index);
  }

  void _retryCurrentTab() {
    _fetchInboxForTab(selectedTabIndex);
  }

  int _readOffersBadgeCount(InboxStates state) =>
      state.offers?.where((e) => e.isRead != true).length ?? 0;

  int _readSupportsBadgeCount(InboxStates state) =>
      state.supports?.where((e) => e.isRead != true).length ?? 0;

  int _readUpdatesBadgeCount(InboxStates state) =>
      state.updates?.where((e) => e.isRead != true).length ?? 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Inbox",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: BlocBuilder<InboxCubit, InboxStates>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Row(
                  children: [
                    _buildTabButton(
                      0,
                      AppImages.offer,
                      "Offers",
                      _readOffersBadgeCount(state).toString(),
                    ),
                    const SizedBox(width: 8),
                    _buildTabButton(
                      1,
                      AppImages.chatIcon,
                      "Support",
                      _readSupportsBadgeCount(state).toString(),
                    ),
                    const SizedBox(width: 8),
                    _buildTabButton(
                      2,
                      AppImages.notificationIcon,
                      "Updates",
                      _readUpdatesBadgeCount(state).toString(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      body: BlocConsumer<InboxCubit, InboxStates>(
        listener: (context, state) {
          if (state.initiateChatRequestStatus == RequestStatus.success) {
            Navigator.pushNamed(
              context,
              AppRouteNames.chatScreen,
              arguments: {
                'ticket': state.ticketStatusEntity,
                'ticketId': state.ticketId.toString(),
              },
            );
            context.read<InboxCubit>().resetInitiateChatStatus();
          } else if (state.initiateChatRequestStatus == RequestStatus.error) {
            showError(
              context,
              state.initiateChatErrorMessage ?? "something went wrong",
            );
            context.read<InboxCubit>().resetInitiateChatStatus();
          }

          if (state.markAllInboxesRequestStatus == RequestStatus.success) {
            _fetchInboxForTab(selectedTabIndex);
            context.read<InboxCubit>().resetMarkAllInboxesStatus();
          } else if (state.markAllInboxesRequestStatus == RequestStatus.error) {
            showError(
              context,
              state.markAllInboxesErrorMessage ?? "something went wrong",
            );
            context.read<InboxCubit>().resetMarkAllInboxesStatus();
          }

          if (state.markInboxAsReadRequestStatus == RequestStatus.success) {
            if (!_isRefreshing) {
              _isRefreshing = true;
              _fetchInboxForTab(selectedTabIndex);
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  setState(() => _isRefreshing = false);
                }
              });
            }
            context.read<InboxCubit>().resetMarkInboxAsReadStatus();
          } else if (state.markInboxAsReadRequestStatus ==
              RequestStatus.error) {
            showError(
              context,
              state.markInboxAsReadErrorMessage ?? "something went wrong",
            );
            context.read<InboxCubit>().resetMarkInboxAsReadStatus();
          }
        },
        builder: (context, state) {
          if (state.getInboxRequestStatus == RequestStatus.loading) {
            return buildOfferShimmerList();
          }
          if (state.getInboxRequestStatus == RequestStatus.error) {
            return ErrorRetryWidget(
              message: state.getInboxErrorMessage ?? "Error",
              onRetry: _retryCurrentTab,
            );
          }
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: _buildCurrentTabContent(state),
          );
        },
      ),
    );
  }

  Widget _buildMarkAllAsReadRow(InboxStates state) {
    final hasUnread = selectedTabIndex == 0
        ? (state.offers?.any((e) => e.isRead != true) ?? false)
        : selectedTabIndex == 1
        ? (state.supports?.any((e) => e.isRead != true) ?? false)
        : (state.updates?.any((e) => e.isRead != true) ?? false);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton.icon(
            onPressed:
                !hasUnread ||
                    state.markAllInboxesRequestStatus == RequestStatus.loading
                ? null
                : () {
                    final status = selectedTabIndex == 0
                        ? InboxStatus.offers
                        : selectedTabIndex == 1
                        ? InboxStatus.support
                        : InboxStatus.updates;
                    context.read<InboxCubit>().markAllInboxes(status);
                  },
            icon: state.markAllInboxesRequestStatus == RequestStatus.loading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.done_all, size: 20),
            label: const Text(
              "Mark all as read",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            style: TextButton.styleFrom(
              foregroundColor: primaryBlue,
              disabledForegroundColor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTabContent(InboxStates state) {
    final list = selectedTabIndex == 0
        ? (state.offers ?? [])
        : selectedTabIndex == 1
        ? (state.supports ?? [])
        : (state.updates ?? []);
    if (list.isEmpty) return _buildEmptyState();

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: list.length + (state.isLoadingMore ? 1 : 0) + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildMarkAllAsReadRow(state);
        }
        final itemIndex = index - 1;
        if (itemIndex == list.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (selectedTabIndex == 0) {
          return _buildOfferCard(list[itemIndex] as OfferModel);
        }
        if (selectedTabIndex == 1) {
          final support = list as List<SupportEntity>;
          return _buildSupportCard(
            support[itemIndex],
            support[itemIndex].ticket!.id,
          );
        }
        return _buildUpdateCard(list[itemIndex] as UpdateModel);
      },
    );
  }

  Widget _buildTabButton(int index, String icon, String label, String badge) {
    bool isSelected = selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabTapped(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                icon,
                height: 16,
                width: 16,
                color: isSelected ? primaryBlue : Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? primaryBlue : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 4),
              if (badge != "0")
                CircleAvatar(
                  radius: 7,
                  backgroundColor: const Color(0xFFF7BD4C),
                  child: Text(
                    badge,
                    style: const TextStyle(fontSize: 8, color: Colors.black),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfferCard(OfferEntity offer) {
    return GestureDetector(
      onTap: offer.isRead == true
          ? null
          : () {
              if (offer.id != null) {
                context.read<InboxCubit>().markInboxAsRead(offer.id!);
              }
            },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  offer.title ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                if (!offer.isRead!)
                  const Icon(Icons.circle, size: 10, color: Color(0xFF214DA1)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              offer.description ?? '',
              style: const TextStyle(
                color: AppColors.subTitleColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.grey, thickness: 0.5),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 15,
                      color: AppColors.profileSubTitle,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Valid until ${offer.createdAt?.year}",
                      style: const TextStyle(
                        color: AppColors.profileSubTitle,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (offer.voucher != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: offer.voucher?.discountValue == '100'
                          ? AppColors.greenLight
                          : AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      offer.voucher?.discountValue == '100'
                          ? '% FREE'
                          : offer.voucher?.discountType == 'fixed'
                          ? 'EGP ${offer.voucher!.discountValue}'
                          : "% ${offer.voucher!.discountValue}",
                      style: TextStyle(
                        color: offer.voucher?.discountValue == '100'
                            ? AppColors.green
                            : offer.voucher?.discountType == 'fixed'
                            ? AppColors.primary
                            : primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  Widget _buildSupportCard(SupportEntity support, int ticketId) {
    bool isNewResponse = !support.isRead!;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: support.isRead == true
          ? null
          : () {
              if (support.id != null) {
                context.read<InboxCubit>().markInboxAsRead(support.id!);
              }
            },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isNewResponse
              ? Border.all(color: const Color(0xFFF7BD4C), width: 1)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (support.status == "solved")
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 12, color: Colors.green),
                    SizedBox(width: 4),
                    Text(
                      "Resolved",
                      style: TextStyle(color: Colors.green, fontSize: 10),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  radius: 22,
                  child: Image.asset(
                    AppImages.chatIcon,
                    height: 30,
                    width: 30,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            support.title ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          if (isNewResponse)
                            const Icon(
                              Icons.circle,
                              size: 8,
                              color: Color(0xFFF7BD4C),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        support.description ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.subTitleColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 15,
                            color: AppColors.subTitleColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${support.createdAt?.day} Dec, ${support.createdAt?.year}",
                            style: const TextStyle(
                              color: AppColors.profileSubTitle,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (support.status == 'reply') ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<InboxCubit>().initiateChat(
                          support.ticket!.id,
                          context.read<ProfileCubit>().state.profileModel!.id!,
                          actionId: 'view_${support.id}',
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primaryBlue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: BlocSelector<InboxCubit, InboxStates, bool>(
                        selector: (state) =>
                            state.initiateChatRequestStatus ==
                                RequestStatus.loading &&
                            state.initiateChatActionId == 'view_${support.id}',
                        builder: (context, isLoading) {
                          if (isLoading) {
                            return SizedBox(
                              width: 16,
                              height: 16,
                              child: const CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            );
                          }
                          return const Text(
                            "View Ticket",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<InboxCubit>().initiateChat(
                          support.ticket!.id,
                          context.read<ProfileCubit>().state.profileModel!.id!,
                          actionId: 'reply_${support.id}',
                        );
                      },
                      icon: Image.asset(
                        AppImages.sendIcon,
                        height: 16,
                        width: 16,
                        color: Colors.white,
                      ),
                      label: BlocSelector<InboxCubit, InboxStates, bool>(
                        selector: (state) =>
                            state.initiateChatRequestStatus ==
                                RequestStatus.loading &&
                            state.initiateChatActionId == 'reply_${support.id}',
                        builder: (context, isLoading) {
                          if (isLoading) {
                            return SizedBox(
                              width: 16,
                              height: 16,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            );
                          }
                          return const Text(
                            "Reply",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          );
                        },
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateCard(UpdateModel update) {
    Color themeColor = update.tag == 'Security'
        ? Colors.red
        : const Color(0xFF63D098);
    final isReaded = !update.isRead!;
    return GestureDetector(
      onTap: update.isRead == true
          ? null
          : () {
              if (update.id != null) {
                context.read<InboxCubit>().markInboxAsRead(update.id!);
              }
            },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24), // Softer corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left accent border
              Container(
                width: 6,
                decoration: BoxDecoration(
                  color: themeColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0), // More breathing room
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon with rounded background
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: themeColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              update.tag == 'Security'
                                  ? Icons.security
                                  : Icons.auto_awesome_outlined,
                              size: 24,
                              color: themeColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Title and Blue Dot
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        update.title ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18,
                                          color: Color(0xFF2D3142),
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                    if (isReaded)
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: Color(0xFF4A69BD),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Description text
                                Text(
                                  update.description ?? '',
                                  style: const TextStyle(
                                    color: Color(0xFF9094A0),
                                    fontSize: 15,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_rounded,
                                      size: 18,
                                      color: Color(0xFFB0B4C0),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _formatDate(
                                        update.createdAt ?? DateTime.now(),
                                      ),
                                      style: const TextStyle(
                                        color: Color(0xFFB0B4C0),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Footer: Time and Tag
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: themeColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              update.tag ?? '',
                              style: TextStyle(
                                color: themeColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 140),
        Center(
          child: Container(
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
                    Icons.mark_email_unread_outlined,
                    color: AppColors.primary,
                    size: 30,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  "No messages yet",
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
        ),
      ],
    );
  }
}
