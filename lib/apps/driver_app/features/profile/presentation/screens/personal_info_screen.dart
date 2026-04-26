import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/widgets/custom_snackbar_widget.dart';
import 'package:wasel_driver/apps/core/widgets/custom_text_form_field.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/profile_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/presentation/manager/profile_states.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  bool _isEditing = false;
  RequestStatus? _lastUpdateStatus;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _licenseNoController = TextEditingController();
  final TextEditingController _licenseExpController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _nationalIdExpController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _licenseNoController.dispose();
    _licenseExpController.dispose();
    _nationalIdController.dispose();
    _nationalIdExpController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getDriverBasicInfo();
    context.read<ProfileCubit>().getDriverLegalInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.instance<ProfileCubit>(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Column(
          children: [
            // ── Blue Header ──────────────────────────────────────────
            _buildHeader(context),

            // ── Scrollable Body ──────────────────────────────────────
            Expanded(
              child: BlocConsumer<ProfileCubit, ProfileStates>(
                listener: (context, state) {
                  if (state.updateDriverBasicInfoStatus != _lastUpdateStatus) {
                    _lastUpdateStatus = state.updateDriverBasicInfoStatus;
                    if (state.updateDriverBasicInfoStatus ==
                        RequestStatus.loading) {
                      showLoadingSnackBar(context, 'Saving...');
                    } else if (state.updateDriverBasicInfoStatus ==
                        RequestStatus.success) {
                      hideLoadingSnackBar(context);
                      showSuccess(context, 'Information updated successfully');
                      setState(() {
                        _isEditing = false;
                      });
                      context.read<ProfileCubit>().resetUpdateStatus();
                    } else if (state.updateDriverBasicInfoStatus ==
                        RequestStatus.error) {
                      hideLoadingSnackBar(context);
                      showSnackError(
                        context,
                        state.updateDriverBasicInfoErrorMessage ??
                            'Failed to update information',
                      );
                      context.read<ProfileCubit>().resetUpdateStatus();
                    }
                  }

                  if (state.getDriverBasicInfoStatus == RequestStatus.success &&
                      state.driverBasicInfoModel != null) {
                    final basicInfo = state.driverBasicInfoModel!;
                    _nameController.text = basicInfo.name!;
                    _phoneController.text = basicInfo.phone!;
                    _emailController.text = basicInfo.email!;
                  }

                  if (state.getDriverLegalInfoStatus == RequestStatus.success &&
                      state.driverLegalInfoModel != null) {
                    final legalInfo = state.driverLegalInfoModel!;
                    _licenseNoController.text = legalInfo.licenseNumber ?? '';
                    _licenseExpController.text = _formatDate(
                      legalInfo.licenseExpiry,
                    );
                    _nationalIdController.text =
                        legalInfo.nationalIdNumber ?? '';
                    _nationalIdExpController.text = _formatDate(
                      legalInfo.nationalIdExpiry,
                    );
                  }
                },
                builder: (context, state) {
                  if (state.getDriverBasicInfoStatus == RequestStatus.loading ||
                      state.getDriverLegalInfoStatus == RequestStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // ── Basic Information ──────────────────────────
                        _buildBasicInfoSection(state),

                        const SizedBox(height: 20),

                        // ── Legal Documents ────────────────────────────
                        _buildLegalDocumentsSection(),

                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
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
                'Personal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(
                'View and update your details',
                style: TextStyle(fontSize: 11, color: Colors.white60),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Basic Information Section ─────────────────────────────────────────────────

  Widget _buildBasicInfoSection(ProfileStates state) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section Header ───────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Basic Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_isEditing) {
                    final currentInfo = state.driverBasicInfoModel;
                    if (currentInfo != null) {
                      final updatedInfo = DriverBasicInfoEntity(
                        id: currentInfo.id,
                        name: _nameController.text,
                        email: _emailController.text,
                        phone: currentInfo.phone,
                        isOnline: true, // Phone is read-only
                      );
                      context.read<ProfileCubit>().updateDriverBasicInfo(
                        updatedInfo,
                      );
                    }
                  } else {
                    setState(() => _isEditing = true);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _isEditing ? 'Save' : 'Edit',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Full Name ────────────────────────────────────────────
          _buildFieldLabel('Full Name'),
          const SizedBox(height: 8),
          CustomTextField(
            controller: _nameController,
            hint: 'Mohamed Ahmed',
            readOnly: !_isEditing,
            prefix: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                Icons.person_outline_rounded,
                size: 18,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Phone Number ─────────────────────────────────────────
          _buildFieldLabel('Phone Number'),
          const SizedBox(height: 8),
          CustomTextField(
            controller: _phoneController,
            hint: '+20 123 456 7890',
            readOnly: true,
            prefix: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                Icons.phone_outlined,
                size: 18,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Phone number cannot be changed',
            style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
          ),

          const SizedBox(height: 16),

          // ── Email Address ────────────────────────────────────────
          _buildFieldLabel('Email Address (Optional)'),
          const SizedBox(height: 8),
          CustomTextField(
            controller: _emailController,
            hint: 'mohamed.ahmed@gmail.com',
            readOnly: !_isEditing,
            inputType: TextInputType.emailAddress,
            prefix: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                Icons.email_outlined,
                size: 18,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Used for account recovery',
            style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }

  // ── Legal Documents Section ───────────────────────────────────────────────────

  Widget _buildLegalDocumentsSection() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section Header ───────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Legal Documents',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              // Admin Approval badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFE8A020).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 11,
                      color: Color(0xFFE8A020),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Admin Approval\nRequired',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFE8A020),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Info Note ────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primary.withOpacity(0.15)),
            ),
            child: const Text(
              'These documents can only be edited after admin approval. Contact support if you need to update them.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.primary,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ── Driver's License Number ──────────────────────────────
          _buildFieldLabel("Driver's License Number"),
          const SizedBox(height: 8),
          CustomTextField(
            controller: _licenseNoController,
            hint: '',
            readOnly: true,
            prefix: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                Icons.description_outlined,
                size: 18,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── License Expiry Date ──────────────────────────────────
          _buildFieldLabel('License Expiry Date'),
          const SizedBox(height: 8),
          CustomTextField(
            controller: _licenseExpController,
            hint: '',
            readOnly: true,
            inputType: TextInputType.datetime,
            prefix: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── National ID Number ───────────────────────────────────
          _buildFieldLabel('National ID Number'),
          const SizedBox(height: 8),
          CustomTextField(
            controller: _nationalIdController,
            hint: '',
            readOnly: true,
            inputType: TextInputType.number,
            prefix: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'T',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── ID Expiry Date ───────────────────────────────────────
          _buildFieldLabel('ID Expiry Date'),
          const SizedBox(height: 8),
          CustomTextField(
            controller: _nationalIdExpController,
            hint: '',
            readOnly: true,
            inputType: TextInputType.datetime,
            prefix: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ── Request Document Update Button ───────────────────────
          InkWell(
            onTap: () {
              Navigator.of(
                context,
              ).pushReplacementNamed(AppRouteNames.vehicleDocumentsScreen);
            },
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Request Document Update',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Field Label ──────────────────────────────────────────────────────────────

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A2E),
      ),
    );
  }
}
