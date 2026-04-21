import 'package:flutter/material.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';

class WithdrawalSuccessScreen extends StatelessWidget {
  const WithdrawalSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Blue Header Section ──────────────────────────────────
          _buildBlueHeader(context),

          // ── White Scrollable Body ────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Withdrawal Amount Card ───────────────────────
                  _buildAmountCard(),

                  const SizedBox(height: 16),

                  // ── What Happens Next ────────────────────────────
                  _buildWhatHappensNext(),

                  const SizedBox(height: 24),

                  // ── Processing Timeline ──────────────────────────
                  _buildProcessingTimeline(),

                  const SizedBox(height: 16),

                  // ── Notification Note ────────────────────────────
                  _buildNotificationNote(),

                  const SizedBox(height: 24),

                  // ── Got It Button ────────────────────────────────
                  _buildGotItButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Blue Header ─────────────────────────────────────────────────────────────

  Widget _buildBlueHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: EdgeInsets.only(
        top: topPadding + 24,
        left: 24,
        right: 24,
        bottom: 32,
      ),
      child: Column(
        children: [
          // Check icon circle
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Request Sent Successfully!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Your withdrawal is being processed',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  // ── Withdrawal Amount Card ───────────────────────────────────────────────────

  Widget _buildAmountCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Text(
            'Withdrawal Amount',
            style: TextStyle(fontSize: 13, color: Colors.white70),
          ),
          SizedBox(height: 8),
          Text(
            '1,850',
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
          Text(
            'EGP',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  // ── What Happens Next ────────────────────────────────────────────────────────

  Widget _buildWhatHappensNext() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 16,
                color: AppColors.primary.withOpacity(0.7),
              ),
              const SizedBox(width: 8),
              const Text(
                'What happens next?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Your withdrawal request is being reviewed. Funds typically arrive in your bank account within 1-3 business days. We\'ll notify you once the transfer is complete.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ── Processing Timeline ──────────────────────────────────────────────────────

  Widget _buildProcessingTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Processing Timeline',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 16),
        _buildTimelineStep(
          icon: Icons.check_circle_rounded,
          iconColor: const Color(0xFF22C55E),
          iconBgColor: const Color(0xFFDCFCE7),
          title: 'Request Submitted',
          subtitle: 'Your request has been received',
          isLast: false,
          isActive: true,
        ),
        _buildTimelineStep(
          icon: Icons.access_time_rounded,
          iconColor: const Color(0xFFE8A020),
          iconBgColor: const Color(0xFFFFF3CD),
          title: 'Under Review',
          subtitle: 'Usually takes a few hours',
          isLast: false,
          isActive: false,
        ),
        _buildTimelineStep(
          icon: Icons.account_balance_outlined,
          iconColor: const Color(0xFF9CA3AF),
          iconBgColor: const Color(0xFFF3F4F6),
          title: 'Transferred to Bank',
          subtitle: '1-3 business days',
          isLast: true,
          isActive: false,
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
    required bool isLast,
    required bool isActive,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + vertical line
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

          // Text
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20, top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isActive
                          ? const Color(0xFF1A1A2E)
                          : iconColor == const Color(0xFF9CA3AF)
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 2),
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

  // ── Notification Note ────────────────────────────────────────────────────────

  Widget _buildNotificationNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8A020).withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('🔔', style: TextStyle(fontSize: 14)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "You'll receive a notification when your funds have been transferred",
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF92400E),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Got It Button ────────────────────────────────────────────────────────────

  Widget _buildGotItButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: const Text(
          'Got It',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
