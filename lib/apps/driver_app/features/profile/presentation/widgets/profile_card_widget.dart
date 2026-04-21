import 'package:flutter/material.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';

class ProfileCard extends StatelessWidget {
  final String fullName;
  final String phone;
  final String email;
  final bool isPlaceholder;
  final VoidCallback? onRetry; // New: Callback for the retry action
  final String? avatar;
  final String? avatarUrl;

  const ProfileCard({
    super.key,
    required this.fullName,
    required this.phone,
    required this.email,
    this.isPlaceholder = false,
    this.onRetry, // New: Add to constructor
    this.avatar,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final fullImageUrl =
        "https://wasel-dev.s3.eu-north-1.amazonaws.com/$avatar";
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          // Avatar Section
          if (avatarUrl != null)
            CircleAvatar(radius: 32, backgroundImage: NetworkImage(avatarUrl!)),
          if (avatarUrl == null)
            CircleAvatar(
              radius: 32,
              backgroundColor: isPlaceholder ? Colors.grey[300] : Colors.white,
              child: Text(
                isPlaceholder
                    ? "?"
                    : (fullName.isNotEmpty ? fullName[0].toUpperCase() : ""),
                style: TextStyle(
                  fontSize: 24,
                  color: isPlaceholder ? Colors.grey : AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(width: 15),

          // Info Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  phone,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Retry Button Section (Shows only if isPlaceholder is true)
          if (isPlaceholder && onRetry != null)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
