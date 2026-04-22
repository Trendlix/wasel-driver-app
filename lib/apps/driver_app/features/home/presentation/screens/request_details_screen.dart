import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/widgets/custom_snackbar_widget.dart';
import 'package:wasel_driver/apps/core/widgets/error_retry_widget.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/entities/single_request_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/home/presentation/cubit/home_states.dart';
import 'package:wasel_driver/apps/driver_app/features/home/presentation/widgets/quota_bottomsheet_widget.dart';

class RequestDetailsScreen extends StatefulWidget {
  final int requestId;
  final String lat;
  final String long;
  const RequestDetailsScreen({
    super.key,
    required this.requestId,
    required this.lat,
    required this.long,
  });

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getSingleRequest(
      widget.requestId,
      double.parse(widget.lat),
      double.parse(widget.long),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state.rejectRequestStatus == RequestStatus.error) {
          showSnackError(
            context,
            state.rejectRequestErrorMessage ?? 'soemthing went wrong',
          );
          context.read<HomeCubit>().resetRejectRequestStatus();
        } else if (state.rejectRequestStatus == RequestStatus.success) {
          showSuccess(context, 'request rejected successfully');
          context.read<HomeCubit>().resetRejectRequestStatus();
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouteNames.mainShellScreen,
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        // ── Loading ──────────────────────────────────────────────────────────
        if (state.getSingleRequestStatus == RequestStatus.loading ||
            state.getSingleRequestStatus == RequestStatus.initial) {
          return const Scaffold(
            backgroundColor: Color(0xFFF5F7FA),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ── Error ────────────────────────────────────────────────────────────
        if (state.getSingleRequestStatus == RequestStatus.error) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F7FA),
            body: Center(
              child: ErrorRetryWidget(
                message:
                    state.singleRequestErrorMessage ?? 'Something went wrong',
                onRetry: () {
                  context.read<HomeCubit>().getSingleRequest(
                    widget.requestId,
                    double.parse(widget.lat),
                    double.parse(widget.long),
                  );
                },
              ),
            ),
          );
        }

        // ── Success ──────────────────────────────────────────────────────────
        final request = state.singleRequestModel;
        if (state.getSingleRequestStatus == RequestStatus.success &&
            request != null) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F7FA),
            appBar: _buildAppBar(context, request),
            body: Column(
              children: [
                // ── Scrollable Content ───────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Trip Details Card ────────────────────────────
                        _buildTripDetailsCard(request),

                        const SizedBox(height: 16),

                        // ── Package Information Card ─────────────────────
                        _buildPackageInfoCard(request),

                        const SizedBox(height: 16),

                        // ── Customer Card ────────────────────────────────
                        _buildCustomerCard(request),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                // ── Bottom Action Buttons ────────────────────────────────
                _buildBottomActions(context, request),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  // ── AppBar ───────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    SingleRequestEntity request,
  ) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      toolbarHeight: 90,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.label != null
                          ? request.label!
                          : 'New Trip Request',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'TRIP-${request.id}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFE8A020),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Recently',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Trip Details Card ─────────────────────────────────────────────────────────
  Widget _buildTripDetailsCard(SingleRequestEntity request) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trip Details',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),

          const SizedBox(height: 16),

          // ── Pickup ──────────────────────────────────────────────
          _buildLocationBlock(
            icon: Icons.location_on_rounded,
            iconColor: const Color(0xFF22C55E),
            label: 'PICKUP',
            address: request.pickup != null
                ? request.pickup!
                : 'Unknown Pickup',
            subAddress: 'Main Collection Point',
          ),

          _buildDottedLine(),

          // ── Drop-off ─────────────────────────────────────────────
          _buildLocationBlock(
            icon: Icons.location_on_rounded,
            iconColor: const Color(0xFFEF4444),
            label: 'DROP-OFF',
            address: request.dropOff != null && request.dropOff!.isNotEmpty
                ? request.dropOff!.first
                : 'No Drop-off specified',
            subAddress: request.dropOff != null && request.dropOff!.length > 1
                ? '+${request.dropOff!.length - 1} additional stops'
                : 'Final Destination',
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 14),

          // ── Distance / Duration / Earning ─────────────────────────
          Row(
            children: [
              Expanded(
                child: _buildStatBlock(
                  'Distance',
                  '-',
                  const Color(0xFF1A1A2E),
                ),
              ),
              Expanded(
                child: _buildStatBlock(
                  'Time',
                  '${request.estimatedTimeInMinutes ?? 0} min',
                  const Color(0xFF1A1A2E),
                ),
              ),
              Expanded(
                child: _buildStatBlock(
                  'Earning',
                  '${request.currency ?? 'EGP'} ${request.price ?? 0}',
                  const Color(0xFF22C55E),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Urgent Badge ─────────────────────────────────────────
          if (request.label != null &&
              request.label!.toLowerCase().contains('urgent'))
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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

          const SizedBox(height: 10),
          // fixed ui to 85% goes to you platfomr fee : EGP 138
          _revenueSplitBadge(),
        ],
      ),
    );
  }

  Widget _buildLocationBlock({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String address,
    required String subAddress,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 10),
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
                address,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subAddress,
                style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDottedLine() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
      child: Column(
        children: List.generate(
          4,
          (_) => Container(
            width: 2,
            height: 4,
            margin: const EdgeInsets.only(bottom: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFD1D5DB),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatBlock(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  // ── Package Information Card ──────────────────────────────────────────────────
  Widget _buildPackageInfoCard(SingleRequestEntity request) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Package Information',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),

          const SizedBox(height: 14),

          _buildPackageRow(
            icon: Icons.inventory_2_outlined,
            iconColor: const Color(0xFF3B82F6),
            iconBgColor: const Color(0xFFEFF6FF),
            label: 'Package Type',
            value: request.typeOfGoods != null
                ? request.typeOfGoods!
                : 'General Goods',
          ),

          const SizedBox(height: 10),

          _buildPackageRow(
            icon: Icons.scale_outlined,
            iconColor: const Color(0xFFE8A020),
            iconBgColor: const Color(0xFFFFFBEB),
            label: 'Estimated Weight',
            value: '${request.weight} kg',
          ),
          const SizedBox(height: 10),
          // customer notes
          Visibility(
            visible:
                request.customerNote != null &&
                request.customerNote!.isNotEmpty,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.noteCardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Customer Notes',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    request.customerNote ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Customer Card ─────────────────────────────────────────────────────────────
  Widget _buildCustomerCard(SingleRequestEntity request) {
    final user = request.user;
    final initials = user != null
        ? user.name!
              .trim()
              .split(' ')
              .where((part) => part.isNotEmpty)
              .map((part) => part[0])
              .take(2)
              .join()
              .toUpperCase()
        : 'U';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar with initials
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: Color(0xFF8B5CF6),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user != null ? user.name! : 'Guest User',
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
                  const SizedBox(width: 4),
                  Text(
                    '${user!.rating} Rating',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _revenueSplitBadge({
    double percentage = 85,
    double platformFee = 138,
    String currencyCode = 'EGP',
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.noteCardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.trending_up_rounded,
            color: Color(0xFF1D9E75),
            size: 16,
          ),
          const SizedBox(width: 3),
          Text(
            '${percentage.toStringAsFixed(0)}% goes to you',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A2F5A),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '·',
              style: TextStyle(fontSize: 13, color: Color(0xFF9AA3B2)),
            ),
          ),
          Expanded(
            child: Text(
              'Platform fee: $currencyCode ${platformFee.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 13, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom Action Buttons ─────────────────────────────────────────────────────
  Widget _buildBottomActions(
    BuildContext context,
    SingleRequestEntity request,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) => SendQuoteBottomSheet(
                    price: request.price,
                    suggestedPrice: request.waselSuggestedPrice,
                    requestId: widget.requestId,
                    locationLat: double.parse(widget.lat),
                    locationLong: double.parse(widget.long),
                  ),
                );
              },
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Send Quote',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {
                context.read<HomeCubit>().rejectRequest(
                  widget.requestId.toString(),
                  double.parse(widget.lat.toString()),
                  double.parse(widget.long.toString()),
                );
              },
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: BlocBuilder<HomeCubit, HomeStates>(
                  builder: (context, state) {
                    if (state.rejectRequestStatus == RequestStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }
                    return const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Reject',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
