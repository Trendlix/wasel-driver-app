import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_images.dart';
import 'package:wasel_driver/apps/core/utils/text_fields_validations.dart';
import 'package:wasel_driver/apps/core/widgets/custom_dialog_widget.dart';
import 'package:wasel_driver/apps/core/widgets/custom_text_button_widget.dart';
import 'package:wasel_driver/apps/core/widgets/custom_text_form_field.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/driver_auth_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/driver_auth_states.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: BlocListener<DriverAuthCubit, DriverAuthState>(
        listener: (context, state) {
          if (state.checkPhoneIsRegisteredRequestStatus.isSuccess) {
            Navigator.of(context).pushNamed(
              AppRouteNames.verifyLoginOtpScreen,
              arguments: state.phone!,
            );
          } else if (state.checkPhoneIsRegisteredRequestStatus.isError) {
            showError(
              context,
              state.checkPhoneIsRegisteredErrorMessage ??
                  'Something went wrong',
            );
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),

                      // ── Logo ───────────────────────────────────────────────
                      Image.asset(AppImages.waselLogo2, height: 40),

                      const SizedBox(height: 32),

                      // ── Title ──────────────────────────────────────────────
                      const Text(
                        'Enter Your Phone\nNumber',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                          height: 1.2,
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ── Subtitle ───────────────────────────────────────────
                      const Text(
                        "We'll send you a verification code via SMS\nor WhatsApp",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Phone Number Label ─────────────────────────────────
                      const Text(
                        'Phone Number',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ── Phone Input using CustomTextField ──────────────────
                      CustomTextField(
                        hint: '123 456 7890',
                        controller: _phoneController,
                        inputType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                        prefix: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                '🇪🇬',
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                '+20',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A2E),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: 1,
                                height: 22,
                                color: Colors.grey[300],
                              ),
                            ],
                          ),
                        ),
                        validator: TextFieldsValidations.validatePhoneNumber,
                      ),

                      const SizedBox(height: 16),

                      // ── Privacy Note ───────────────────────────────────────
                      _buildPrivacyNote(),

                      const Spacer(),

                      // ── Send Code Button using CustomTextButtomWidget ──────
                      BlocBuilder<DriverAuthCubit, DriverAuthState>(
                        builder: (context, state) {
                          return CustomTextButtomWidget(
                            onClick: () {
                              if (_formKey.currentState!.validate()) {
                                context
                                    .read<DriverAuthCubit>()
                                    .checkPhoneIsRegistered(
                                      TextFieldsValidations.isPhoneNumberStartWithZero(
                                            _phoneController.text,
                                          )
                                          ? '+2${_phoneController.text}'
                                          : '+20${_phoneController.text}',
                                      AuthMode.verify,
                                    );
                              }
                            },
                            btnTitle: 'Send Code  >',
                            btnTitleSize: 16,
                            btnTitleColor: Colors.white,
                            buttonColor: AppColors.primary,
                            borderColor: AppColors.primary,
                            borderRaduisSize: 14,
                            borderWidth: 0,
                            isLoading: state
                                .checkPhoneIsRegisteredRequestStatus
                                .isLoading,
                          );
                        },
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
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

  Widget _buildPrivacyNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FB),
        borderRadius: BorderRadius.circular(12),
        //border: Border.all(color: const Color(0xFF1A3A6B).withOpacity(0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: const Color(0xFF1A3A6B).withValues(alpha: 0.7),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy Note:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A3A6B),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Your phone number will only be used for account verification and important updates.',
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
}
