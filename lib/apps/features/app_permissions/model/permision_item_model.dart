import 'package:flutter/material.dart';

enum PermissionType { location, notification, camera }

class PermissionItem {
  final PermissionType type;
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final bool isRequired;
  final String step;
  final String? skipLabel; // null means not skippable

  const PermissionItem({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.isRequired,
    required this.step,
    this.skipLabel,
  });
}

// All 3 permission steps definition
class AppPermissions {
  static const List<PermissionItem> steps = [
    PermissionItem(
      type: PermissionType.location,
      title: 'Location Access',
      description:
          'Required for trip tracking and finding nearby opportunities',
      icon: Icons.location_on_outlined,
      iconColor: Color(0xFF1A3A6B),
      iconBackgroundColor: Color(0xFFE8EEF8),
      isRequired: true,
      step: 'Step 1 of 3',
    ),
    PermissionItem(
      type: PermissionType.notification,
      title: 'Push Notifications',
      description: 'Get instant alerts for new trips and important updates',
      icon: Icons.notifications_outlined,
      iconColor: Color(0xFFE8A020),
      iconBackgroundColor: Color(0xFFFFF3E0),
      isRequired: true,
      step: 'Step 2 of 3',
    ),
    PermissionItem(
      type: PermissionType.camera,
      title: 'Camera & Gallery',
      description: 'Upload documents, photos, and proof of delivery',
      icon: Icons.camera_alt_outlined,
      iconColor: Color(0xFF2E9E7D),
      iconBackgroundColor: Color(0xFFE0F5EF),
      isRequired: false,
      step: 'Step 3 of 3',
      skipLabel: 'Skip for now',
    ),
  ];
}
