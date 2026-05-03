import 'package:dio/dio.dart';
import 'package:either_dart/src/either.dart';
import 'package:wasel_driver/apps/core/enums/app_enums.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/errors/handel_dio_errors.dart';
import 'package:wasel_driver/apps/core/network/api/api_client.dart';
import 'package:wasel_driver/apps/core/network/api/api_endpoints.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/data/models/register_driver_model.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/data/models/truck_model.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/data/models/verify_otp_model.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/data/services/driver_auth_api_service.dart';

class DriverAuthApiServiceImp implements DriverAuthApiService {
  final ApiClient _apiClient; // Dependency injection
  DriverAuthApiServiceImp({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<Either<String, String>> checkPhoneIsRegistered(
    String phone,
    AuthMode authMode,
  ) async {
    try {
      final result = await _apiClient.post(
        '${ApiEndpoints.checkPhoneIsLoginPath}${authMode.name}',
        body: {'phone': phone, 'is_driver': true},
      );
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 201 || response.data['statusCode'] == 200) {
          return Right(phone);
        } else {
          final mesg = response.data['message'];
          return Left(mesg);
        }
      }
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, UserVerificationTypeModel>> verifyOtp(
    Map<String, dynamic> body,
  ) async {
    try {
      final result = await _apiClient.post(ApiEndpoints.otpPath, body: body);
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 201 || response.data['statusCode'] == 200) {
          if (response.data['data'] == null) {
            return Left('Something went wrong');
          }
          final res = response.data['data']['temp_token'];
          if (res != null) {
            return Right(
              UserVerificationTypeModel(
                value: res,
                type: VerifyOtpType.register,
              ),
            );
          } else if (response.data['data']['reference_id'] != null ||
              response.data['data']['access_token'] != null) {
            return Right(
              UserVerificationTypeModel.fromJson(response.data['data']),
            );
          } else {
            return Left('No temp token found');
          }
        } else {
          final msg = response.data['message'];
          return Left(msg);
        }
      }
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, String>> registerDriver(
    RegisterDriverModel registerDriverModel,
    String tempToken,
  ) async {
    try {
      final result = await _apiClient.post(
        ApiEndpoints.driverRegisterPath,
        body: registerDriverModel.toFormData(),
        options: Options(headers: {'Authorization': 'Bearer $tempToken'}),
      );
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 201 || response.data['statusCode'] == 200) {
          if (response.data['data'] == null) {
            return Left('Something went wrong');
          }
          return Right(response.data['data']['reference']);
        } else {
          final mesg = response.data['message'];
          return Left(mesg);
        }
      }
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, List<TruckTypeModel>>> getTruckTypes(
    String tempToken,
  ) async {
    try {
      final result = await _apiClient.get(
        ApiEndpoints.driverTrucksPath,
        options: Options(headers: {'Authorization': 'Bearer $tempToken'}),
      );
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 200) {
          if (response.data['data'] == null) {
            return Left('Something went wrong');
          }
          final res = response.data['data'] as List<dynamic>;
          if (res.isNotEmpty) {
            return Right(res.map((x) => TruckTypeModel.fromJson(x)).toList());
          } else {
            return Left('No truck types found');
          }
        } else {
          final mesg = response.data['message'];
          return Left(mesg);
        }
      }
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, UserVerificationTypeModel>>
  getDriverAccountStatus() async {
    try {
      final result = await _apiClient.get(ApiEndpoints.driverAccountStatusPath);
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 200) {
          if (response.data['data'] == null) {
            return Left('Something went wrong');
          }
          return Right(
            UserVerificationTypeModel.fromJson(response.data['data']),
          );
        } else {
          final mesg = response.data['message'];
          return Left(mesg);
        }
      }
    } catch (e) {
      return Left(handleException(e));
    }
  }

  @override
  Future<Either<String, (String acc, String ref)>> askToGetRefreshToken(
    String refreshToken,
  ) async {
    final result = await _apiClient.post(
      ApiEndpoints.askForRefreshTokenPath,
      body: {'refresh_token': refreshToken},
    );
    if (result.isLeft) {
      return Left(result.left);
    } else {
      final response = result.right as Response;
      if (response.statusCode == 201 || response.data['statusCode'] == 200) {
        final newAccessToken = response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'];
        return Right((newAccessToken, newRefreshToken));
      } else {
        final mesg = response.data['message'];
        return Left(mesg);
      }
    }
  }
}
