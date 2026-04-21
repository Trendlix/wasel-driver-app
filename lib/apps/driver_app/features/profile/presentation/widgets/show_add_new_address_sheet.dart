import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/widgets/custom_dialog_widget.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/domain/entity/address_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/presentation/manager/profile_states.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/presentation/screens/map_picker_screen.dart';

void showAddNewAddressSheet(
  BuildContext context, {
  AddressEntity? addressToEdit,
}) {
  final bool isEditMode = addressToEdit != null;

  final labelController = TextEditingController(
    text: addressToEdit?.label ?? "",
  );
  String selectedType = addressToEdit?.type ?? "home";
  String locationText = addressToEdit?.location ?? "Select on map";
  bool showValidationError = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) => StatefulBuilder(
      builder: (context, setSheetState) {
        return Padding(
          padding: EdgeInsets.only(
            top: 12,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: BlocListener<ProfileCubit, ProfileStates>(
            listener: (context, state) {
              if (state.addAddressStatus == RequestStatus.success) {
                Navigator.pop(context);
                showSuccess(context, 'Address added successfully');
              } else if (state.addAddressStatus == RequestStatus.error) {
                showError(
                  context,
                  state.addAddressErrorMessage ?? 'Something went wrong',
                );
              } else if (state.updateAddressStatus == RequestStatus.success) {
                Navigator.pop(context);
                showSuccess(context, 'Address updated successfully');
              } else if (state.updateAddressStatus == RequestStatus.error) {
                showError(
                  context,
                  state.updateAddressErrorMessage ?? 'Something went wrong',
                );
              }
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    isEditMode ? "Update Address" : "Add New Address",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),

                  const Text(
                    "Label",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: labelController,
                    onChanged: (val) {
                      if (showValidationError) {
                        setSheetState(() => showValidationError = false);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "e.g., Home, Work, Gym",
                      filled: true,
                      fillColor: const Color(0xFFF8F9FB),
                      errorText: showValidationError
                          ? "Label is required"
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Address Type",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTypeOption(
                        icon: Icons.home_outlined,
                        label: "Home",
                        isSelected: selectedType == "home",
                        onTap: () => setSheetState(() => selectedType = "home"),
                      ),
                      _buildTypeOption(
                        icon: Icons.work_outline,
                        label: "Work",
                        isSelected: selectedType == "work",
                        onTap: () => setSheetState(() => selectedType = "work"),
                      ),
                      _buildTypeOption(
                        icon: Icons.location_on_outlined,
                        label: "Other",
                        isSelected: selectedType == "other",
                        onTap: () =>
                            setSheetState(() => selectedType = "other"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  const Text(
                    "Location",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      final String? resultAddress =
                          await Navigator.push<String>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MapPickerScreen(),
                            ),
                          );

                      if (resultAddress != null) {
                        setSheetState(() => locationText = resultAddress);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FB),
                        borderRadius: BorderRadius.circular(12),
                        border: locationText != "Select on map"
                            ? Border.all(
                                color: const Color(0xFF214DA1),
                                width: 1.5,
                              )
                            : null,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFF214DA1),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              locationText,
                              style: TextStyle(
                                color: locationText == "Select on map"
                                    ? Colors.grey
                                    : Colors.black,
                                fontSize: 16,
                                fontWeight: locationText == "Select on map"
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        if (labelController.text.trim().isEmpty) {
                          setSheetState(() => showValidationError = true);
                          return;
                        }

                        if (labelController.text.isNotEmpty &&
                            locationText != "Select on map") {
                          final addressModel = AddressEntity(
                            id: addressToEdit?.id,
                            label: labelController.text,
                            type: selectedType,
                            location: locationText,
                          );

                          if (isEditMode) {
                            context.read<ProfileCubit>().updateAddress(
                              addressModel,
                            );
                          } else {
                            context.read<ProfileCubit>().addAddress(
                              addressModel,
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF214DA1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: BlocBuilder<ProfileCubit, ProfileStates>(
                        builder: (context, state) {
                          if (state.addAddressStatus == RequestStatus.loading) {
                            return const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          } else if (state.updateAddressStatus ==
                              RequestStatus.loading) {
                            return const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }
                          return Text(
                            isEditMode ? "Update Address" : "Save Address",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget _buildTypeOption({
  required IconData icon,
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isSelected ? const Color(0xFF214DA1) : Colors.transparent,
          width: 2,
        ),
        boxShadow: isSelected
            ? [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10)]
            : null,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF214DA1) : Colors.grey,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    ),
  );
}
