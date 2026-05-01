import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/widgets/custom_text_button_widget.dart';
import 'package:wasel_driver/apps/core/widgets/custom_text_form_field.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/register_stepper_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/register_stepper_states.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/widgets/file_picker_widget.dart';

class Step2UploadDocumentsScreen extends StatefulWidget {
  const Step2UploadDocumentsScreen({super.key});

  @override
  State<Step2UploadDocumentsScreen> createState() =>
      _Step2UploadDocumentsScreenState();
}

class _Step2UploadDocumentsScreenState
    extends State<Step2UploadDocumentsScreen> {
  late TextEditingController _nationalIdExpiryController;
  late TextEditingController _licenseExpiryController;

  @override
  void initState() {
    super.initState();
    final state = context.read<RegistrationCubit>().state;
    _nationalIdExpiryController = TextEditingController(
      text: state.nationalIdExpiry,
    );
    _licenseExpiryController = TextEditingController(text: state.licenseExpiry);
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
    Function(String) onChanged,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Color(0xFF1A1A2E),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final uiFormattedDate =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      controller.text = uiFormattedDate;
      onChanged(uiFormattedDate);
    }
  }

  @override
  void dispose() {
    _nationalIdExpiryController.dispose();
    _licenseExpiryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
      builder: (context, state) {
        final cubit = context.read<RegistrationCubit>();

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
              if (state.showErrors &&
                  (state.nationalIdFront == null ||
                      state.nationalIdFront!.isEmpty))
                const Padding(
                  padding: EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    'National ID Front is required',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 16),

              // ── National ID - Back ─────────────────────────────────
              FilePickerField(
                label: 'National ID - Back',
                selectedFileName: state.nationalIdBack,
                onFilePicked: cubit.updateNationalIdBack,
              ),
              if (state.showErrors &&
                  (state.nationalIdBack == null ||
                      state.nationalIdBack!.isEmpty))
                const Padding(
                  padding: EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    'National ID Back is required',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 16),

              // ── National ID Expiry Date ────────────────────────────
              _buildFieldLabel('National ID Expiry Date', isRequired: true),
              const SizedBox(height: 8),
              CustomTextField(
                hint: 'YYYY-MM-DD',
                controller: _nationalIdExpiryController,
                readOnly: true,
                onTap: () => _selectDate(
                  context,
                  _nationalIdExpiryController,
                  cubit.updateNationalIdExpiry,
                ),
              ),
              if (state.showErrors &&
                  (state.nationalIdExpiry == null ||
                      state.nationalIdExpiry!.isEmpty))
                const Padding(
                  padding: EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    'Expiry date is required',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 16),

              // ── Driver's License - Front ───────────────────────────
              FilePickerField(
                label: "Driver's License - Front",
                selectedFileName: state.driverLicenseFront,
                onFilePicked: cubit.updateDriverLicenseFront,
              ),
              if (state.showErrors &&
                  (state.driverLicenseFront == null ||
                      state.driverLicenseFront!.isEmpty))
                const Padding(
                  padding: EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    'Driver License Front is required',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 16),

              // ── Driver's License - Back ────────────────────────────
              FilePickerField(
                label: "Driver's License - Back",
                selectedFileName: state.driverLicenseBack,
                onFilePicked: cubit.updateDriverLicenseBack,
              ),
              if (state.showErrors &&
                  (state.driverLicenseBack == null ||
                      state.driverLicenseBack!.isEmpty))
                const Padding(
                  padding: EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    'Driver License Back is required',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 16),

              // ── License Expiry Date ────────────────────────────────
              _buildFieldLabel('License Expiry Date', isRequired: true),
              const SizedBox(height: 8),
              CustomTextField(
                hint: 'YYYY-MM-DD',
                controller: _licenseExpiryController,
                readOnly: true,
                onTap: () => _selectDate(
                  context,
                  _licenseExpiryController,
                  cubit.updateLicenseExpiry,
                ),
              ),
              if (state.showErrors &&
                  (state.licenseExpiry == null || state.licenseExpiry!.isEmpty))
                const Padding(
                  padding: EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    'License expiry date is required',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
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
                onClick: () {
                  final bool isNationalIdFrontValid =
                      state.nationalIdFront != null &&
                      state.nationalIdFront!.isNotEmpty;
                  final bool isNationalIdBackValid =
                      state.nationalIdBack != null &&
                      state.nationalIdBack!.isNotEmpty;
                  final bool isNationalIdExpiryValid =
                      state.nationalIdExpiry != null &&
                      state.nationalIdExpiry!.isNotEmpty;
                  final bool isDriverLicenseFrontValid =
                      state.driverLicenseFront != null &&
                      state.driverLicenseFront!.isNotEmpty;
                  final bool isDriverLicenseBackValid =
                      state.driverLicenseBack != null &&
                      state.driverLicenseBack!.isNotEmpty;
                  final bool isLicenseExpiryValid =
                      state.licenseExpiry != null &&
                      state.licenseExpiry!.isNotEmpty;

                  if (isNationalIdFrontValid &&
                      isNationalIdBackValid &&
                      isNationalIdExpiryValid &&
                      isDriverLicenseFrontValid &&
                      isDriverLicenseBackValid &&
                      isLicenseExpiryValid) {
                    cubit.nextStep();
                  } else {
                    cubit.setShowErrors(true);
                  }
                },
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
