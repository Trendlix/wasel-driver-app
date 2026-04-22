import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/widgets/custom_dialog_widget.dart';
import 'package:wasel_driver/apps/core/widgets/custom_text_button_widget.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/data/models/register_driver_model.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/driver_auth_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/driver_auth_states.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/register_stepper_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/register_stepper_states.dart';

class Step5ReviewConfirmScreen extends StatefulWidget {
  final String tempToken;
  const Step5ReviewConfirmScreen({super.key, required this.tempToken});

  @override
  State<Step5ReviewConfirmScreen> createState() =>
      _Step5ReviewConfirmScreenState();
}

class _Step5ReviewConfirmScreenState extends State<Step5ReviewConfirmScreen> {
  bool _isTermsAgreed = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DriverAuthCubit, DriverAuthState>(
      listener: (context, state) {
        if (state.registerDriverRequestStatus == RequestStatus.success) {
          final reference = state.reference;
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouteNames.requestSubmitScreen,
            arguments: reference,
            (route) => false,
          );
        } else if (state.registerDriverRequestStatus == RequestStatus.error) {
          showError(
            context,
            state.registerDriverErrorMessage ?? 'Something went wrong',
          );
        }
      },
      child: BlocBuilder<RegistrationCubit, RegistrationState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // ── Section Title ──────────────────────────────────────
                const Text(
                  'Review & Confirm',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Summary Card ───────────────────────────────────────
                _buildSummaryCard(state),

                const SizedBox(height: 16),

                // ── Terms Checkbox ─────────────────────────────────────
                _TermsCheckbox(
                  value: _isTermsAgreed,
                  onChanged: (v) => setState(() => _isTermsAgreed = v),
                ),

                const SizedBox(height: 16),

                // ── Pending Verification Note ──────────────────────────
                _buildPendingNote(),

                const SizedBox(height: 32),

                // ── Submit Button ──────────────────────────────────────
                BlocBuilder<DriverAuthCubit, DriverAuthState>(
                  builder: (context, driverState) {
                    return CustomTextButtomWidget(
                      onClick: () {
                        if (!_isTermsAgreed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please agree to the Terms and Conditions',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final model = RegisterDriverModel(
                          fullName: state.fullName,
                          nationalIdExpiry:
                              DateTime.tryParse(state.nationalIdExpiry ?? '') ??
                              DateTime.now(),
                          licenseExpiry:
                              DateTime.tryParse(state.licenseExpiry ?? '') ??
                              DateTime.now(),
                          truckTypeId: int.parse(state.truckTypeId),
                          truckModel: state.truckModel,
                          year: int.tryParse(state.year) ?? 0,
                          licensePlate: state.plateNumber,
                          acceptsAds: state.agreeToAds,
                          nationalIdFront: File(state.nationalIdFront ?? ''),
                          hasCompany: state.driverType != 'individual',
                          nationalIdBack: File(state.nationalIdBack ?? ''),
                          licenseFront: File(state.driverLicenseFront ?? ''),
                          licenseBack: File(state.driverLicenseBack ?? ''),
                          profileImage: File(state.profilePhoto ?? ''),
                          truckImage: File(state.truckPhoto ?? ''),
                        );
                        context.read<DriverAuthCubit>().registerDriver(
                          model,
                          widget.tempToken,
                        );
                      },
                      btnTitle: 'Submit Registration  >',
                      btnTitleSize: 16,
                      btnTitleColor: Colors.white,
                      buttonColor: _isTermsAgreed
                          ? AppColors.primary
                          : const Color(0xFFE5E7EB),
                      borderColor: _isTermsAgreed
                          ? AppColors.primary
                          : const Color(0xFFE5E7EB),
                      borderRaduisSize: 14,
                      borderWidth: 0,
                      isLoading:
                          driverState.registerDriverRequestStatus ==
                          RequestStatus.loading,
                    );
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(RegistrationState state) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
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
          _buildRow('Full Name', state.fullName.isEmpty ? '—' : state.fullName),
          _buildDivider(),
          _buildRow(
            'Driver Type',
            state.driverType == 'individual'
                ? 'Individual Driver'
                : 'Company Driver',
          ),
          _buildDivider(),
          _buildRow(
            'Truck Type',
            state.truckType.isEmpty ? '—' : state.truckType,
          ),
          _buildDivider(),
          _buildRow(
            'Weight Capacity',
            state.weightCapacity.isEmpty ? '—' : state.weightCapacity,
          ),
          _buildDivider(),
          _buildRow(
            'Truck Model',
            state.truckModel.isEmpty ? '—' : state.truckModel,
          ),
          _buildDivider(),
          _buildRow('Year', state.year.isEmpty ? '—' : state.year),
          _buildDivider(),
          _buildRow(
            'Plate Number',
            state.plateNumber.isEmpty ? '—' : state.plateNumber,
          ),
          _buildDivider(),
          _buildRow(
            'Documents Uploaded',
            _countDocuments(state),
            valueColor: const Color(0xFF1A3A6B),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor ?? const Color(0xFF1A1A2E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: Color(0xFFF3F4F6));
  }

  String _countDocuments(RegistrationState state) {
    int count = 0;
    if (state.nationalIdFront != null) count++;
    if (state.nationalIdBack != null) count++;
    if (state.driverLicenseFront != null) count++;
    if (state.driverLicenseBack != null) count++;
    return '$count required documents';
  }

  Widget _buildPendingNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.access_time_rounded,
            size: 16,
            color: Color(0xFFD97706),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pending Verification:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFD97706),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  "Your profile will be reviewed by our admin team. You'll receive a notification once approved. Vehicle info can be edited after approval.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF92400E),
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

// ── Terms Checkbox ────────────────────────────────────────────────────────────

class _TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _TermsCheckbox({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: value,
          onChanged: (v) => onChanged(v ?? false),
          activeColor: const Color(0xFF1A3A6B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        const Expanded(
          child: Text.rich(
            TextSpan(
              text: 'I agree to the ',
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              children: [
                TextSpan(
                  text: 'Terms and Conditions',
                  style: TextStyle(
                    color: Color(0xFF1A3A6B),
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: Color(0xFF1A3A6B),
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
