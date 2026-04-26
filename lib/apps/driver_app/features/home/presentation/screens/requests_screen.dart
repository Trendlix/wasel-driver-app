import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/widgets/error_retry_widget.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/entities/request_categories_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/home/presentation/cubit/home_states.dart';
import 'package:wasel_driver/apps/features/app_permissions/service/app_permission_service.dart';

class NewRequestsScreen extends StatefulWidget {
  final RequestCategoriesEntity categories;
  final double latitude;
  final double longitude;

  const NewRequestsScreen({
    super.key,
    required this.categories,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<NewRequestsScreen> createState() => _NewRequestsScreenState();
}

class _NewRequestsScreenState extends State<NewRequestsScreen> {
  int _selectedTabIndex = 0; // 0: All, 1: Urgent, 2: High Pay, 3: Nearby

  List<RequestEntity> _getActiveList(RequestCategoriesEntity categories) {
    switch (_selectedTabIndex) {
      case 1:
        return categories.urgent;
      case 2:
        return categories.highPay;
      case 3:
        return categories.nearby;
      default:
        return categories.all;
    }
  }

  @override
  Widget build(BuildContext context) {
    // We wrap the entire content in BlocBuilder so Header and Tabs refresh too
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        // Default to the data passed in the constructor
        RequestCategoriesEntity currentData = widget.categories;
        bool isLoading = false;

        // If the Cubit successfully fetched new data, use it everywhere
        if (state.driverRequestsRequestStatus == RequestStatus.loading) {
          isLoading = true;
        } else if (state.driverRequestsRequestStatus == RequestStatus.success) {
          currentData = state.driverRequestsModel!;
        }

        final activeList = _getActiveList(currentData);

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: Column(
            children: [
              // This will now refresh its "count" badge dynamically
              _buildHeader(context, activeList.length),

              // This will now refresh its "label" counts dynamically
              _buildFilterTabs(currentData),

              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : activeList.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                        itemCount: activeList.length,
                        itemBuilder: (context, index) {
                          return _buildTripCardFromEntity(activeList[index]);
                        },
                      ),
              ),
              _buildOnlineBar(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: ErrorRetryWidget(
        message: "No requests available in this category",
        onRetry: () {
          context.read<HomeCubit>().getDriverRequests(
            widget.latitude,
            widget.longitude,
          );
        },
      ),
    );
  }

  // ── Logic Mappers ──────────────────────────────────────────────────────────

  Widget _buildTripCardFromEntity(RequestEntity request) {
    final double total = request.price ?? 0.0;
    final double earnings = total * 0.85;
    final double fee = total - earnings;
    final String currency = request.currency ?? 'EGP';

    final String name = request.user?.name ?? "User";
    final String initials = name
        .split(' ')
        .take(2)
        .map((e) => e[0])
        .join()
        .toUpperCase();

    return _buildTripCard(
      onClick: () => Navigator.pushNamed(
        context,
        AppRouteNames.requestDetailsScreen,
        arguments: {
          'requestId': request.id,
          'lat': widget.latitude.toString(),
          'long': widget.longitude.toString(),
        },
      ),
      avatarWidget:
          (request.user?.avatar != null && request.user!.avatar!.isNotEmpty)
          ? CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(request.user!.avatar!),
              backgroundColor: const Color(0xFFE5E7EB),
            )
          : _buildInitialsAvatar(initials, AppColors.primary),
      driverName: name,
      rating: (request.user?.rating ?? 0).toString(),
      totalPrice: '$currency ${total.toStringAsFixed(0)}',
      yourEarnings: '$currency ${earnings.toStringAsFixed(0)}',
      pickup: request.pickup ?? 'Unknown',
      dropoff: (request.dropOff != null && request.dropOff!.isNotEmpty)
          ? request.dropOff!.first
          : 'Unknown',
      distance: '${request.distanceBetween ?? 0} km',
      time: '${request.estimatedTime ?? 0} mins',
      category: request.typeOfGoods ?? 'General',
      categoryIcon: _getIconForCategory(request.typeOfGoods),
      isUrgent: request.label?.toLowerCase() == 'urgent',
      earningsPercent:
          '${request.amountGoesToDriverPercentage ?? 0}% goes to you',
      platformFee:
          '$currency ${(request.platformFees ?? 0).toStringAsFixed(0)}',
      dateOfRequest: request.dateOfRequest ?? '',
    );
  }

  IconData _getIconForCategory(String? type) {
    switch (type?.toLowerCase()) {
      case 'furniture':
        return Icons.chair_outlined;
      case 'building materials':
        return Icons.construction_outlined;
      default:
        return Icons.local_shipping_outlined;
    }
  }

  // ── UI Components ──────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, int count) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: EdgeInsets.only(
        top: topPadding + 12,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Trips',
                        style: TextStyle(fontSize: 11, color: Colors.white),
                      ),
                      Text(
                        'New Requests',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8A020),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Select a trip to view details and accept',
            style: TextStyle(fontSize: 11, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(RequestCategoriesEntity categories) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTab('All (${categories.all.length})', 0),
            const SizedBox(width: 8),
            _buildTab('Urgent (${categories.urgent.length})', 1),
            const SizedBox(width: 8),
            _buildTab('High Pay', 2),
            const SizedBox(width: 8),
            _buildTab('Nearby', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final bool isActive = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _buildTripCard({
    required Widget avatarWidget,
    required String driverName,
    required String rating,
    required String totalPrice,
    required String yourEarnings,
    required String pickup,
    required String dropoff,
    required String distance,
    required String time,
    required String category,
    required IconData categoryIcon,
    required bool isUrgent,
    required String earningsPercent,
    required String platformFee,
    required String dateOfRequest,
    void Function()? onClick,
  }) {
    return InkWell(
      onTap: onClick,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      avatarWidget,
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              driverName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 13,
                                  color: Color(0xFFE8A020),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  rating,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            totalPrice,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          const Text(
                            'Total Price',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            yourEarnings,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF22C55E),
                            ),
                          ),
                          const Text(
                            'Your Earnings',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  //const SizedBox(height: 12),
                  Row(
                    children: [
                      SizedBox(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 12,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formatDate(dateOfRequest),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildLocationRow(
                    icon: Icons.circle,
                    iconColor: const Color(0xFF22C55E),
                    label: 'PICKUP',
                    value: pickup,
                  ),
                  const SizedBox(height: 8),
                  _buildLocationRow(
                    icon: Icons.location_on,
                    iconColor: const Color(0xFFEF4444),
                    label: 'DROP-OFF',
                    value: dropoff,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatChip(
                          Icons.navigation_outlined,
                          distance,
                          'Distance',
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.1),
                        ),
                      ),
                      Expanded(
                        child: _buildStatChip(
                          Icons.access_time_outlined,
                          time,
                          'Time',
                          AppColors.secondary,
                          AppColors.secondary.withOpacity(0.1),
                        ),
                      ),
                      Expanded(
                        child: _buildStatChip(
                          categoryIcon,
                          category,
                          '',
                          AppColors.greenColor,
                          AppColors.greenColor.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                  if (isUrgent) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFEF4444).withOpacity(0.3),
                        ),
                      ),
                      child: const Text(
                        '🔴  URGENT REQUEST',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFEF4444),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const BoxDecoration(
                color: AppColors.noteCardColor,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.trending_up_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: earningsPercent,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const TextSpan(
                          text: '  •  Platform fee: ',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: platformFee,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Icon(icon, size: 12, color: iconColor),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9CA3AF),
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatChip(
    IconData icon,
    String value,
    String label,
    Color iconColor,
    Color containerColor,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 14, color: iconColor),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (label.isNotEmpty)
                Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: Colors.black),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInitialsAvatar(String initials, Color color) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildOnlineBar() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF22C55E),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            "You're online and receiving requests  ",
            style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
          InkWell(
            onTap: () async {
              final location = await PermissionService.getSavedLocation();
              if (location != null) {
                if (!mounted) return;
                context.read<HomeCubit>().getDriverRequests(
                  location.lat,
                  location.lng,
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Refresh',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '—';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final requestDate = DateTime(date.year, date.month, date.day);

      if (requestDate == today) {
        return 'Today';
      } else {
        return DateFormat('dd MMM yyyy').format(date);
      }
    } catch (e) {
      return dateStr;
    }
  }
}
