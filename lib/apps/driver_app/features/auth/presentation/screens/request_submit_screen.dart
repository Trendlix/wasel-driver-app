import 'package:flutter/material.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/widgets/custom_text_button_widget.dart';

class RequestSubmittedScreen extends StatelessWidget {
  final String referenceId;

  const RequestSubmittedScreen({super.key, required this.referenceId});

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

              // ── Success Icon ───────────────────────────────────────
              _buildSuccessIcon(),

              const SizedBox(height: 20),

              // ── Driver Registration Badge ──────────────────────────
              _buildRegistrationBadge(),

              const SizedBox(height: 20),

              // ── Title ──────────────────────────────────────────────
              const Text(
                'Request Submitted\nSuccessfully',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 10),

              // ── Subtitle ───────────────────────────────────────────
              const Text(
                'Your request has been submitted and is\nbeing reviewed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              // ── What Happens Next ──────────────────────────────────
              _buildWhatHappensNext(),

              const SizedBox(height: 20),

              // ── Stay Updated Note ──────────────────────────────────
              _buildStayUpdatedNote(),

              const SizedBox(height: 20),

              // ── Reference ID ──────────────────────────────────────
              _buildReferenceId(),

              const SizedBox(height: 32),

              // ── View Verification Status Button ────────────────────
              CustomTextButtomWidget(
                onClick: () {
                  Navigator.of(
                    context,
                  ).pushNamed(AppRouteNames.pendingVerificationScreen);
                },
                btnTitle: '🔔  View Verification Status',
                btnTitleSize: 16,
                btnTitleColor: Colors.white,
                buttonColor: AppColors.secondary,
                borderColor: AppColors.secondary,
                borderRaduisSize: 14,
                borderWidth: 0,
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
        'Request Submitted Successfully',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }

  // ── Success circle icon ─────────────────────────────────────────────────────

  Widget _buildSuccessIcon() {
    return Container(
      width: 90,
      height: 90,
      decoration: const BoxDecoration(
        color: Color(0xFF22C55E),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check_rounded, color: Colors.white, size: 48),
    );
  }

  // ── Driver Registration badge ───────────────────────────────────────────────

  Widget _buildRegistrationBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1A3A6B).withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.local_shipping_outlined,
            size: 15,
            color: Color(0xFF1A3A6B),
          ),
          SizedBox(width: 6),
          Text(
            'Driver Registration',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A3A6B),
            ),
          ),
        ],
      ),
    );
  }

  // ── What Happens Next list ──────────────────────────────────────────────────

  Widget _buildWhatHappensNext() {
    const steps = [
      'Admin team will review your documents',
      'Verification typically takes 24-48 hours',
      "You'll receive a notification once approved",
      'Check your email for updates',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What Happens Next?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 14),
        ...List.generate(steps.length, (i) => _buildNextStep(i + 1, steps[i])),
      ],
    );
  }

  Widget _buildNextStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number circle
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FB),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF1A3A6B).withOpacity(0.2),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A3A6B),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stay Updated note ───────────────────────────────────────────────────────

  Widget _buildStayUpdatedNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1A3A6B).withOpacity(0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.notifications_outlined,
            size: 18,
            color: const Color(0xFF1A3A6B).withOpacity(0.7),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stay Updated',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A3A6B),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Enable notifications to receive instant updates about your request status',
                  style: TextStyle(
                    fontSize: 12,
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

  // ── Reference ID ────────────────────────────────────────────────────────────

  Widget _buildReferenceId() {
    return Column(
      children: [
        const Text(
          'Reference ID',
          style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
        ),
        const SizedBox(height: 4),
        Text(
          referenceId,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
