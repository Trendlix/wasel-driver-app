import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

// Core imports
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/widgets/custom_dialog_widget.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/ticket_entity.dart';

// Feature imports
import 'package:wasel_driver/apps/driver_app/features/settings/presentation/manager/settings_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/presentation/manager/settings_states.dart';

class SubmitTicketScreen extends StatefulWidget {
  const SubmitTicketScreen({super.key});

  @override
  State<SubmitTicketScreen> createState() => _SubmitTicketScreenState();
}

class _SubmitTicketScreenState extends State<SubmitTicketScreen> {
  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? selectedPriority;
  // Use dynamic to support both int and String IDs from your entity
  dynamic selectedCategoryId;

  String? categoryError;
  String? priorityError;
  String? fileErrorMessage;

  List<File> pickedFiles = [];
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    // Trigger the API call safely after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SettingsCubit>().getTicketCategories();
      }
    });
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        pickedFiles.addAll(result.paths.map((path) => File(path!)).toList());
        isUploading = true;
        fileErrorMessage = null;
      });

      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        isUploading = false;
      });
    }
  }

  void _validateAndSubmit() {
    setState(() {
      categoryError = (selectedCategoryId == null)
          ? "Please select a category"
          : null;
      priorityError = (selectedPriority == null)
          ? "Please select a priority"
          : null;
      fileErrorMessage = (pickedFiles.isEmpty)
          ? "Please attach at least one file"
          : null;
    });

    if (formKey.currentState!.validate() &&
        selectedCategoryId != null &&
        selectedPriority != null &&
        pickedFiles.isNotEmpty) {
      // Navigate or Call Cubit Submit method here
      final ticket = TicketEntity(
        subject: subjectController.text,
        description: descriptionController.text,
        priority: selectedPriority!.toLowerCase(),
        category: selectedCategoryId.toString(),
        files: pickedFiles,
      );
      context.read<SettingsCubit>().submitTicket(ticket);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: const BackButton(color: Colors.white),
        toolbarHeight: 80,
        title: const Text(
          'Submit Support Ticket',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: BlocListener<SettingsCubit, SettingsStates>(
        listener: (context, state) {
          if (state.submitTicketRequestStatus == RequestStatus.success) {
            Navigator.of(context).pushNamed(
              AppRouteNames.ticketSuccessScreen,
              arguments: state.ticketNumber,
            );
          } else if (state.submitTicketRequestStatus == RequestStatus.error) {
            showError(
              context,
              state.submitTicketErrorMessage ?? 'something went wrong',
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _buildInfoBox(),
                const SizedBox(height: 16),
                FormSectionCard(
                  label: 'Subject *',
                  child: CustomTextField(
                    controller: subjectController,
                    hint: 'Brief description of your issue',
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Please enter a subject'
                        : null,
                  ),
                ),
                FormSectionCard(
                  label: 'Category *',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCategoryDropdown(),
                      if (categoryError != null)
                        _buildErrorMessage(categoryError!),
                    ],
                  ),
                ),
                FormSectionCard(
                  label: 'Priority *',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPrioritySelector(),
                      if (priorityError != null)
                        _buildErrorMessage(priorityError!),
                    ],
                  ),
                ),
                FormSectionCard(
                  label: 'Description *',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: descriptionController,
                        hint: 'Please provide detailed information...',
                        maxLines: 5,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Please enter a description'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      if (pickedFiles.isNotEmpty) _buildFileList(),
                      _buildFilePickerButton(),
                      if (fileErrorMessage != null)
                        _buildErrorMessage(fileErrorMessage!),
                    ],
                  ),
                ),
                _buildYellowFooter(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _buildSubmitButton(),
    );
  }

  Widget _buildCategoryDropdown() {
    return BlocBuilder<SettingsCubit, SettingsStates>(
      buildWhen: (previous, current) =>
          previous.getTicketCategoriesRequestStatus !=
              current.getTicketCategoriesRequestStatus ||
          previous.ticketCategories != current.ticketCategories,
      builder: (context, state) {
        if (state.getTicketCategoriesRequestStatus == RequestStatus.loading) {
          return const Center(child: LinearProgressIndicator());
        }

        if (state.getTicketCategoriesRequestStatus == RequestStatus.error) {
          return InkWell(
            onTap: () => context.read<SettingsCubit>().getTicketCategories(),
            child: Text(
              "${state.getTicketCategoriesErrorMessage} (Tap to retry)",
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          );
        }

        final categories = state.ticketCategories ?? [];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<dynamic>(
              value: selectedCategoryId,
              hint: const Text(
                "Select Category",
                style: TextStyle(fontSize: 14),
              ),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category.id,
                  child: Text(category.name ?? ""),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedCategoryId = val;
                  categoryError = null;
                });
              },
            ),
          ),
        );
      },
    );
  }

  // --- Helper Widgets ---

  Widget _buildFileList() {
    return SizedBox(
      height: 70,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: pickedFiles
              .map((file) => _buildHorizontalFileItem(file))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildFilePickerButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: _pickFiles,
          icon: const Icon(Icons.attach_file, size: 18),
          label: const Text('Attach File'),
          style: TextButton.styleFrom(foregroundColor: const Color(0xFF1A46A6)),
        ),
        Text(
          '${pickedFiles.length}/5',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildHorizontalFileItem(File file) {
    String fileName = file.path.split('/').last;
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 8, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  fileName,
                  style: const TextStyle(
                    color: Color(0xFF1A46A6),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => pickedFiles.remove(file)),
                child: const Icon(Icons.close, size: 18, color: Colors.grey),
              ),
            ],
          ),
          if (isUploading)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: LinearProgressIndicator(
                minHeight: 2,
                color: AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Row(
      children: ['Low', 'Medium', 'High']
          .map(
            (p) => Expanded(
              child: GestureDetector(
                onTap: () => setState(() {
                  selectedPriority = p;
                  priorityError = null;
                }),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: selectedPriority == p
                        ? AppColors.primary
                        : const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                    border: selectedPriority == p
                        ? Border.all(color: AppColors.primary)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      p,
                      style: TextStyle(
                        color: selectedPriority == p
                            ? Colors.white
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD2E3FC)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppColors.primary),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Support Response Time',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'We typically respond to tickets within 24 hours. For urgent issues, please call our hotline.',
                  style: TextStyle(color: AppColors.primary, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYellowFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFEFC4)),
      ),
      child: const Text(
        "Make sure your email in profile settings is up to date",
        style: TextStyle(color: Color(0xFFB48A00), fontSize: 13),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: BlocBuilder<SettingsCubit, SettingsStates>(
          builder: (context, state) {
            if (state.submitTicketRequestStatus == RequestStatus.loading) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            return ElevatedButton.icon(
              onPressed: _validateAndSubmit,
              icon: const Icon(Icons.send_outlined),
              label: const Text('Submit Ticket'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ... FormSectionCard and CustomTextField classes remain the same

class FormSectionCard extends StatelessWidget {
  final String label;
  final Widget child;
  const FormSectionCard({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hint;
  final int maxLines;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  const CustomTextField({
    super.key,
    required this.hint,
    this.maxLines = 1,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: const Color.fromARGB(255, 243, 244, 245),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
