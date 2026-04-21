import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/widgets/custom_dialog_widget.dart';
import 'package:wasel_driver/apps/core/widgets/empty_widget.dart';
import 'package:wasel_driver/apps/core/widgets/error_retry_widget.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/presentation/manager/profile_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/presentation/manager/profile_states.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/presentation/widgets/show_add_new_address_sheet.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  static const Color primaryBlue = AppColors.primary;
  static const Color accentYellow = AppColors.secondary;
  static const Color backgroundColor = Color(0xFFF8F9FB);

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getUserAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        toolbarHeight: 80,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Saved Addresses",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: accentYellow,
              radius: 18,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.add, color: Colors.black, size: 20),
                onPressed: () {
                  showAddNewAddressSheet(context);
                },
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<ProfileCubit, ProfileStates>(
        listenWhen: (previous, current) =>
            previous.deleteAddressStatus != current.deleteAddressStatus,
        listener: (context, state) {
          if (state.deleteAddressStatus == RequestStatus.success) {
            showSuccess(context, "Address deleted successfully");
          } else if (state.deleteAddressStatus == RequestStatus.error) {
            showError(
              context,
              state.deleteAddressErrorMessage ?? "something went wrong",
            );
          }
        },
        builder: (context, state) {
          if (state.getUserAddressesStatus == RequestStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.getUserAddressesStatus == RequestStatus.error) {
            return Center(
              child: ErrorRetryWidget(
                message:
                    state.getUserAddressesErrorMessage ??
                    'something went wrong',
                onRetry: () => context.read<ProfileCubit>().getUserAddresses(),
              ),
            );
          } else if (state.getUserAddressesStatus == RequestStatus.success) {
            final addresses = state.userAddresses ?? [];
            return addresses.isEmpty
                ? Center(
                    child: EmptyWidget(
                      message: "No addresses found",
                      onRetry: () {
                        context.read<ProfileCubit>().getUserAddresses();
                      },
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: addresses.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      final addressItem = addresses[index];
                      final isDeleting =
                          state.deletedAddressId == addressItem.id;

                      return _buildAddressCard(
                        icon: _getIconByType(addressItem.type!),
                        title: addressItem.label!,
                        address: addressItem.location!,
                        isDeleting: isDeleting,
                        onEdit: () {
                          showAddNewAddressSheet(
                            context,
                            addressToEdit: addressItem,
                          );
                        },
                        onDelete: () {
                          context.read<ProfileCubit>().deleteAddress(
                            addressItem.id.toString(),
                          );
                        },
                      );
                    },
                  );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  IconData _getIconByType(String type) {
    switch (type.toLowerCase()) {
      case 'home':
        return Icons.home_outlined;
      case 'work':
        return Icons.work_outline;
      default:
        return Icons.location_on_outlined;
    }
  }

  Widget _buildAddressCard({
    required IconData icon,
    required String title,
    required String address,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    bool isDeleting = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4FF),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF214DA1), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildIconButton(
                Icons.edit_outlined,
                AppColors.primary.withValues(alpha: 0.1),
                AppColors.primary,
                false,
                onEdit,
              ),
              const SizedBox(width: 8),
              _buildIconButton(
                Icons.delete_outline,
                Colors.red.withValues(alpha: 0.1),
                Colors.red,
                isDeleting,
                onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(
    IconData icon,
    Color bgColor,
    Color iconColor,
    bool isDeleted,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: BlocBuilder<ProfileCubit, ProfileStates>(
          builder: (context, state) {
            if (state.deleteAddressStatus == RequestStatus.loading &&
                isDeleted) {
              return SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            return Icon(icon, color: iconColor, size: 20);
          },
        ),
      ),
    );
  }
}
