import 'package:equatable/equatable.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/entities/booking_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/entities/trip_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/domain/entities/trip_summary_entity.dart';

class DriverTripStates extends Equatable {
  final RequestStatus? getDriverTripsStatus;
  final String? getDriverTripsMessage;
  final List<TripEntity>? trips;

  // get driver trip by id
  final RequestStatus? getDriverTripByIdStatus;
  final String? getDriverTripByIdMessage;
  final TripEntity? trip;

  // cancel driver trip
  final RequestStatus? cancelDriverTripStatus;
  final String? cancelDriverTripMessage;

  // confirm pickup
  final RequestStatus? confirmPickupStatus;
  final String? confirmPickupMessage;
  final BookingEntity? booking;
  // confirm trip delivery
  final RequestStatus? confirmDeliveryStatus;
  final String? confirmDeliveryMessage;
  final TripSummaryEntity? tripSummaries;

  const DriverTripStates({
    this.getDriverTripsStatus,
    this.getDriverTripsMessage,
    this.trips,
    // get driver trip by id
    this.getDriverTripByIdStatus,
    this.getDriverTripByIdMessage,
    this.trip,
    // cancel driver trip
    this.cancelDriverTripStatus,
    this.cancelDriverTripMessage,
    // confirm pickup
    this.confirmPickupStatus,
    this.confirmPickupMessage,
    this.booking,
    // confirm trip delivery
    this.confirmDeliveryStatus,
    this.confirmDeliveryMessage,
    this.tripSummaries,
  });

  DriverTripStates copyWith({
    RequestStatus? getDriverTripsStatus,
    String? getDriverTripsMessage,
    List<TripEntity>? trips,
    // get driver trip by id
    RequestStatus? getDriverTripByIdStatus,
    String? getDriverTripByIdMessage,
    TripEntity? trip,
    // cancel driver trip
    RequestStatus? cancelDriverTripStatus,
    String? cancelDriverTripMessage,
    // confirm pickup
    RequestStatus? confirmPickupStatus,
    String? confirmPickupMessage,
    BookingEntity? booking,
    // confirm trip delivery
    RequestStatus? confirmDeliveryStatus,
    String? confirmDeliveryMessage,
    TripSummaryEntity? tripSummaries,
  }) {
    return DriverTripStates(
      getDriverTripsStatus: getDriverTripsStatus ?? this.getDriverTripsStatus,
      getDriverTripsMessage:
          getDriverTripsMessage ?? this.getDriverTripsMessage,
      trips: trips ?? this.trips,
      // get driver trip by id
      getDriverTripByIdStatus:
          getDriverTripByIdStatus ?? this.getDriverTripByIdStatus,
      getDriverTripByIdMessage:
          getDriverTripByIdMessage ?? this.getDriverTripByIdMessage,
      trip: trip ?? this.trip,
      // cancel driver trip
      cancelDriverTripStatus:
          cancelDriverTripStatus ?? this.cancelDriverTripStatus,
      cancelDriverTripMessage:
          cancelDriverTripMessage ?? this.cancelDriverTripMessage,
      // confirm pickup
      confirmPickupStatus: confirmPickupStatus ?? this.confirmPickupStatus,
      confirmPickupMessage: confirmPickupMessage ?? this.confirmPickupMessage,
      booking: booking ?? this.booking,
      // confirm trip delivery
      confirmDeliveryStatus:
          confirmDeliveryStatus ?? this.confirmDeliveryStatus,
      confirmDeliveryMessage:
          confirmDeliveryMessage ?? this.confirmDeliveryMessage,
      tripSummaries: tripSummaries ?? this.tripSummaries,
    );
  }

  @override
  List<Object?> get props => [
    getDriverTripsStatus,
    getDriverTripsMessage,
    trips,
    // get driver trip by id
    getDriverTripByIdStatus,
    getDriverTripByIdMessage,
    trip,
    // cancel driver trip
    cancelDriverTripStatus,
    cancelDriverTripMessage,
    // confirm pickup
    confirmPickupStatus,
    confirmPickupMessage,
    booking,
    // confirm trip delivery
    confirmDeliveryStatus,
    confirmDeliveryMessage,
    tripSummaries,
  ];
}
