import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/presentation/widgets/profile_card_widget.dart';

class ProfileShimmerLoading extends StatelessWidget {
  const ProfileShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.1),
      highlightColor: Colors.white.withOpacity(0.2),
      child: ProfileCard(
        fullName: "Loading Name...", // Dummy text for sizing
        phone: "Loading Phone...",
        email: "Loading Email...",
        isPlaceholder: true,
      ),
    );
  }
}
