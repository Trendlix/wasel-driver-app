import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/register_stepper_states.dart';

// ── Cubit ─────────────────────────────────────────────────────────────────────

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit() : super(const RegistrationState());

  // Call this when validation fails
  void setShowErrors(bool value) {
    emit(state.copyWith(showErrors: value));
  }

  // ── Stepper navigation ────────────────────────────────────────────────────

  void nextStep() {
    if (state.currentStep < state.totalSteps - 1) {
      final updated = List<bool>.from(state.completedSteps);
      updated[state.currentStep] = true;
      emit(
        state.copyWith(
          currentStep: state.currentStep + 1,
          completedSteps: updated,
          showErrors: false,
        ),
      );
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step < state.totalSteps) {
      emit(state.copyWith(currentStep: step));
    }
  }

  // ── Step 1 - Personal Info ────────────────────────────────────────────────

  void updateFullName(String value) => emit(state.copyWith(fullName: value));
  void updateDriverType(String value) =>
      emit(state.copyWith(driverType: value));

  // ── Step 2 - Documents ────────────────────────────────────────────────────

  void updateNationalIdFront(String? v) =>
      emit(state.copyWith(nationalIdFront: v));
  void updateNationalIdBack(String? v) =>
      emit(state.copyWith(nationalIdBack: v));
  void updateNationalIdExpiry(String? v) =>
      emit(state.copyWith(nationalIdExpiry: v));
  void updateDriverLicenseFront(String? v) =>
      emit(state.copyWith(driverLicenseFront: v));
  void updateDriverLicenseBack(String? v) =>
      emit(state.copyWith(driverLicenseBack: v));
  void updateLicenseExpiry(String? v) => emit(state.copyWith(licenseExpiry: v));
  void updateVehicleOwnershipDoc(String? v) =>
      emit(state.copyWith(vehicleOwnershipDoc: v));
  void updateCriminalRecord(String? v) =>
      emit(state.copyWith(criminalRecord: v));

  // ── Step 3 - Vehicle Info ─────────────────────────────────────────────────

  void updateTruckType(String value, String id) =>
      emit(state.copyWith(truckType: value, truckTypeId: id));
  void updateWeightCapacity(String value) =>
      emit(state.copyWith(weightCapacity: value));
  void updateTruckModel(String value) =>
      emit(state.copyWith(truckModel: value));
  void updateYear(String value) => emit(state.copyWith(year: value));
  void updatePlateNumber(String value) =>
      emit(state.copyWith(plateNumber: value));
  void toggleAgreeToAds(bool value) => emit(state.copyWith(agreeToAds: value));

  // ── Step 4 - Photos ───────────────────────────────────────────────────────

  void updateProfilePhoto(String? v) => emit(state.copyWith(profilePhoto: v));
  void updateTruckPhoto(String? v) => emit(state.copyWith(truckPhoto: v));
}
