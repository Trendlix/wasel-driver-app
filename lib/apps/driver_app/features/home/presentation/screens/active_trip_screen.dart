import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/entities/trip_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/presentation/cubit/driver_trip_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/presentation/cubit/driver_trip_states.dart';

class ActiveTripScreen extends StatelessWidget {
  final TripEntity trip;
  const ActiveTripScreen({super.key, required this.trip});

  bool get isPickedUp => trip.subStatus == 'picked_up';
  @override
  Widget build(BuildContext context) {
    return BlocListener<DriverTripCubit, DriverTripStates>(
      listenWhen: (previous, current) =>
          previous.cancelDriverTripStatus != current.cancelDriverTripStatus,
      listener: (context, state) {
        if (state.cancelDriverTripStatus == RequestStatus.success) {
          Navigator.pop(context);
        } else if (state.cancelDriverTripStatus == RequestStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.cancelDriverTripMessage ?? 'An error occurred',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Column(
          children: [
            // ── Blue Header ──────────────────────────────────────────
            _buildHeader(context),

            // ── Scrollable Body ──────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Navigate to Pickup Button ────────────────────
                    _buildNavigateButton(),

                    const SizedBox(height: 12),

                    // ── Arrived at Pickup Button ─────────────────────
                    _buildArrivedButton(context),

                    const SizedBox(height: 16),

                    // ── Cancel Request Button ─────────────────────
                    isPickedUp
                        ? const SizedBox.shrink()
                        : _buildCancelRequestButton(context),

                    const SizedBox(height: 16),

                    // ── Pickup Location Card ─────────────────────────
                    _buildPickupCard(),

                    const SizedBox(height: 12),

                    // ── Sender Card ──────────────────────────────────
                    _buildSenderCard(),

                    const SizedBox(height: 12),

                    // ── Call Button ──────────────────────────────────
                    _buildCallButton(),

                    const SizedBox(height: 16),

                    // ── Goods Information ────────────────────────────
                    _buildGoodsInfo(),

                    const SizedBox(height: 12),

                    // ── Location Sharing Note ────────────────────────
                    _buildLocationNote(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Blue Header ─────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: EdgeInsets.only(
        top: topPadding + 16,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Active Trip',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            trip.tripNumber,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.65),
            ),
          ),
          const SizedBox(height: 12),

          // Status pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
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
                Text(
                  isPickedUp ? 'Picked up' : 'On the way to pickup',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Navigate to Pickup Button ────────────────────────────────────────────────

  Widget _buildNavigateButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () async {
        final Map<String, dynamic> params = {
          'api': '1',
          'origin': trip.pickup,
          'travelmode': 'driving',
        };
        if (trip.dropOff.isNotEmpty) {
          params['destination'] = trip.dropOff.last;
          if (trip.dropOff.length > 1) {
            params['waypoints'] = trip.dropOff
                .sublist(0, trip.dropOff.length - 1)
                .join('|');
          }
        } else {
          params['destination'] = trip.pickup;
        }

        final uri = Uri.https('www.google.com', '/maps/dir/', params);
        try {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } catch (e) {
          debugPrint('Could not launch maps: $e');
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.navigation_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPickedUp
                      ? 'Navigate to Deliver Location'
                      : 'Navigate to Pickup',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Open in Google Maps',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Arrived at Pickup Button ─────────────────────────────────────────────────

  Widget _buildArrivedButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacementNamed(
          context,
          isPickedUp
              ? AppRouteNames.confirmDeliveryScreen
              : AppRouteNames.confirmPickupScreen,
          arguments: trip,
        );
      },
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          isPickedUp ? 'Confirm Deliver' : 'Arrived at Pickup',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ── cancel request Button ─────────────────────────────────────────────────

  Widget _buildCancelRequestButton(BuildContext context) {
    return BlocBuilder<DriverTripCubit, DriverTripStates>(
      builder: (context, state) {
        final isLoading = state.cancelDriverTripStatus == RequestStatus.loading;

        return InkWell(
          onTap: () {
            if (!isLoading) {
              context.read<DriverTripCubit>().cancelDriverTrip(trip.id);
            }
          },
          child: Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.red),
            ),
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.red,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    'Cancel Request',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.red,
                    ),
                  ),
          ),
        );
      },
    );
  }

  // ── Pickup Location Card ─────────────────────────────────────────────────────

  Widget _buildPickupCard() {
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
          // Pickup location row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  size: 20,
                  color: Color(0xFFE8A020),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pickup Location',
                      style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      trip.pickup,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 14),

          // Estimated time + started
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estimated Time',
                      style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${trip.estimatedTime} mins',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Started',
                      style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trip.date != null
                          ? '${((trip.date!.hour % 12) == 0 ? 12 : (trip.date!.hour % 12))}:${trip.date!.minute.toString().padLeft(2, '0')} ${trip.date!.hour >= 12 ? 'PM' : 'AM'}'
                          : 'N/A',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Sender Card ──────────────────────────────────────────────────────────────

  Widget _buildSenderCard() {
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
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              size: 22,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sender',
                style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
              ),
              const SizedBox(height: 3),
              Text(
                trip.user.name ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                trip.user.phone ?? 'No Phone',
                style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Call Button ──────────────────────────────────────────────────────────────

  Widget _buildCallButton() {
    final hasPhone =
        trip.user.phone != null && trip.user.phone!.trim().isNotEmpty;

    return InkWell(
      onTap: hasPhone
          ? () async {
              final phone = trip.user.phone!.replaceAll(' ', '');
              final Uri uri = Uri.parse('tel:$phone');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              } else {
                debugPrint('Could not launch call for $phone');
              }
            }
          : null,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: hasPhone ? AppColors.primary : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.phone_rounded,
              color: hasPhone ? Colors.white : const Color(0xFF9CA3AF),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Call',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: hasPhone ? Colors.white : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Goods Information ────────────────────────────────────────────────────────

  Widget _buildGoodsInfo() {
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
            'Goods Information',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 14),
          _buildGoodsRow('Type', trip.typeOfGoods, null),
          const SizedBox(height: 10),
          _buildGoodsRow(
            'Weight',
            trip.weight != null ? '${trip.weight} tons' : 'N/A',
            null,
          ),
          const SizedBox(height: 10),
          _buildGoodsRow(
            'Payment',
            '${trip.price} ${trip.currency}',
            const Color(0xFF1A3A6B),
          ),
        ],
      ),
    );
  }

  Widget _buildGoodsRow(String label, String value, Color? valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valueColor ?? const Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }

  // ── Location Sharing Note ────────────────────────────────────────────────────

  Widget _buildLocationNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: AppColors.primary.withOpacity(0.7),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Your location is being shared with the customer in real-time for tracking.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.primary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
