import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/data/models/register_driver_model.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/domain/usecases/check_driver_phone_registered_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/domain/usecases/get_driver_account_status_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/domain/usecases/get_driver_trucks_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/domain/usecases/verify_driver_otp_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/domain/usecases/register_driver_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/presentation/cubit/driver_auth_states.dart';

class DriverAuthCubit extends Cubit<DriverAuthState> {
  final CheckDriverPhoneRegisteredUsecase _checkPhoneRegisteredUsecase;
  final VerifyDriverOtpUsecase _verifyOtpUsecase;
  final RegisterDriverUsecase _registerDriverUsecase;
  final GetDriverTrucksUsecase _getDriverTrucksUsecase;
  final GetDriverAccountStatusUsecase _getDriverAccountStatusUsecase;

  DriverAuthCubit(
    this._checkPhoneRegisteredUsecase,
    this._verifyOtpUsecase,
    this._registerDriverUsecase,
    this._getDriverTrucksUsecase,
    this._getDriverAccountStatusUsecase,
  ) : super(DriverAuthState());

  Future<void> checkPhoneIsRegistered(String phone, AuthMode authMode) async {
    emit(
      state.copyWith(
        checkPhoneIsRegisteredRequestStatus: RequestStatus.loading,
      ),
    );
    final result = await _checkPhoneRegisteredUsecase(phone, authMode);
    result.fold(
      (error) {
        emit(
          state.copyWith(
            checkPhoneIsRegisteredRequestStatus: RequestStatus.error,
            checkPhoneIsRegisteredErrorMessage: error,
          ),
        );
      },
      (value) {
        emit(
          state.copyWith(
            checkPhoneIsRegisteredRequestStatus: RequestStatus.success,
            phone: value,
          ),
        );
      },
    );
  }

  Future<void> verifyOtp(Map<String, dynamic> body) async {
    emit(state.copyWith(otpRequestStatus: RequestStatus.loading));
    final result = await _verifyOtpUsecase(body);
    result.fold(
      (error) {
        emit(
          state.copyWith(
            otpRequestStatus: RequestStatus.error,
            otpErrorMessage: error,
          ),
        );
      },
      (value) {
        emit(
          state.copyWith(
            otpRequestStatus: RequestStatus.success,
            userVerificationTypeModel: value,
          ),
        );
      },
    );
  }

  Future<void> registerDriver(
    RegisterDriverModel registerDriverModel,
    String tempToken,
  ) async {
    emit(state.copyWith(registerDriverRequestStatus: RequestStatus.loading));
    final result = await _registerDriverUsecase(registerDriverModel, tempToken);
    result.fold(
      (error) {
        emit(
          state.copyWith(
            registerDriverRequestStatus: RequestStatus.error,
            registerDriverErrorMessage: error,
          ),
        );
      },
      (value) {
        emit(
          state.copyWith(
            registerDriverRequestStatus: RequestStatus.success,
            reference: value,
          ),
        );
      },
    );
  }

  Future<void> getDriverTrucks(String tempToken) async {
    emit(state.copyWith(getDriverTrucksRequestStatus: RequestStatus.loading));
    final result = await _getDriverTrucksUsecase(tempToken);
    result.fold(
      (error) {
        emit(
          state.copyWith(
            getDriverTrucksRequestStatus: RequestStatus.error,
            getDriverTrucksErrorMessage: error,
          ),
        );
      },
      (value) {
        emit(
          state.copyWith(
            getDriverTrucksRequestStatus: RequestStatus.success,
            truckTypes: value,
          ),
        );
      },
    );
  }

  Future<void> getDriverAccountStatus() async {
    emit(
      state.copyWith(
        getDriverAccountStatusRequestStatus: RequestStatus.loading,
      ),
    );
    final result = await _getDriverAccountStatusUsecase();
    result.fold(
      (error) {
        emit(
          state.copyWith(
            getDriverAccountStatusRequestStatus: RequestStatus.error,
            getDriverAccountStatusErrorMessage: error,
          ),
        );
      },
      (value) {
        emit(
          state.copyWith(
            getDriverAccountStatusRequestStatus: RequestStatus.success,
            driverAccountStatus: value,
          ),
        );
      },
    );
  }

  void reset() {
    emit(DriverAuthState());
  }
}
