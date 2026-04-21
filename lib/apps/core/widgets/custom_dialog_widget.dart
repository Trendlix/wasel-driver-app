import 'package:flutter/material.dart';
import 'dart:async';

void _showCustomDialog({
  required BuildContext context,
  required String title,
  required String message,
  required Color backgroundColor,
  required Color borderColor,
  required IconData icon,
  required Color iconBgColor,
  required bool autoClose,
}) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.3), // Darkens the background
    transitionDuration: const Duration(
      milliseconds: 500,
    ), // Speed of the slide animation
    pageBuilder: (context, __, ___) {
      // Auto-close logic: Closes the dialog after 5 seconds
      if (autoClose) {
        Future.delayed(const Duration(seconds: 3), () {
          if (context.mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });
      }

      return Center(
        child: Dialog(
          alignment: Alignment.center,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            //  side: BorderSide(color: borderColor, width: 0.3),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Wrap content width
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Leading Icon Box
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 16),
                // Title and Message
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                // Close Button
                IconButton(
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      );
    },
    // Handles the "Slide from Bottom" animation
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position:
            Tween<Offset>(
              begin: const Offset(0, 1), // Starts from off-screen bottom
              end: const Offset(0, 0), // Ends at the center
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCirc, // Smooth deceleration effect
              ),
            ),
        child: child,
      );
    },
  );
}

// --- Implementation Functions ---

/// Displays a success dialog with blue styling
void showSuccess(
  BuildContext context,
  String message, {
  bool autoClose = true,
}) {
  _showCustomDialog(
    context: context,
    title: "Success",
    message: message,
    backgroundColor: const Color(0xFFF0F7FF),
    borderColor: const Color(0xFF3B82F6),
    icon: Icons.check,
    iconBgColor: const Color(0xFF3B82F6),
    autoClose: autoClose,
  );
}

/// Displays an error dialog with red styling
void showError(BuildContext context, String message, {bool autoClose = true}) {
  _showCustomDialog(
    context: context,
    title: "Error",
    message: message,
    backgroundColor: const Color(0xFFFFF5F5),
    borderColor: const Color(0xFFEF4444),
    icon: Icons.close,
    iconBgColor: const Color(0xFFEF4444),
    autoClose: autoClose,
  );
}
