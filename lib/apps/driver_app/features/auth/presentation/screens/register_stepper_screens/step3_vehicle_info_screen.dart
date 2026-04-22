import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/widgets/custom_text_button_widget.dart';
import 'package:wasel_driver/apps/core/widgets/custom_text_form_field.dart';
import 'package:wasel_driver/apps/core/widgets/error_retry_widget.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/driver_auth_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/driver_auth_states.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/register_stepper_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/register_stepper_states.dart';

class Step3VehicleInfoScreen extends StatefulWidget {
  final String tempToken;
  const Step3VehicleInfoScreen({super.key, required this.tempToken});

  @override
  State<Step3VehicleInfoScreen> createState() => _Step3VehicleInfoScreenState();
}

class _Step3VehicleInfoScreenState extends State<Step3VehicleInfoScreen> {
  static const List<String> _weightOptions = [
    'Under 1 ton',
    '1-3 tons',
    '3-7 tons',
    '7-15 tons',
    'Above 15 tons',
  ];

  late TextEditingController _truckModelController;
  late TextEditingController _yearController;
  late TextEditingController _plateNumberController;

  @override
  void initState() {
    super.initState();
    final state = context.read<RegistrationCubit>().state;
    _truckModelController = TextEditingController(text: state.truckModel);
    _yearController = TextEditingController(text: state.year);
    _plateNumberController = TextEditingController(text: state.plateNumber);
  }

  @override
  void dispose() {
    _truckModelController.dispose();
    _yearController.dispose();
    _plateNumberController.dispose();
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
                'Vehicle Information',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),

              const SizedBox(height: 24),

              // ── Truck Type Dropdown ────────────────────────────────
              _buildFieldLabel('Truck Type', isRequired: true),
              const SizedBox(height: 8),
              BlocBuilder<DriverAuthCubit, DriverAuthState>(
                builder: (context, truckState) {
                  if (truckState.getDriverTrucksRequestStatus ==
                      RequestStatus.loading) {
                    return const CircularProgressIndicator();
                  } else if (truckState.getDriverTrucksRequestStatus ==
                      RequestStatus.error) {
                    return Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '${truckState.getDriverTrucksErrorMessage ?? 'Something went wrong'}:  ',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'Retry',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.read<DriverAuthCubit>().getDriverTrucks(
                                  widget.tempToken,
                                );
                              },
                          ),
                        ],
                      ),
                    );
                  } else if (truckState.getDriverTrucksRequestStatus ==
                      RequestStatus.success) {
                    final trucksName = truckState.truckTypes!
                        .map((e) => e.name)
                        .toList();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDropdown(
                          hint: 'Select Truck Type',
                          value: state.truckType.isEmpty
                              ? null
                              : state.truckType,
                          items: trucksName,
                          onChanged: (selectedName) {
                            final truck = truckState.truckTypes!.firstWhere(
                              (e) => e.name == selectedName,
                            );
                            cubit.updateTruckType(
                              truck.name!,
                              truck.id!.toString(),
                            );
                          },
                        ),
                        if (state.showErrors && state.truckType.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 8, left: 4),
                            child: Text(
                              'Please select a truck type',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),

              const SizedBox(height: 16),

              // ── Weight Capacity Dropdown ───────────────────────────
              _buildFieldLabel('Weight Capacity', isRequired: true),
              const SizedBox(height: 8),
              _buildDropdown(
                hint: 'Select Weight Capacity',
                value: state.weightCapacity.isEmpty
                    ? null
                    : state.weightCapacity,
                items: _weightOptions,
                onChanged: (v) => cubit.updateWeightCapacity(v ?? ''),
              ),
              if (state.showErrors && state.weightCapacity.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    'Please select a weight capacity',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 16),

              // ── Truck Model ────────────────────────────────────────
              _buildFieldLabel('Truck Model', isRequired: true),
              const SizedBox(height: 8),
              CustomTextField(
                hint: 'e.g., Toyota Hilux',
                controller: _truckModelController,
                onChanged: cubit.updateTruckModel,
              ),
              if (state.showErrors && state.truckModel.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    'Truck model is required',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 16),

              // ── Year ───────────────────────────────────────────────
              _buildFieldLabel('Year', isRequired: true),
              const SizedBox(height: 8),
              CustomTextField(
                hint: '2024',
                controller: _yearController,
                inputType: TextInputType.number,
                onChanged: cubit.updateYear,
              ),
              if (state.showErrors && state.year.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    'Manufacturing year is required',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 16),

              // ── Plate Number ───────────────────────────────────────
              _buildFieldLabel('Plate Number', isRequired: true),
              const SizedBox(height: 8),
              CustomTextField(
                hint: 'ABC 1234',
                controller: _plateNumberController,
                onChanged: cubit.updatePlateNumber,
              ),
              if (state.showErrors && state.plateNumber.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    'Plate number is required',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 16),

              // ── Agree to Ads ───────────────────────────────────────
              _buildFieldLabel(
                'Do you agree to put Ads on your car?',
                isRequired: true,
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                hint: '',
                value: state.agreeToAds ? 'Yes' : 'No',
                items: const ['Yes', 'No'],
                onChanged: (v) => cubit.toggleAgreeToAds(v == 'Yes'),
              ),

              const SizedBox(height: 12),

              // ── Car Ads Info Note ──────────────────────────────────
              _buildAdsNote(),

              const SizedBox(height: 32),

              // ── Continue Button ────────────────────────────────────
              CustomTextButtomWidget(
                onClick: () {
                  final bool isTruckTypeValid = state.truckType.isNotEmpty;
                  final bool isWeightValid = state.weightCapacity.isNotEmpty;
                  final bool isModelValid = state.truckModel.isNotEmpty;
                  final bool isYearValid = state.year.isNotEmpty;
                  final bool isPlateValid = state.plateNumber.isNotEmpty;

                  if (isTruckTypeValid &&
                      isWeightValid &&
                      isModelValid &&
                      isYearValid &&
                      isPlateValid) {
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

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String?> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
          ),
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF9CA3AF),
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e ?? '')))
              .toList(),
          onChanged: onChanged,
          style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
        ),
      ),
    );
  }

  Widget _buildAdsNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1A3A6B).withOpacity(0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: const Color(0xFF1A3A6B).withOpacity(0.7),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Car Ads:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A3A6B),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'By opting in, you allow approved brands to place temporary ads on your vehicle. This helps you earn additional income with no impact on your vehicle\'s condition.',
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

Widget _buildDropdown({
  required String hint,
  required String? value,
  required List<String?> items,
  required ValueChanged<String?> onChanged,
}) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFFF5F7FA),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 14),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        hint: Text(
          hint,
          style: const TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
        ),
        isExpanded: true,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Color(0xFF9CA3AF),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e ?? '')))
            .toList(),
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
      ),
    ),
  );
}

Widget _buildAdsNote() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFEEF2FB),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFF1A3A6B).withOpacity(0.12)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: 16,
          color: const Color(0xFF1A3A6B).withOpacity(0.7),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Car Ads:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A3A6B),
                ),
              ),
              SizedBox(height: 3),
              Text(
                'By opting in, you allow approved brands to place temporary ads on your vehicle. This helps you earn additional income with no impact on your vehicle\'s condition.',
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
