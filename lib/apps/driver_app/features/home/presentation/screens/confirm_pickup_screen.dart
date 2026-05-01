import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/driver_app/features/home/presentation/widgets/pickup_confirm_bottomsheet_widget.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/entities/trip_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/presentation/cubit/driver_trip_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/presentation/cubit/driver_trip_states.dart';

class ConfirmPickupScreen extends StatefulWidget {
  final TripEntity trip;
  const ConfirmPickupScreen({super.key, required this.trip});

  @override
  State<ConfirmPickupScreen> createState() => _ConfirmPickupScreenState();
}

class _ConfirmPickupScreenState extends State<ConfirmPickupScreen> {
  static const int _otpLength = 4;
  final List<TextEditingController> _controllers = List.generate(
    _otpLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    _otpLength,
    (_) => FocusNode(),
  );

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
    setState(() {});
  }

  void _onKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  bool get _isOtpComplete => _controllers.every((c) => c.text.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return BlocListener<DriverTripCubit, DriverTripStates>(
      listenWhen: (previous, current) =>
          previous.confirmPickupStatus != current.confirmPickupStatus,
      listener: (context, state) {
        if (state.confirmPickupStatus == RequestStatus.success) {
          context.read<DriverTripCubit>().getDriverTripById(widget.trip.id);
          PickupConfirmedBottomSheet.show(context, widget.trip);
        } else if (state.confirmPickupStatus == RequestStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.confirmPickupMessage ?? 'An error occurred'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Column(
          children: [
            // ── Blue Header ──────────────────────────────────────────
            _buildHeader(context),

            // ── Scrollable Body ──────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // ── Trip Info Card ───────────────────────────────
                    _buildTripInfoCard(),

                    const SizedBox(height: 16),

                    // ── Ask Sender Note ──────────────────────────────
                    _buildAskSenderNote(),

                    const SizedBox(height: 24),

                    // ── OTP Section ──────────────────────────────────
                    const Text(
                      'Enter 4-Digit OTP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ── OTP Boxes ────────────────────────────────────
                    _buildOtpRow(),

                    const SizedBox(height: 24),

                    // ── Confirm Button ───────────────────────────────
                    _buildConfirmButton(),

                    const SizedBox(height: 16),

                    // ── Contact Support ──────────────────────────────
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          final Uri uri = Uri.parse(
                            "https://wa.me/201021118492?text=${Uri.encodeComponent('I have an issue with this trip')}",
                          );
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        child: const Text(
                          'Having trouble? Contact support',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
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
        top: topPadding + 20,
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
                'Confirm Pickup',
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

  // ── Trip Info Card ───────────────────────────────────────────────────────────

  Widget _buildTripInfoCard() {
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
            subValue: null,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFF3F4F6)),
          ),

          // Pickup Location
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            iconColor: const Color(0xFFE8A020),
            iconBgColor: const Color(0xFFFFFBEB),
            label: 'Pickup Location',
            value: widget.trip.pickup,
            subValue: null,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFF3F4F6)),
          ),

          // Goods
          _buildInfoRow(
            icon: Icons.inventory_2_outlined,
            iconColor: const Color(0xFF6B7280),
            iconBgColor: const Color(0xFFF5F7FA),
            label: 'Goods',
            value:
                '${widget.trip.typeOfGoods}${widget.trip.weight != null ? ' • ${widget.trip.weight} tons' : ''}',
            subValue: null,
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
    required String? subValue,
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
        Expanded(
          child: Column(
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (subValue != null)
                Text(
                  subValue,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Ask Sender Note ──────────────────────────────────────────────────────────

  Widget _buildAskSenderNote() {
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
        children: const [
          Text(
            'Ask the sender for their OTP',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'The sender has received a 4-digit OTP code. Enter it below to confirm you\'ve picked up the goods.',
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
          child: _buildOtpBox(index),
        );
      }),
    );
  }

  Widget _buildOtpBox(int index) {
    final isFilled = _controllers[index].text.isNotEmpty;
    final isFocused = _focusNodes[index].hasFocus;

    return KeyboardListener(
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
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isFilled
                ? const Color(0xFFEEF2FB)
                : const Color(0xFFF5F7FA),
            counterText: '',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isFilled
                    ? AppColors.primary.withOpacity(0.4)
                    : const Color(0xFFE5E7EB),
                width: 1.5,
              ),
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
    );
  }

  // ── Confirm Button ───────────────────────────────────────────────────────────

  Widget _buildConfirmButton() {
    return BlocBuilder<DriverTripCubit, DriverTripStates>(
      builder: (context, state) {
        final isLoading = state.confirmPickupStatus == RequestStatus.loading;

        return InkWell(
          onTap: () {
            if (_isOtpComplete && !isLoading) {
              final otp = _controllers.map((c) => c.text).join();
              context.read<DriverTripCubit>().confirmPickup(
                widget.trip.id,
                otp,
              );
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: _isOtpComplete
                  ? AppColors.primary
                  : const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    'Confirm Pickup',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _isOtpComplete
                          ? Colors.white
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
