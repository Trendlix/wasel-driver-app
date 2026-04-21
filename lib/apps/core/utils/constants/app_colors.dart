import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF004AAD);
  static const Color secondary = Color(0xFFE8A020); // Golden yellow
  static const Color accent = Color(0xFFE84020); // Red-orange (logo)
  static const Color background = Colors.white; // Light grey bg
  static const Color white = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color driverCard = Color(0xFF1A3A6B); // Blue card
  static const Color storageCard = Color(0xFFE8A020); // Yellow card
  static const Color arrowIcon = Color(0xFFFFFFFF);
  static const Color bgGray = Color.fromARGB(255, 253, 253, 253);
  static const Color progressInactive = Color(0xFFE0E0E0);
  static const Color requiredBadge = Color(0xFFFFF3CD);
  static const Color requiredBadgeText = Color(0xFFB87A00);
  static const Color cancelRequest = Color(0xFFFF4C4C);
  static const Color primaryLight = Color(0xFFDBEAFE);
  static const Color subTitleColor = Color(0xFF4A5565);
  static const Color profileSubTitle = Color(0xFF6A7282);
  static const Color noteCardColor = Color.fromARGB(255, 238, 245, 255);
  static const Color greenColor = Color(0xFF14C38E);
}

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle heading = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: 0.1,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
    letterSpacing: 0.1,
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
    letterSpacing: 0.2,
  );
}

class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double cardRadius = 16.0;
  static const double iconRadius = 12.0;
}
