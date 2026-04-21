import 'package:flutter/material.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/widgets/custom_text_button_widget.dart';

class PendingVerificationScreen extends StatelessWidget {
  const PendingVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),

              // ── Pending Icon ───────────────────────────────────────
              _buildPendingIcon(),

              const SizedBox(height: 20),

              // ── Title ──────────────────────────────────────────────
              const Text(
                'Pending Verification',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),

              const SizedBox(height: 10),

              // ── Subtitle ───────────────────────────────────────────
              const Text(
                'Your registration is under review by our\nadmin team',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 20),

              // ── What Happens Next card ─────────────────────────────
              _buildWhatHappensNextCard(),

              const SizedBox(height: 24),

              // ── Verification Process ───────────────────────────────
              _buildVerificationProcess(),

              const SizedBox(height: 20),

              // ── Tip Note ──────────────────────────────────────────
              _buildTipNote(),

              const SizedBox(height: 32),

              // ── Go Back Button ────────────────────────────────────
              CustomTextButtomWidget(
                onClick: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRouteNames.loginScreen,
                  (route) => false,
                ),
                btnTitle: '← Go Back',
                btnTitleSize: 16,
                btnTitleColor: const Color(0xFF1A1A2E),
                buttonColor: Colors.white,
                borderColor: const Color(0xFFDDE1E7),
                borderRaduisSize: 14,
                borderWidth: 1.5,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── AppBar ──────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Pending Verification',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }

  // ── Pending clock icon ──────────────────────────────────────────────────────

  Widget _buildPendingIcon() {
    return Container(
      width: 90,
      height: 90,
      decoration: const BoxDecoration(
        color: Color(0xFFE8A020),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.access_time_rounded,
        color: Colors.white,
        size: 46,
      ),
    );
  }

  // ── What Happens Next card ──────────────────────────────────────────────────

  Widget _buildWhatHappensNextCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8A020).withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE8A020).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.access_time_rounded,
              size: 18,
              color: Color(0xFFE8A020),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What happens next?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Our team will review your profile and documents within 24-48 hours. You\'ll receive a notification once approved.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Verification Process timeline ───────────────────────────────────────────

  Widget _buildVerificationProcess() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verification Process',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 16),

        // Step 1 — completed
        _buildTimelineStep(
          icon: Icons.check_circle_rounded,
          iconColor: const Color(0xFF22C55E),
          iconBgColor: const Color(0xFFDCFCE7),
          title: 'Registration Submitted',
          subtitle: 'Your application has been received',
          isCompleted: true,
          isLast: false,
        ),

        // Step 2 — in progress
        _buildTimelineStep(
          icon: Icons.folder_open_outlined,
          iconColor: const Color(0xFFE8A020),
          iconBgColor: const Color(0xFFFFF3CD),
          title: 'Document Verification',
          subtitle: 'Admin team is reviewing your documents',
          isCompleted: false,
          isLast: false,
        ),

        // Step 3 — pending
        _buildTimelineStep(
          icon: Icons.notifications_outlined,
          iconColor: const Color(0xFF9CA3AF),
          iconBgColor: const Color(0xFFF3F4F6),
          title: 'Approval Notification',
          subtitle: "You'll be notified once approved",
          isCompleted: false,
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildTimelineStep({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Left: icon + vertical line ─────────────────────────
          Column(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 14),

          // ── Right: text ────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color:
                          isCompleted ||
                              !isLast && iconColor != const Color(0xFF9CA3AF)
                          ? const Color(0xFF1A1A2E)
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                      height: 1.4,
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

  // ── Tip note ────────────────────────────────────────────────────────────────

  Widget _buildTipNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(
            Icons.lightbulb_outline_rounded,
            size: 16,
            color: Color(0xFF9CA3AF),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Tip: Make sure notifications are enabled to receive instant updates about your verification status',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
