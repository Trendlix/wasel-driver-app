import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/register_stepper_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/register_stepper_states.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/screens/register_stepper_screens/step1_personal_info_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/screens/register_stepper_screens/step2_upload_document_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/screens/register_stepper_screens/step3_vehicle_info_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/screens/register_stepper_screens/step4_upload_photos_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/screens/register_stepper_screens/step5_review_cofirm_screen.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/widgets/register_stepper_widget.dart';

class DriverRegistrationScreen extends StatelessWidget {
  final String tempToken;
  const DriverRegistrationScreen({super.key, required this.tempToken});

  static List<Widget> _steps(String tempToken) => [
    Step1PersonalInfoScreen(),
    Step2UploadDocumentsScreen(),
    Step3VehicleInfoScreen(tempToken: tempToken),
    Step4UploadPhotosScreen(),
    Step5ReviewConfirmScreen(tempToken: tempToken),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => RegistrationCubit())],
      child: _DriverRegistrationView(tempToken: tempToken),
    );
  }
}

class _DriverRegistrationView extends StatelessWidget {
  final String tempToken;
  const _DriverRegistrationView({required this.tempToken});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
      builder: (context, state) {
        final cubit = context.read<RegistrationCubit>();
        state.copyWith(tempToken: tempToken);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(context, state, cubit),
          body: SafeArea(
            child: DriverRegistrationScreen._steps(
              tempToken,
            )[state.currentStep],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    RegistrationState state,
    RegistrationCubit cubit,
  ) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Driver Registration',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
          Text(
            'Step ${state.currentStep + 1} of ${state.totalSteps}',
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF9CA3AF),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      leading: state.currentStep > 0
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF1A1A2E),
                size: 18,
              ),
              onPressed: cubit.previousStep,
            )
          : null,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
          child: RegistrationStepper(
            currentStep: state.currentStep,
            totalSteps: state.totalSteps,
            completedSteps: state.completedSteps,
          ),
        ),
      ),
    );
  }
}
