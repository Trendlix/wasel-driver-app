import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';
import 'package:wasel_driver/apps/core/errors/handel_dio_errors.dart';
import 'package:wasel_driver/apps/core/network/api/api_client.dart';
import 'package:wasel_driver/apps/core/network/api/api_endpoints.dart';
import 'package:wasel_driver/apps/core/network/local/local_storage_service.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/data/models/booking_model.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/data/models/trip_model.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/data/models/trip_summary_model.dart';
import 'package:wasel_driver/apps/driver_app/features/trips/data/services/driver_trip_api_service.dart';

class DriverTripApiImpService implements DriverTripApiService {
  final ApiClient _apiClient;

  DriverTripApiImpService(this._apiClient);

  @override
  Future<Either<String, List<TripModel>>> getDriverTrips() async {
    try {
      final token = await GetIt.instance<LocalStorageService>().getToken();
      if (token == null) {
        return Left('Token not found');
      }
      final response = await _apiClient.get(
        ApiEndpoints.getDriverTripsPath,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.isLeft) {
        return Left(response.left);
      }
      final data = response.right as Response;
      if (data.statusCode != 200) {
        return Left(data.data['message']);
      }
      final trips = (data.data['data'] as List)
          .map((e) => TripModel.fromJson(e))
          .toList();
      return Right(trips);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, TripModel>> getDriverTripById(int id) async {
    try {
      final token = await GetIt.instance<LocalStorageService>().getToken();
      if (token == null) {
        return Left('Token not found');
      }
      final response = await _apiClient.get(
        ApiEndpoints.getDriverTripByIdPath + id.toString(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.isLeft) {
        return Left(response.left);
      }
      final data = response.right as Response;
      if (data.statusCode != 200) {
        return Left(data.data['message']);
      }
      final trip = TripModel.fromJson(data.data['data']['formattedTrips']);
      return Right(trip);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, bool>> cancelDriverTrip(int id) async {
    try {
      final response = await _apiClient.put(
        '${ApiEndpoints.cancelDriverTripPath}/$id/cancel',
      );
      if (response.isLeft) {
        return Left(response.left);
      }
      final data = response.right as Response;
      if (data.statusCode != 200) {
        return Left(data.data['message']);
      }
      return Right(true);
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, BookingModel>> confirmPickup(
    int tripId,
    String otp,
  ) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.confirmPickupPath,
        body: {'tripId': tripId, 'otp': otp},
      );
      if (response.isLeft) {
        return Left(response.left);
      }
      final data = response.right as Response;
      if (data.statusCode == 201) {
        final booking = BookingModel.fromJson(data.data['data']);
        return Right(booking);
      } else {
        return Left(data.data['message']);
      }
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, TripSummaryModel>> confirmDelivery(
    int tripId,
    String otp,
    String image,
  ) async {
    try {
      final formData = FormData.fromMap({
        'tripId': tripId,
        'otp': otp,
        'delivery_proof': await MultipartFile.fromFile(
          image,
          filename: image.split('/').last,
        ),
      });

      final response = await _apiClient.post(
        ApiEndpoints.confirmDeliveryPath,
        body: formData,
      );
      if (response.isLeft) {
        return Left(response.left);
      }
      final data = response.right as Response;
      if (data.statusCode == 201) {
        final trip = TripSummaryModel.fromJson(data.data['data']);
        return Right(trip);
      } else {
        return Left(data.data['message']);
      }
    } catch (e) {
      return Left(handleException(e));
    }
  }
}
