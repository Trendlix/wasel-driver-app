import 'package:flutter/material.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/entities/trip_entity.dart';

class PickupConfirmedBottomSheet extends StatelessWidget {
  final TripEntity trip;
  const PickupConfirmedBottomSheet({super.key, required this.trip});

  TripEntity get updatedTrip => TripEntity(
    id: trip.id,
    tripNumber: trip.tripNumber,
    price: trip.price,
    currency: trip.currency,
    status: trip.status,
    subStatus: 'picked_up',
    user: trip.user,
    pickup: trip.pickup,
    dropOff: trip.dropOff,
    typeOfGoods: trip.typeOfGoods,
    estimatedTime: trip.estimatedTime,
    weight: trip.weight,
    distanceBetween: trip.distanceBetween,
    date: trip.date,
  );
  static void show(BuildContext context, TripEntity trip) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (_) => PickupConfirmedBottomSheet(trip: trip),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Close Button ───────────────────────────────────────
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Navigator.of(context).popUntil(
                ModalRoute.withName(AppRouteNames.navigateToPickupScreen),
              ),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ── Green Check Icon ───────────────────────────────────
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFF22C55E),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 42,
            ),
          ),

          const SizedBox(height: 20),

          // ── Title ──────────────────────────────────────────────
          const Text(
            'Pickup Confirmed!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),

          const SizedBox(height: 8),

          // ── Subtitle ───────────────────────────────────────────
          const Text(
            "You've successfully picked up the goods",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),

          // ── Trip Info Card ─────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trip ID + goods type
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: const Icon(
                        Icons.inventory_2_outlined,
                        size: 18,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trip #${updatedTrip.tripNumber}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          trip.typeOfGoods,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFFE5E7EB)),
                const SizedBox(height: 14),

                // Next destination
                const Text(
                  'Next Destination',
                  style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
                ),
                const SizedBox(height: 4),
                Text(
                  trip.dropOff.isNotEmpty ? trip.dropOff.first : 'N/A',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Start Delivery Button ──────────────────────────────
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRouteNames.navigateToPickupScreen,
                ModalRoute.withName(AppRouteNames.mainShellScreen),
                arguments: updatedTrip,
              );
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
                  Icon(Icons.navigation_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Start Delivery',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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
}
