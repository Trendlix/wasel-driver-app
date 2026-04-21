import 'package:flutter/material.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/widgets/custom_text_button_widget.dart';

class DriverApprovedScreen extends StatelessWidget {
  const DriverApprovedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // ── Check Icon ───────────────────────────────────────
                  _buildCheckIcon(),

                  const SizedBox(height: 20),

                  // ── Driver Approved Badge ────────────────────────────
                  _buildApprovedBadge(),

                  const SizedBox(height: 28),

                  // ── Title ────────────────────────────────────────────
                  const Text(
                    'Congratulations!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ── Subtitle 1 ───────────────────────────────────────
                  const Text(
                    'Your Driver Account is Approved',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Subtitle 2 ───────────────────────────────────────
                  Text(
                    'You can now start accepting trip requests\nand earning with Wasel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.75),
                      height: 1.6,
                    ),
                  ),

                  const Spacer(flex: 3),

                  // ── Start Using Wasel Button ─────────────────────────
                  CustomTextButtomWidget(
                    onClick: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRouteNames.mainShellScreen,
                        (route) => false,
                      );
                    },
                    btnTitle: 'Start Using Wasel  →',
                    btnTitleSize: 16,
                    btnTitleColor: const Color(0xFF1A1A2E),
                    buttonColor: AppColors.secondary,
                    borderColor: AppColors.secondary,
                    borderRaduisSize: 14,
                    borderWidth: 0,
                  ),

                  const SizedBox(height: 16),

                  // ── Welcome text ─────────────────────────────────────
                  Text(
                    'Welcome to the Wasel family! 🎉',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),

                  const SizedBox(height: 32),
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
      backgroundColor: AppColors.primary,
      elevation: 0,
      title: const Text(
        'Your Driver Account is Approved',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white70,
        ),
      ),
    );
  }

  // ── Check circle icon ───────────────────────────────────────────────────────

  Widget _buildCheckIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: const Icon(
        Icons.check_circle_outline_rounded,
        color: Colors.white,
        size: 52,
      ),
    );
  }

  // ── Driver Approved badge ───────────────────────────────────────────────────

  Widget _buildApprovedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.local_shipping_outlined, size: 15, color: Colors.white),
          SizedBox(width: 6),
          Text(
            'Driver Approved',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
