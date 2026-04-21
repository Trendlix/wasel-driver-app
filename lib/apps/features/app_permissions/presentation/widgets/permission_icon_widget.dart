import 'package:flutter/material.dart';

class PermissionIconCircle extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const PermissionIconCircle({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Icon(icon, size: 44, color: iconColor),
    );
  }
}
