import 'package:flutter/material.dart';

Widget buildErrorCard({
  required String message,
  required VoidCallback onRetry,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Error icon
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 22),
          const SizedBox(width: 12),

          // Error message
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Retry button
          InkWell(
            onTap: onRetry,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.refresh,
                color: Colors.redAccent,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
