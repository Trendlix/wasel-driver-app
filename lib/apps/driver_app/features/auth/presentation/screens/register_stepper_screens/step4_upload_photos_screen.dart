import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/widgets/custom_text_button_widget.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/register_stepper_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/register_stepper_states.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/widgets/file_picker_widget.dart';

class Step4UploadPhotosScreen extends StatelessWidget {
  const Step4UploadPhotosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegistrationCubit>();

    return BlocBuilder<RegistrationCubit, RegistrationState>(
      builder: (context, state) {
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

                  // ── Section Title ────────────────────────────────────
                  const Text(
                    'Upload Photos',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Profile Photo ────────────────────────────────────
                  FilePickerField(
                    label: 'Profile Photo',
                    selectedFileName: state.profilePhoto,
                    onFilePicked: cubit.updateProfilePhoto,
                  ),

                  const SizedBox(height: 16),

                  // ── Truck Photo ──────────────────────────────────────
                  FilePickerField(
                    label: 'Truck Photo',
                    selectedFileName: state.truckPhoto,
                    onFilePicked: cubit.updateTruckPhoto,
                  ),

                  const SizedBox(height: 16),

                  // ── Photo Tips Note ──────────────────────────────────
                  _buildPhotoTipsNote(),

                  const Spacer(),

                  const SizedBox(height: 24),

                  // ── Continue Button ──────────────────────────────────
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
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhotoTipsNote() {
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
            Icons.tips_and_updates_outlined,
            size: 16,
            color: const Color(0xFF1A3A6B).withOpacity(0.7),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Photo Tips:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A3A6B),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Ensure photos are clear, well-lit, and show the full subject. Profile photo should be a recent headshot.',
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
