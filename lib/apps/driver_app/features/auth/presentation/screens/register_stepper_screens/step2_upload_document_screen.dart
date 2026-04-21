import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/widgets/custom_text_button_widget.dart';
import 'package:wasel_driver/apps/core/widgets/custom_text_form_field.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/register_stepper_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/register_stepper_states.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/widgets/file_picker_widget.dart';

class Step2UploadDocumentsScreen extends StatelessWidget {
  const Step2UploadDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegistrationCubit>();

    return BlocBuilder<RegistrationCubit, RegistrationState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // ── Section Title ──────────────────────────────────────
              const Text(
                'Upload Documents',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),

              const SizedBox(height: 24),

              // ── National ID - Front ────────────────────────────────
              FilePickerField(
                label: 'National ID - Front',
                selectedFileName: state.nationalIdFront,
                onFilePicked: cubit.updateNationalIdFront,
              ),

              const SizedBox(height: 16),

              // ── National ID - Back ─────────────────────────────────
              FilePickerField(
                label: 'National ID - Back',
                selectedFileName: state.nationalIdBack,
                onFilePicked: cubit.updateNationalIdBack,
              ),

              const SizedBox(height: 16),

              // ── National ID Expiry Date ────────────────────────────
              _buildFieldLabel('National ID Expiry Date', isRequired: true),
              const SizedBox(height: 8),
              CustomTextField(
                hint: '',
                inputType: TextInputType.datetime,
                onChanged: cubit.updateNationalIdExpiry,
              ),

              const SizedBox(height: 16),

              // ── Driver's License - Front ───────────────────────────
              FilePickerField(
                label: "Driver's License - Front",
                selectedFileName: state.driverLicenseFront,
                onFilePicked: cubit.updateDriverLicenseFront,
              ),

              const SizedBox(height: 16),

              // ── Driver's License - Back ────────────────────────────
              FilePickerField(
                label: "Driver's License - Back",
                selectedFileName: state.driverLicenseBack,
                onFilePicked: cubit.updateDriverLicenseBack,
              ),

              const SizedBox(height: 16),

              // ── License Expiry Date ────────────────────────────────
              _buildFieldLabel('License Expiry Date', isRequired: true),
              const SizedBox(height: 8),
              CustomTextField(
                hint: '',
                inputType: TextInputType.datetime,
                onChanged: cubit.updateLicenseExpiry,
              ),

              const SizedBox(height: 16),

              // ── Vehicle Ownership Document (Optional) ──────────────
              FilePickerField(
                label: 'Vehicle Ownership Document',
                isOptional: true,
                selectedFileName: state.vehicleOwnershipDoc,
                onFilePicked: cubit.updateVehicleOwnershipDoc,
              ),

              const SizedBox(height: 16),

              // ── Criminal Record (Optional) ─────────────────────────
              FilePickerField(
                label: 'Criminal Record',
                isOptional: true,
                selectedFileName: state.criminalRecord,
                onFilePicked: cubit.updateCriminalRecord,
              ),

              const SizedBox(height: 32),

              // ── Continue Button ────────────────────────────────────
              CustomTextButtomWidget(
                onClick: cubit.nextStep,
                btnTitle: 'Continue  >',
                btnTitleSize: 16,
                btnTitleColor: Colors.white,
                buttonColor: AppColors.primary,
                borderColor: AppColors.primary,
                borderRaduisSize: 14,
                borderWidth: 0,
              ),

              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFieldLabel(String label, {bool isRequired = false}) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A2E),
        ),
        children: [
          if (isRequired)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }
}
