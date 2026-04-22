import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/widgets/error_retry_widget.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/presentation/cubit/driver_trip_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/presentation/cubit/driver_trip_states.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/entities/trip_entity.dart';

class TripDetailScreen extends StatefulWidget {
  final int tripId;
  const TripDetailScreen({super.key, required this.tripId});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DriverTripCubit>().getDriverTripById(widget.tripId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: BlocBuilder<DriverTripCubit, DriverTripStates>(
        builder: (context, state) {
          if (state.getDriverTripByIdStatus == RequestStatus.loading ||
              state.getDriverTripByIdStatus == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (state.getDriverTripByIdStatus == RequestStatus.error) {
            return ErrorRetryWidget(
              message: state.getDriverTripByIdMessage ?? 'Something went wrong',
              onRetry: () {
                context.read<DriverTripCubit>().getDriverTripById(
                  widget.tripId,
                );
              },
            );
          }

          final trip = state.trip;
          if (trip == null) {
            return const Center(child: Text('Trip completely unavailable.'));
          }

          return Column(
            children: [
              // ── Blue Header ──────────────────────────────────────────
              _buildHeader(context, trip),

              // ── Scrollable Body ──────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Earning Card ─────────────────────────────────
                      _buildEarningCard(trip),

                      const SizedBox(height: 20),

                      // ── Route Details ─────────────────────────────────
                      _buildSectionTitle('Route Details'),
                      const SizedBox(height: 12),
                      _buildRouteCard(trip),

                      const SizedBox(height: 20),

                      // ── Cargo Details ─────────────────────────────────
                      _buildSectionTitle('Cargo Details'),
                      const SizedBox(height: 12),
                      _buildCargoCard(trip),
                      const SizedBox(height: 20),

                      // ── special notes  ──────────────────────────
                      _buildSectionTitle('Special Notes'),
                      const SizedBox(height: 12),
                      _buildSpecialNotesCard(trip),

                      const SizedBox(height: 20),

                      // ── Customer Information ──────────────────────────
                      _buildSectionTitle('Customer Information'),
                      const SizedBox(height: 12),
                      _buildCustomerCard(trip),

                      const SizedBox(height: 16),

                      // ── Call Button ───────────────────────────────────
                      _buildCallButton(trip),

                      const SizedBox(height: 12),

                      // ── Report + Receipt Buttons ──────────────────────
                      _buildBottomActions(trip),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Blue Header ─────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, TripEntity trip) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: EdgeInsets.only(
        top: topPadding + 20,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    trip.tripNumber,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Completed badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: trip.status.toLowerCase() == 'completed'
                  ? const Color(0xFF22C55E)
                  : const Color(0xFFE8A020),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              trip.status.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Earning Card ─────────────────────────────────────────────────────────────
  Widget _buildEarningCard(TripEntity trip) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF22C55E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Trip Earning',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${trip.currency} ${trip.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),

          // Rating box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFE8A020),
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  trip.rating?.toStringAsFixed(1) ?? '0',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Rating',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialNotesCard(TripEntity trip) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        trip.specialNotes ?? 'No special notes',
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          height: 1.6,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ── Section Title ────────────────────────────────────────────────────────────
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1A1A2E),
      ),
    );
  }

  // ── Route Card ───────────────────────────────────────────────────────────────
  String _formatDate(DateTime date) {
    final months = [
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
    return '${date.day} ${months[date.month - 1]}';
  }

  Widget _buildRouteCard(TripEntity trip) {
    final dateStr = trip.date != null ? _formatDate(trip.date!) : 'N/A';

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
        children: [
          // ── Pickup ───────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  size: 18,
                  color: Color(0xFF22C55E),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'PICKUP LOCATION',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF9CA3AF),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      trip.pickup.length > 25
                          ? '${trip.pickup.substring(0, 25)}...'
                          : trip.pickup,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      trip.pickup,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── Drop-offs ─────────────────────────────────────────────
          if (trip.dropOff.isNotEmpty)
            ...trip.dropOff.map((dropOffItem) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Connector
                  Padding(
                    padding: const EdgeInsets.only(left: 17, top: 4, bottom: 4),
                    child: Column(
                      children: List.generate(
                        4,
                        (_) => Container(
                          width: 1.5,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 3),
                          color: const Color(0xFFD1D5DB),
                        ),
                      ),
                    ),
                  ),

                  // ── Drop-off ─────────────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFEE2E2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          size: 18,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'DROP-OFF LOCATION',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF9CA3AF),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              dropOffItem.length > 25
                                  ? '${dropOffItem.substring(0, 25)}...'
                                  : dropOffItem,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              dropOffItem,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }).toList()
          else
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('No drop-off locations provided'),
            ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 14),

          // ── Stats: Distance / Duration / Date ─────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRouteStat(
                icon: Icons.navigation_outlined,
                iconColor: const Color(0xFF3B82F6),
                value: trip.distanceBetween != null
                    ? '${trip.distanceBetween}km'
                    : 'N/A',
                label: 'Distance',
              ),
              _buildRouteStat(
                icon: Icons.access_time_rounded,
                iconColor: const Color(0xFF8B5CF6),
                value: '${trip.estimatedTime}m',
                label: 'Duration',
              ),
              _buildRouteStat(
                icon: Icons.calendar_month_outlined,
                iconColor: const Color(0xFFEF4444),
                value: dateStr,
                label: 'Date',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRouteStat({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
        ),
      ],
    );
  }

  // ── Cargo Card ───────────────────────────────────────────────────────────────
  Widget _buildCargoCard(TripEntity trip) {
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
          // Type
          _buildCargoRow(
            icon: Icons.inventory_2_outlined,
            iconColor: const Color(0xFF3B82F6),
            iconBgColor: const Color(0xFFEFF6FF),
            label: 'Type',
            value: trip.typeOfGoods,
          ),

          const SizedBox(height: 14),

          // Weight (Not provided yet by trip entity natively, fallback to N/A)
          _buildCargoRow(
            icon: Icons.scale_outlined,
            iconColor: const Color(0xFF8B5CF6),
            iconBgColor: const Color(0xFFF5F3FF),
            label: 'Weight',
            value: trip.weight != null ? '${trip.weight}kg' : '0',
          ),
        ],
      ),
    );
  }

  Widget _buildCargoRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
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
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Customer Card ────────────────────────────────────────────────────────────
  Widget _buildCustomerCard(TripEntity trip) {
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
        children: [
          // Name
          _buildCustomerRow(
            icon: Icons.person_outline_rounded,
            iconColor: const Color(0xFF3B82F6),
            iconBgColor: const Color(0xFFEFF6FF),
            label: 'Name',
            value: trip.user.name ?? 'Unknown',
          ),
          const SizedBox(height: 14),
          // Phone (No phone in UserEntity currently, using N/A or remove)
          _buildCustomerRow(
            icon: Icons.phone_outlined,
            iconColor: const Color(0xFF22C55E),
            iconBgColor: const Color(0xFFDCFCE7),
            label: 'Phone',
            value: trip.user.phone ?? 'N/A',
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 39,
          height: 39,
          decoration: BoxDecoration(
            color: iconBgColor,
            //borderRadius: BorderRadius.circular(10),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 22, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Call Button ──────────────────────────────────────────────────────────────
  Widget _buildCallButton(TripEntity trip) {
    return InkWell(
      onTap: () async {
        final phone = trip.user.phone!.replaceAll(' ', '');
        final Uri uri = Uri.parse('tel:$phone');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          debugPrint('Could not launch call for $phone');
        }
      },
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'Call',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom Actions ───────────────────────────────────────────────────────────
  Widget _buildBottomActions(TripEntity trip) {
    return Row(
      children: [
        // Report Issue
        Expanded(
          child: InkWell(
            onTap: () async {
              final Uri uri = Uri.parse(
                "https://wa.me/201021118492?text=${Uri.encodeComponent('I have an issue with this trip')}",
              );
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Report Issue',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // View Receipt
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRouteNames.bookingContractScreen,
                arguments: trip,
              );
            },
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: const Text(
                'View Receipt',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
