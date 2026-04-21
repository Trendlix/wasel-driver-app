import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/usecases/cancel_driver_trip_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/usecases/confirm_trip_devlivery_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/usecases/get_driver_trip_by_id_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/usecases/get_driver_trips_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/usecases/confirm_trip_pick_up_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/presentation/cubit/driver_trip_states.dart';

class DriverTripCubit extends Cubit<DriverTripStates> {
  final GetDriverTripsUsecase _getDriverTripsUsecase;
  final GetDriverTripByIdUsecase _getDriverTripByIdUsecase;
  final CancelDriverTripUsecase _cancelDriverTripUsecase;
  final ConfirmTripPickUpUsecase _confirmTripPickUpUsecase;
  final ConfirmTripDevliveryUsecase _confirmTripDevliveryUsecase;

  DriverTripCubit(
    this._getDriverTripsUsecase,
    this._getDriverTripByIdUsecase,
    this._cancelDriverTripUsecase,
    this._confirmTripPickUpUsecase,
    this._confirmTripDevliveryUsecase,
  ) : super(const DriverTripStates());

  Future<void> getDriverTrips() async {
    emit(state.copyWith(getDriverTripsStatus: RequestStatus.loading));
    final result = await _getDriverTripsUsecase();
    result.fold(
      (l) => emit(
        state.copyWith(
          getDriverTripsStatus: RequestStatus.error,
          getDriverTripsMessage: l,
        ),
      ),
      (r) => emit(
        state.copyWith(getDriverTripsStatus: RequestStatus.success, trips: r),
      ),
    );
  }

  Future<void> getDriverTripById(int id) async {
    emit(state.copyWith(getDriverTripByIdStatus: RequestStatus.loading));
    final result = await _getDriverTripByIdUsecase(id);
    result.fold(
      (l) => emit(
        state.copyWith(
          getDriverTripByIdStatus: RequestStatus.error,
          getDriverTripByIdMessage: l,
        ),
      ),
      (r) => emit(
        state.copyWith(getDriverTripByIdStatus: RequestStatus.success, trip: r),
      ),
    );
  }

  Future<void> cancelDriverTrip(int id) async {
    emit(state.copyWith(cancelDriverTripStatus: RequestStatus.loading));
    final result = await _cancelDriverTripUsecase(id);
    result.fold(
      (l) => emit(
        state.copyWith(
          cancelDriverTripStatus: RequestStatus.error,
          cancelDriverTripMessage: l,
        ),
      ),
      (r) =>
          emit(state.copyWith(cancelDriverTripStatus: RequestStatus.success)),
    );
  }

  Future<void> confirmPickup(int tripId, String otp) async {
    emit(state.copyWith(confirmPickupStatus: RequestStatus.loading));
    final result = await _confirmTripPickUpUsecase(tripId, otp);
    result.fold(
      (l) => emit(
        state.copyWith(
          confirmPickupStatus: RequestStatus.error,
          confirmPickupMessage: l,
        ),
      ),
      (r) => emit(
        state.copyWith(confirmPickupStatus: RequestStatus.success, booking: r),
      ),
    );
  }

  Future<void> confirmDelivery(int tripId, String otp, String image) async {
    emit(state.copyWith(confirmDeliveryStatus: RequestStatus.loading));
    final result = await _confirmTripDevliveryUsecase(tripId, otp, image);
    result.fold(
      (l) => emit(
        state.copyWith(
          confirmDeliveryStatus: RequestStatus.error,
          confirmDeliveryMessage: l,
        ),
      ),
      (r) => emit(
        state.copyWith(
          confirmDeliveryStatus: RequestStatus.success,
          tripSummaries: r,
        ),
      ),
    );
  }
}
