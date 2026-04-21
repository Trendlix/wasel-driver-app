import 'package:equatable/equatable.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/entities/driver_profile_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/entities/driver_summary_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/entities/request_categories_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/home/domain/entities/single_request_entity.dart';

class HomeStates extends Equatable {
  final RequestStatus getDriverProfileRequestStatus;
  final DriverProfileEntity? driverProfileModel;
  final String? errorMessage;
  // driver summary
  final RequestStatus driverSummaryRequestStatus;
  final DriverSummaryEntity? driverSummaryModel;
  final String? driverSummaryErrorMessage;
  // driver requests
  final RequestStatus driverRequestsRequestStatus;
  final RequestCategoriesEntity? driverRequestsModel;
  final String? driverRequestsErrorMessage;
  // reject request
  final RequestStatus rejectRequestStatus;
  final String? rejectRequestErrorMessage;
  // send driver offer
  final RequestStatus sendDriverOfferStatus;
  final String? sendDriverOfferErrorMessage;
  // get single request
  final RequestStatus getSingleRequestStatus;
  final SingleRequestEntity? singleRequestModel;
  final String? singleRequestErrorMessage;

  const HomeStates({
    this.getDriverProfileRequestStatus = RequestStatus.initial,
    this.driverProfileModel,
    this.errorMessage,
    // driver summary
    this.driverSummaryRequestStatus = RequestStatus.initial,
    this.driverSummaryModel,
    this.driverSummaryErrorMessage,
    // driver requests
    this.driverRequestsRequestStatus = RequestStatus.initial,
    this.driverRequestsModel,
    this.driverRequestsErrorMessage,
    // reject request
    this.rejectRequestStatus = RequestStatus.initial,
    this.rejectRequestErrorMessage,
    // send driver offer
    this.sendDriverOfferStatus = RequestStatus.initial,
    this.sendDriverOfferErrorMessage,
    // get single request
    this.getSingleRequestStatus = RequestStatus.initial,
    this.singleRequestModel,
    this.singleRequestErrorMessage,
  });

  HomeStates copyWith({
    RequestStatus? getDriverProfileRequestStatus,
    DriverProfileEntity? driverProfileModel,
    String? errorMessage,
    // driver summary
    RequestStatus? driverSummaryRequestStatus,
    DriverSummaryEntity? driverSummaryModel,
    String? driverSummaryErrorMessage,
    // driver requests
    RequestStatus? driverRequestsRequestStatus,
    RequestCategoriesEntity? driverRequestsModel,
    String? driverRequestsErrorMessage,
    // reject request
    RequestStatus? rejectRequestStatus,
    String? rejectRequestErrorMessage,
    // send driver offer
    RequestStatus? sendDriverOfferStatus,
    String? sendDriverOfferErrorMessage,
    // get single request
    RequestStatus? getSingleRequestStatus,
    SingleRequestEntity? singleRequestModel,
    String? singleRequestErrorMessage,
  }) {
    return HomeStates(
      getDriverProfileRequestStatus:
          getDriverProfileRequestStatus ?? this.getDriverProfileRequestStatus,
      driverProfileModel: driverProfileModel ?? this.driverProfileModel,
      errorMessage: errorMessage ?? this.errorMessage,
      // driver summary
      driverSummaryRequestStatus:
          driverSummaryRequestStatus ?? this.driverSummaryRequestStatus,
      driverSummaryModel: driverSummaryModel ?? this.driverSummaryModel,
      driverSummaryErrorMessage:
          driverSummaryErrorMessage ?? this.driverSummaryErrorMessage,
      // driver requests
      driverRequestsRequestStatus:
          driverRequestsRequestStatus ?? this.driverRequestsRequestStatus,
      driverRequestsModel: driverRequestsModel ?? this.driverRequestsModel,
      driverRequestsErrorMessage:
          driverRequestsErrorMessage ?? this.driverRequestsErrorMessage,
      // reject request
      rejectRequestStatus: rejectRequestStatus ?? this.rejectRequestStatus,
      rejectRequestErrorMessage:
          rejectRequestErrorMessage ?? this.rejectRequestErrorMessage,
      // send driver offer
      sendDriverOfferStatus:
          sendDriverOfferStatus ?? this.sendDriverOfferStatus,
      sendDriverOfferErrorMessage:
          sendDriverOfferErrorMessage ?? this.sendDriverOfferErrorMessage,
      // get single request
      getSingleRequestStatus:
          getSingleRequestStatus ?? this.getSingleRequestStatus,
      singleRequestModel: singleRequestModel ?? this.singleRequestModel,
      singleRequestErrorMessage:
          singleRequestErrorMessage ?? this.singleRequestErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    getDriverProfileRequestStatus,
    driverProfileModel,
    errorMessage,
    // driver summary
    driverSummaryRequestStatus,
    driverSummaryModel,
    driverSummaryErrorMessage,
    // driver requests
    driverRequestsRequestStatus,
    driverRequestsModel,
    driverRequestsErrorMessage,
    // reject request
    rejectRequestStatus,
    rejectRequestErrorMessage,
    // send driver offer
    sendDriverOfferStatus,
    sendDriverOfferErrorMessage,
    // get single request
    getSingleRequestStatus,
    singleRequestModel,
    singleRequestErrorMessage,
  ];
}
