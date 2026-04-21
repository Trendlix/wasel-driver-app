import 'package:flutter/material.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/widgets/custom_text_button_widget.dart';

class RequestNotApprovedScreen extends StatelessWidget {
  final String reason;
  const RequestNotApprovedScreen({super.key, required this.reason});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),

                  // ── Rejected Icon ──────────────────────────────────
                  Center(child: _buildRejectedIcon()),

                  const SizedBox(height: 20),

                  // ── Driver Registration Badge ──────────────────────
                  Center(child: _buildRegistrationBadge()),

                  const SizedBox(height: 20),

                  // ── Title ──────────────────────────────────────────
                  const Center(
                    child: Text(
                      'Request Not Approved',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ── Subtitle ───────────────────────────────────────
                  const Center(
                    child: Text(
                      'Unfortunately, we cannot approve your\ndriver registration at this time.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Reason for Rejection card ──────────────────────
                  _buildRejectionReasonCard(reason),

                  const SizedBox(height: 28),

                  // ── Need Help section ──────────────────────────────
                  _buildNeedHelpSection(),

                  const Spacer(),

                  const SizedBox(height: 24),

                  // ── Contact Support Button ─────────────────────────
                  CustomTextButtomWidget(
                    onClick: () {},
                    btnTitle: '💬  Contact Support',
                    btnTitleSize: 16,
                    btnTitleColor: const Color(0xFF1A1A2E),
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
        'Request Not Approved',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }

  // ── Rejected icon ───────────────────────────────────────────────────────────

  Widget _buildRejectedIcon() {
    return Container(
      width: 90,
      height: 90,
      decoration: const BoxDecoration(
        color: Color(0xFFEF4444),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.close_rounded, color: Colors.white, size: 48),
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

  // ── Rejection reason card ───────────────────────────────────────────────────

  Widget _buildRejectionReasonCard(String reason) {
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
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFE8A020).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              size: 18,
              color: Color(0xFFE8A020),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reason for Rejection',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  reason,
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

  // ── Need Help section ───────────────────────────────────────────────────────

  Widget _buildNeedHelpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Need Help?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'If you believe this is a mistake or need clarification, please contact our support team. We\'re here to help!',
          style: TextStyle(fontSize: 13, color: Color(0xFF6B7280), height: 1.5),
        ),
        const SizedBox(height: 16),

        // ── Call Support ─────────────────────────────────────────
        _buildContactRow(
          icon: Icons.phone_outlined,
          iconColor: const Color(0xFF22C55E),
          iconBgColor: const Color(0xFFDCFCE7),
          title: 'Call Support',
          subtitle: '+966 12 345 6789',
        ),

        const SizedBox(height: 12),

        // ── Email Support ────────────────────────────────────────
        _buildContactRow(
          icon: Icons.email_outlined,
          iconColor: const Color(0xFF1A3A6B),
          iconBgColor: const Color(0xFFEEF2FB),
          title: 'Email Support',
          subtitle: 'support@wasel.app',
        ),
      ],
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
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
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
