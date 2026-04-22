import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/widgets/custom_snackbar_widget.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/entities/trip_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/presentation/cubit/driver_trip_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/presentation/cubit/driver_trip_states.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';

class ConfirmDeliveryOtpScreen extends StatefulWidget {
  final File image;
  final TripEntity trip;
  const ConfirmDeliveryOtpScreen({
    super.key,
    required this.image,
    required this.trip,
  });

  @override
  State<ConfirmDeliveryOtpScreen> createState() =>
      _ConfirmDeliveryOtpScreenState();
}

class _ConfirmDeliveryOtpScreenState extends State<ConfirmDeliveryOtpScreen> {
  static const int _otpLength = 4;
  final List<TextEditingController> _controllers = List.generate(
    _otpLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    _otpLength,
    (_) => FocusNode(),
  );

  bool get _isComplete => _controllers.every((c) => c.text.isNotEmpty);

  @override
  void initState() {
    super.initState();
    for (final c in _controllers) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _onKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: BlocConsumer<DriverTripCubit, DriverTripStates>(
        listenWhen: (previous, current) =>
            previous.confirmDeliveryStatus != current.confirmDeliveryStatus,
        listener: (context, state) {
          if (state.confirmDeliveryStatus == RequestStatus.success) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRouteNames.confirmDeliverySuccessScreen,
              ModalRoute.withName(AppRouteNames.mainShellScreen),
              arguments: state.tripSummaries,
            );
          } else if (state.confirmDeliveryStatus == RequestStatus.error) {
            showSnackError(
              context,
              state.confirmDeliveryMessage ?? 'Something went wrong',
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // ── Blue Header ──────────────────────────────────────────
              _buildHeader(context),

              // ── Body ─────────────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // ── Ask OTP Note ───────────────────────────────
                      _buildAskOtpNote(),

                      const SizedBox(height: 24),

                      // ── OTP Label ──────────────────────────────────
                      const Text(
                        'Enter 4-Digit OTP',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ── OTP Boxes ──────────────────────────────────
                      _buildOtpRow(),

                      const SizedBox(height: 12),

                      // ── Support Link ───────────────────────────────
                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: 'Having trouble? ',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9CA3AF),
                            ),
                            children: [
                              TextSpan(
                                text: 'Contact support',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Sender / Deliver Location / Goods ──────────
                      _buildInfoCard(),

                      const SizedBox(height: 24),

                      // ── Complete Delivery Button ───────────────────
                      _buildCompleteButton(state),

                      const SizedBox(height: 16),

                      // ── Support Link ───────────────────────────────
                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: 'Having trouble? ',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9CA3AF),
                            ),
                            children: [
                              TextSpan(
                                text: 'Contact support',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Blue Header ─────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: EdgeInsets.only(
        top: topPadding + 12,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Confirm Deliver',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(
                'Enter OTP from sender',
                style: TextStyle(fontSize: 11, color: Colors.white60),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Ask OTP Note ─────────────────────────────────────────────────────────────

  Widget _buildAskOtpNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ask the sender for their OTP',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "The sender has received a 4-digit OTP code. Enter it below to confirm you've picked up the goods.",
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── OTP Row ──────────────────────────────────────────────────────────────────

  Widget _buildOtpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_otpLength, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (e) => _onKeyEvent(e, index),
            child: SizedBox(
              width: 46,
              height: 54,
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                onChanged: (v) => _onChanged(v, index),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(1),
                ],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  counterText: '',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // ── Info Card ────────────────────────────────────────────────────────────────

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Sender
          _buildInfoRow(
            icon: Icons.person_outline_rounded,
            iconColor: AppColors.primary,
            iconBgColor: const Color(0xFFEEF2FB),
            label: 'Sender',
            value: widget.trip.user.name ?? 'Unknown',
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 16),

          // Deliver Location
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            iconColor: const Color(0xFFE8A020),
            iconBgColor: const Color(0xFFFFFBEB),
            label: 'Deliver Location',
            value: widget.trip.dropOff.isNotEmpty
                ? widget.trip.dropOff.first
                : 'N/A',
            subValue: widget.trip.dropOff.length > 1
                ? '+${widget.trip.dropOff.length - 1} additional stops'
                : null,
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 16),

          // Goods
          _buildInfoRow(
            icon: Icons.inventory_2_outlined,
            iconColor: const Color(0xFF6B7280),
            iconBgColor: const Color(0xFFF5F7FA),
            label: 'Goods',
            value:
                '${widget.trip.typeOfGoods}${widget.trip.weight != null ? ' • ${widget.trip.weight} tons' : ''}',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String label,
    required String value,
    String? subValue,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            if (subValue != null)
              Text(
                subValue,
                style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
              ),
          ],
        ),
      ],
    );
  }

  // ── Complete Delivery Button ──────────────────────────────────────────────────

  Widget _buildCompleteButton(DriverTripStates state) {
    final isLoading = state.confirmDeliveryStatus == RequestStatus.loading;
    return InkWell(
      onTap: (!isLoading && _isComplete)
          ? () {
              context.read<DriverTripCubit>().confirmDelivery(
                widget.trip.id,
                _controllers.map((e) => e.text).join(),
                widget.image.path,
              );
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: (!isLoading && _isComplete)
              ? AppColors.primary
              : const Color(0xFFD1D5DB),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Complete Delivery',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
