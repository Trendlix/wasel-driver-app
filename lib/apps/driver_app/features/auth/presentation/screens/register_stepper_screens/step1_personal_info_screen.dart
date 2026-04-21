import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/widgets/custom_text_button_widget.dart';
import 'package:wasel_driver/apps/core/widgets/custom_text_form_field.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/register_stepper_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/register_stepper_states.dart';

class Step1PersonalInfoScreen extends StatefulWidget {
  const Step1PersonalInfoScreen({super.key});

  @override
  State<Step1PersonalInfoScreen> createState() =>
      _Step1PersonalInfoScreenState();
}

class _Step1PersonalInfoScreenState extends State<Step1PersonalInfoScreen> {
  late TextEditingController _fullNameController;

  @override
  void initState() {
    super.initState();
    // Initialize controller with the current state value
    _fullNameController = TextEditingController(
      text: context.read<RegistrationCubit>().state.fullName,
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
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
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 180,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // ── Section Title ──────────────────────────────────────
                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Full Name ──────────────────────────────────────────
                  _buildFieldLabel('Full Name', isRequired: true),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hint: 'Enter your full name',
                    controller: _fullNameController,
                    onChanged: cubit.updateFullName,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Full name is required';
                      }
                      return null;
                    },
                  ),
                  // Manual Red Validation Text for Driver Type
                  if (state.showErrors && state.fullName.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 8, left: 4),
                      child: Text(
                        'Please enter your full name',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 20),

                  // ── Driver Type ────────────────────────────────────────
                  _buildFieldLabel('Driver Type', isRequired: true),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _DriverTypeCard(
                        icon: Icons.person_outline,
                        label: 'Individual Driver',
                        isSelected: state.driverType == 'individual',
                        onTap: () => cubit.updateDriverType('individual'),
                      ),
                      const SizedBox(width: 12),
                      _DriverTypeCard(
                        icon: Icons.business_outlined,
                        label: 'Company Driver',
                        isSelected: state.driverType == 'company',
                        onTap: () => cubit.updateDriverType('company'),
                      ),
                    ],
                  ),
                  // Manual Red Validation Text for Driver Type
                  if (state.showErrors && state.driverType == null)
                    const Padding(
                      padding: EdgeInsets.only(top: 8, left: 4),
                      child: Text(
                        'Please select a driver type',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),

                  const Spacer(),
                  const SizedBox(height: 24),

                  // ── Continue Button ────────────────────────────────────
                  CustomTextButtomWidget(
                    onClick: () {
                      // Trigger Form Validation (TextFields)
                      final isNameValid = state.fullName.isNotEmpty;
                      // Check Custom fields (Driver Type)
                      final isTypeValid = state.driverType != null;

                      if (isNameValid && isTypeValid) {
                        cubit.nextStep();
                      } else {
                        // This triggers the manual error text under cards
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
            ),
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

// ── Driver Type Card ──────────────────────────────────────────────────────────

class _DriverTypeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DriverTypeCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFEEF2FB)
                : const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF1A3A6B)
                  : const Color(0xFFE5E7EB),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 28,
                color: isSelected
                    ? const Color(0xFF1A3A6B)
                    : const Color(0xFF9CA3AF),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFF1A3A6B)
                      : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
