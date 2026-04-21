import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/entities/trip_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/presentation/cubit/driver_trip_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/presentation/cubit/driver_trip_states.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  int _selectedTab = 0;

  List<TripEntity> _getFilteredTrips(List<TripEntity> trips) {
    if (_selectedTab == 0) return trips;
    if (_selectedTab == 1) {
      return trips.where((t) => t.status.toUpperCase() == 'COMPLETED').toList();
    }
    return trips.where((t) => t.status.toUpperCase() == 'CANCELLED').toList();
  }

  @override
  void initState() {
    super.initState();
    context.read<DriverTripCubit>().getDriverTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: BlocBuilder<DriverTripCubit, DriverTripStates>(
              builder: (context, state) {
                if (state.getDriverTripsStatus == RequestStatus.loading ||
                    state.getDriverTripsStatus == null) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.getDriverTripsStatus == RequestStatus.error) {
                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () =>
                        context.read<DriverTripCubit>().getDriverTrips(),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Center(
                            child: Text(
                              state.getDriverTripsMessage ??
                                  'Error loading trips',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state.getDriverTripsStatus ==
                    RequestStatus.success) {
                  final trips = state.trips ?? [];
                  final filteredTrips = _getFilteredTrips(trips);

                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () =>
                        context.read<DriverTripCubit>().getDriverTrips(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          _buildStatsRow(trips),
                          const SizedBox(height: 16),
                          _buildFilterTabs(trips),
                          const SizedBox(height: 16),
                          if (filteredTrips.isEmpty)
                            _buildEmptyRequests()
                          else
                            ...filteredTrips.map(
                              (trip) => _buildTripCard(trip),
                            ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty State ──────────────────────────────────────────────────────────────

  Widget _buildEmptyRequests() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.inbox_outlined, size: 48, color: Color(0xFF9CA3AF)),
          const SizedBox(height: 12),
          Text(
            'No requests available',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'New requests will appear here',
            style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 10),
        ],
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
        top: topPadding + 20,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trips',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(
                'View your past trips and earnings',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Stats Row ────────────────────────────────────────────────────────────────

  Widget _buildStatsRow(List<TripEntity> trips) {
    int totalTrips = trips.length;
    double totalEarned = 0;
    double totalRating = 0.0;
    int ratedTrips = 0;

    for (var trip in trips) {
      if (trip.status.toUpperCase() == 'COMPLETED') {
        totalEarned += trip.price;
        if (trip.rating != null) {
          totalRating += trip.rating!;
          ratedTrips++;
        }
      }
    }
    String averageRating = ratedTrips > 0
        ? (totalRating / ratedTrips).toStringAsFixed(1)
        : '0.0';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
          Expanded(
            child: _buildStatItem(
              icon: Icons.local_shipping_outlined,
              iconColor: const Color(0xFF3B82F6),
              label: 'Trips',
              value: totalTrips.toString(),
            ),
          ),
          Container(width: 1, height: 40, color: const Color(0xFFF3F4F6)),
          Expanded(
            child: _buildStatItem(
              icon: Icons.attach_money_rounded,
              iconColor: const Color(0xFF22C55E),
              label: 'Earned',
              value: totalEarned.toStringAsFixed(0),
            ),
          ),
          Container(width: 1, height: 40, color: const Color(0xFFF3F4F6)),
          Expanded(
            child: _buildStatItem(
              icon: Icons.star_outline_rounded,
              iconColor: const Color(0xFFE8A020),
              label: 'Rating',
              value: averageRating,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: iconColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 34, 34, 35),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }

  // ── Filter Tabs ──────────────────────────────────────────────────────────────

  Widget _buildFilterTabs(List<TripEntity> trips) {
    final completedCount = trips
        .where((t) => t.status.toUpperCase() == 'COMPLETED')
        .length;
    final cancelledCount = trips
        .where((t) => t.status.toUpperCase() == 'CANCELLED')
        .length;
    final allCount = trips.length;

    final tabs = [
      'All ($allCount)',
      'Completed ($completedCount)',
      'Cancelled ($cancelledCount)',
    ];

    return Row(
      children: List.generate(tabs.length, (i) {
        final isActive = _selectedTab == i;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedTab = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: i < tabs.length - 1 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive ? AppColors.primary : const Color(0xFFE5E7EB),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                tabs[i],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : const Color(0xFF6B7280),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // ── Trip Card ────────────────────────────────────────────────────────────────

  Widget _buildTripCard(TripEntity trip) {
    final isCancelled = trip.status.toUpperCase() == 'CANCELLED';
    final dateStr = trip.date != null
        ? DateFormat('dd MMM yyyy').format(trip.date!)
        : 'N/A';

    IconData categoryIcon = Icons.inventory_2_outlined;
    final goods = trip.typeOfGoods.toLowerCase();
    if (goods.contains('food')) {
      categoryIcon = Icons.fastfood_outlined;
    } else if (goods.contains('electronic')) {
      categoryIcon = Icons.devices_outlined;
    } else if (goods.contains('furniture')) {
      categoryIcon = Icons.chair_outlined;
    } else if (goods.contains('building') || goods.contains('construction')) {
      categoryIcon = Icons.construction_outlined;
    }

    return InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).pushNamed(AppRouteNames.tripDetail, arguments: trip.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
            // ── Top: ID + status + earning ─────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          trip.tripNumber,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusBadge(trip.status),
                    ],
                  ),
                ),
                if (!isCancelled)
                  Text(
                    '+${trip.currency} ${trip.price}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF22C55E),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 6),

            // ── Date + rating ──────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      dateStr,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
                if (trip.rating != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: Color(0xFFE8A020),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        trip.rating.toString(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                    ],
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Pickup ─────────────────────────────────────────────
            _buildLocationRow(
              icon: Icons.circle,
              iconColor: const Color(0xFF22C55E),
              label: 'PICKUP',
              value: trip.pickup,
            ),

            // ── Drop-offs ───────────────────────────────────────────
            if (trip.dropOff.isNotEmpty)
              ...trip.dropOff
                  .map(
                    (dropOffItem) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Connector line
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Container(
                            width: 1.5,
                            height: 16,
                            color: const Color(0xFFE5E7EB),
                          ),
                        ),
                        _buildLocationRow(
                          icon: Icons.location_on,
                          iconColor: const Color(0xFFEF4444),
                          label: 'DROP-OFF',
                          value: dropOffItem,
                        ),
                      ],
                    ),
                  )
                  .toList()
            else ...[
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Container(
                  width: 1.5,
                  height: 16,
                  color: const Color(0xFFE5E7EB),
                ),
              ),
              _buildLocationRow(
                icon: Icons.location_on,
                iconColor: const Color(0xFFEF4444),
                label: 'DROP-OFF',
                value: 'N/A',
              ),
            ],

            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            const SizedBox(height: 10),

            // ── Footer ────────────────────────────────────────────
            Row(
              children: [
                const Icon(
                  Icons.navigation_outlined,
                  size: 13,
                  color: Color(0xFF9CA3AF),
                ),
                const SizedBox(width: 4),
                Text(
                  '${trip.estimatedTime} min',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(width: 6),
                const Text('•', style: TextStyle(color: Color(0xFF9CA3AF))),
                const SizedBox(width: 6),
                Icon(categoryIcon, size: 13, color: const Color(0xFF9CA3AF)),
                const SizedBox(width: 4),
                Text(
                  trip.typeOfGoods,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(width: 6),
                const Text('•', style: TextStyle(color: Color(0xFF9CA3AF))),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    trip.user.name ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Status Badge ─────────────────────────────────────────────────────────────

  Widget _buildStatusBadge(String status) {
    final isCompleted = status.toUpperCase() == 'COMPLETED';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isCompleted ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: isCompleted
              ? const Color(0xFF22C55E)
              : const Color(0xFFEF4444),
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  // ── Location Row ─────────────────────────────────────────────────────────────

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
          padding: const EdgeInsets.only(top: 2),
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
