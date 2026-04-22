import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/usecases/get_driver_profile_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/usecases/get_driver_requests_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/usecases/get_driver_summary_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/usecases/get_single_request_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/usecases/reject_driver_request_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/usecases/send_driver_offer_usecase.dart';
import 'package:wasel_driver/apps/driver_app/features/home/presentation/cubit/home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  final GetDriverProfileUsecase? _getDriverProfileUsecase;
  final GetDriverSummaryUsecase? _getDriverSummaryUsecase;
  final GetDriverRequestsUsecase? _getDriverRequestsUsecase;
  final RejectDriverRequestUsecase? _rejectDriverRequestUsecase;
  final SendDriverOfferUsecase? _sendDriverOfferUsecase;
  final GetSingleRequestUsecase? _getSingleRequestUsecase;

  HomeCubit({
    required GetDriverProfileUsecase? getDriverProfileUsecase,
    required GetDriverSummaryUsecase? getDriverSummaryUsecase,
    required GetDriverRequestsUsecase? getDriverRequestsUsecase,
    required RejectDriverRequestUsecase? rejectDriverRequestUsecase,
    required SendDriverOfferUsecase? sendDriverOfferUsecase,
    required GetSingleRequestUsecase? getSingleRequestUsecase,
  }) : _getDriverProfileUsecase = getDriverProfileUsecase,
       _getDriverSummaryUsecase = getDriverSummaryUsecase,
       _getDriverRequestsUsecase = getDriverRequestsUsecase,
       _rejectDriverRequestUsecase = rejectDriverRequestUsecase,
       _sendDriverOfferUsecase = sendDriverOfferUsecase,
       _getSingleRequestUsecase = getSingleRequestUsecase,
       super(const HomeStates());

  Future<void> getDriverProfile() async {
    emit(state.copyWith(getDriverProfileRequestStatus: RequestStatus.loading));
    final res = await _getDriverProfileUsecase!.call();
    if (isClosed) return;
    res.fold(
      (l) => emit(
        state.copyWith(
          getDriverProfileRequestStatus: RequestStatus.error,
          errorMessage: l,
        ),
      ),
      (r) => emit(
        state.copyWith(
          getDriverProfileRequestStatus: RequestStatus.success,
          driverProfileModel: r,
        ),
      ),
    );
  }

  Future<void> getDriverSummary() async {
    emit(state.copyWith(driverSummaryRequestStatus: RequestStatus.loading));
    final res = await _getDriverSummaryUsecase!.call();
    if (isClosed) return;
    res.fold(
      (l) => emit(
        state.copyWith(
          driverSummaryRequestStatus: RequestStatus.error,
          driverSummaryErrorMessage: l,
        ),
      ),
      (r) => emit(
        state.copyWith(
          driverSummaryRequestStatus: RequestStatus.success,
          driverSummaryModel: r,
        ),
      ),
    );
  }

  Future<void> getDriverRequests(double driverLat, double driverLong) async {
    emit(state.copyWith(driverRequestsRequestStatus: RequestStatus.loading));
    final res = await _getDriverRequestsUsecase!.call(driverLat, driverLong);
    if (isClosed) return;
    res.fold(
      (l) => emit(
        state.copyWith(
          driverRequestsRequestStatus: RequestStatus.error,
          driverRequestsErrorMessage: l,
        ),
      ),
      (r) => emit(
        state.copyWith(
          driverRequestsRequestStatus: RequestStatus.success,
          driverRequestsModel: r,
        ),
      ),
    );
  }

  Future<void> rejectRequest(
    String requestId,
    double driverLat,
    double driverLong,
  ) async {
    emit(state.copyWith(rejectRequestStatus: RequestStatus.loading));
    final res = await _rejectDriverRequestUsecase!.call(requestId);
    if (isClosed) return;
    res.fold(
      (l) => emit(
        state.copyWith(
          rejectRequestStatus: RequestStatus.error,
          rejectRequestErrorMessage: l,
        ),
      ),
      (r) {
        emit(state.copyWith(rejectRequestStatus: RequestStatus.success));
        //getDriverRequests(driverLat, driverLong);
      },
    );
  }

  Future<void> sendDriverOffer(
    int requestId,
    int pricebyDriver,
    double locationLat,
    double locationLong,
  ) async {
    emit(state.copyWith(sendDriverOfferStatus: RequestStatus.loading));
    final res = await _sendDriverOfferUsecase!.call(
      requestId,
      pricebyDriver,
      locationLat,
      locationLong,
    );
    if (isClosed) return;
    res.fold(
      (l) => emit(
        state.copyWith(
          sendDriverOfferStatus: RequestStatus.error,
          sendDriverOfferErrorMessage: l,
        ),
      ),
      (r) => emit(state.copyWith(sendDriverOfferStatus: RequestStatus.success)),
    );
  }

  Future<void> getSingleRequest(int requestId, double lat, double long) async {
    emit(state.copyWith(getSingleRequestStatus: RequestStatus.loading));
    final res = await _getSingleRequestUsecase!.call(requestId, lat, long);
    if (isClosed) return;
    res.fold(
      (l) => emit(
        state.copyWith(
          getSingleRequestStatus: RequestStatus.error,
          singleRequestErrorMessage: l,
        ),
      ),
      (r) => emit(
        state.copyWith(
          getSingleRequestStatus: RequestStatus.success,
          singleRequestModel: r,
        ),
      ),
    );
  }

  Future<void> resetRejectRequestStatus() async {
    emit(state.copyWith(rejectRequestStatus: RequestStatus.initial));
  }
}
