import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wasel_driver/apps/core/enums/app_enums.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/network/api/app_interceptor.dart';
import 'package:wasel_driver/apps/core/network/local/local_storage_service.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_images.dart';
import 'package:wasel_driver/apps/core/widgets/custom_snackbar_widget.dart';
import 'package:wasel_driver/apps/core/widgets/custom_text_button_widget.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/driver_auth_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/driver_auth_states.dart';

class VerifyLoginOtpScreen extends StatefulWidget {
  final String phoneNumber;

  const VerifyLoginOtpScreen({super.key, this.phoneNumber = '1241241241'});

  @override
  State<VerifyLoginOtpScreen> createState() => _VerifyLoginOtpScreenState();
}

class _VerifyLoginOtpScreenState extends State<VerifyLoginOtpScreen> {
  int _secondsRemaining = 58;
  late Timer _timer;

  final GlobalKey<_OtpInputRowState> _otpInputKey =
      GlobalKey<_OtpInputRowState>();

  // Track errors for each individual field
  List<bool> _fieldErrors = [false, false, false, false, false, false];

  // General error message text
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _timer.cancel();
          }
        });
      }
    });
  }

  String get _otpCode => _otpInputKey.currentState?.otpCode ?? '';

  void _clearOtpFields() {
    _otpInputKey.currentState?.clearFields();
  }

  void _verifyOtp() {
    final controllers = _otpInputKey.currentState?.controllers ?? [];
    bool hasAnyEmpty = false;
    List<bool> newErrors = List.filled(6, false);

    for (int i = 0; i < 6; i++) {
      if (controllers[i].text.trim().isEmpty) {
        newErrors[i] = true;
        hasAnyEmpty = true;
      }
    }

    setState(() {
      _fieldErrors = newErrors;
      if (hasAnyEmpty) {
        _errorMessage = "Please fill all required fields.";
      } else {
        _errorMessage = null;
        context.read<DriverAuthCubit>().verifyOtp({
          "otp": _otpCode,
          'type': 'verify',
        });
      }
    });
  }

  void _onFieldChanged(int index) {
    if (_fieldErrors[index]) {
      setState(() {
        _fieldErrors[index] = false;
        if (!_fieldErrors.any((e) => e)) _errorMessage = null;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: BlocListener<DriverAuthCubit, DriverAuthState>(
        listener: (context, state) async {
          if (state.otpRequestStatus.isSuccess) {
            final userState = state.userVerificationTypeModel;
            if (userState?.type != null &&
                userState?.type == VerifyOtpType.register) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRouteNames.registerScreen,
                arguments: state.userVerificationTypeModel?.value,
                (route) => false,
              );
            } else {
              final localStorageService = GetIt.instance<LocalStorageService>();
              // save token in local storage
              await localStorageService.saveToken(userState!.token!);
              await localStorageService.saveRefreshToken(
                userState.refreshToken!,
              );
              if (!context.mounted) return;
              if (userState.status == UserAccountStatus.pending.name) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRouteNames.pendingVerificationScreen,
                  arguments: userState.status,
                  (route) => false,
                );
              } else if (userState.status == UserAccountStatus.rejected.name) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRouteNames.driverCancelledScreen,
                  arguments: userState.rejectionReason,
                  (route) => false,
                );
              } else if (userState.status == UserAccountStatus.approved.name) {
                final isApprovedCached = await localStorageService
                    .getDriverAccountStatus();
                if (!context.mounted) return;
                if (isApprovedCached != null && isApprovedCached == true) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRouteNames.mainShellScreen,
                    //arguments: userState.status,
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRouteNames.driverApprovedScreen,
                    arguments: userState.status,
                    (route) => false,
                  );
                }
              }
            }
          } else if (state.otpRequestStatus.isError) {
            setState(() {
              _errorMessage = state.otpErrorMessage ?? 'Something went wrong';
            });
            context.read<DriverAuthCubit>().reset();
          } // 2. NEW: Handle Resend (checkPhoneIsRegistered) Success
          else if (state.checkPhoneIsRegisteredRequestStatus.isSuccess) {
            showSuccess(context, 'Code sent successfully');
            setState(() {
              _secondsRemaining = 58; // Reset timer
              _errorMessage = null; // Clear old errors
              _fieldErrors = List.filled(6, false);
            });
            _clearOtpFields(); // Optional: clear fields for the new code
            _startTimer(); // Restart the countdown
          }
          // 3. Handle Errors (Existing code)
          else if (state.otpRequestStatus.isError) {
            setState(() {
              _errorMessage = state.otpErrorMessage ?? 'Something went wrong';
            });
            context.read<DriverAuthCubit>().reset();
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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

                    // ── Logo ──────────────────────────────────────────
                    Image.asset(AppImages.waselLogo2, height: 40),

                    const SizedBox(height: 32),

                    // ── Title ─────────────────────────────────────────
                    const Text(
                      'Verify OTP',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ── Subtitle ──────────────────────────────────────
                    Text(
                      'Code sent to ${widget.phoneNumber}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 52),

                    // ── Verification Code Label ───────────────────────
                    const Text(
                      'Verification Code',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── OTP Boxes ─────────────────────────────────────
                    _OtpInputRow(
                      key: _otpInputKey,
                      fieldErrors: _fieldErrors,
                      onFieldChanged: _onFieldChanged,
                      onComplete: _verifyOtp,
                    ),

                    // ── Error Message ─────────────────────────────────
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // ── Timer / Resend Row ────────────────────────────
                    _secondsRemaining == 0
                        ? BlocBuilder<DriverAuthCubit, DriverAuthState>(
                            builder: (context, resendState) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Didn't receive the code? ",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                  resendState
                                          .checkPhoneIsRegisteredRequestStatus
                                          .isLoading
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.primary,
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            context
                                                .read<DriverAuthCubit>()
                                                .checkPhoneIsRegistered(
                                                  widget.phoneNumber,
                                                  AuthMode.verify,
                                                );
                                          },
                                          child: const Text(
                                            'Resend',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF1A3A6B),
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                ],
                              );
                            },
                          )
                        : Center(
                            child: Text.rich(
                              TextSpan(
                                text: "Resend code in ",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B7280),
                                ),
                                children: [
                                  TextSpan(
                                    text: "${_secondsRemaining}s",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A3A6B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                    const Spacer(),

                    // ── Verify & Continue Button ──────────────────────
                    BlocBuilder<DriverAuthCubit, DriverAuthState>(
                      builder: (context, otpState) {
                        return CustomTextButtomWidget(
                          onClick: _verifyOtp,
                          btnTitle: 'Verify & Continue  >',
                          btnTitleSize: 16,
                          btnTitleColor: Colors.white,
                          buttonColor: AppColors.primary,
                          borderColor: AppColors.primary,
                          borderRaduisSize: 14,
                          borderWidth: 0,
                          isLoading: otpState.otpRequestStatus.isLoading,
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    // ── Change Phone Number Button ────────────────────
                    CustomTextButtomWidget(
                      onClick: () => Navigator.pop(context),
                      btnTitle: 'Change Phone Number',
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
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(backgroundColor: Colors.white, elevation: 0);
  }
}

// ── OTP Input Row ─────────────────────────────────────────────────────────────

class _OtpInputRow extends StatefulWidget {
  final List<bool> fieldErrors;
  final ValueChanged<int> onFieldChanged;
  final VoidCallback onComplete;

  const _OtpInputRow({
    super.key,
    required this.fieldErrors,
    required this.onFieldChanged,
    required this.onComplete,
  });

  @override
  State<_OtpInputRow> createState() => _OtpInputRowState();
}

class _OtpInputRowState extends State<_OtpInputRow> {
  static const int _otpLength = 6;

  final List<TextEditingController> _controllers = List.generate(
    _otpLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    _otpLength,
    (_) => FocusNode(),
  );

  List<TextEditingController> get controllers => _controllers;
  String get otpCode => _controllers.map((c) => c.text).join();

  void clearFields() {
    for (final c in _controllers) {
      c.clear();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _onChanged(String value, int index) {
    widget.onFieldChanged(index);
    if (value.isNotEmpty) {
      if (index < _otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last digit entered, trigger completion
        widget.onComplete();
      }
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_otpLength, (index) {
        return _OtpBox(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          hasError: widget.fieldErrors[index],
          onChanged: (v) => _onChanged(v, index),
          onKeyEvent: (e) => _onKeyEvent(e, index),
        );
      }),
    );
  }
}

// ── Single OTP Box ────────────────────────────────────────────────────────────

class _OtpBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final ValueChanged<String> onChanged;
  final ValueChanged<KeyEvent> onKeyEvent;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.onChanged,
    required this.onKeyEvent,
  });

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = widget.focusNode.hasFocus;

    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: widget.onKeyEvent,
      child: SizedBox(
        width: 46,
        height: 52,
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          onChanged: widget.onChanged,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF5F7FA),
            counterText: '',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: widget.hasError
                  ? const BorderSide(color: Colors.red, width: 1.5)
                  : BorderSide(color: Colors.grey[200]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: widget.hasError
                  ? const BorderSide(color: Colors.red, width: 1.5)
                  : const BorderSide(color: Color(0xFF1A3A6B), width: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}
