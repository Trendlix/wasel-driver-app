import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/core/di/app_service_locator.dart';
import 'package:wasel_driver/apps/core/errors/handel_dio_errors.dart';
import 'package:wasel_driver/apps/core/network/api/api_client.dart';
import 'package:wasel_driver/apps/core/network/api/api_endpoints.dart';
import 'package:wasel_driver/apps/core/network/local/local_storage_service.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/data/model/address_model.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/data/model/driver_documents_model.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/data/model/driver_legel_info_model.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/data/model/profile_model.dart';
import 'package:wasel_driver/apps/driver_app/features/profile/data/services/profile_api_service.dart';

class ProfileApiServiceImp implements ProfileApiService {
  final ApiClient _apiClient;
  ProfileApiServiceImp({required ApiClient apiClient}) : _apiClient = apiClient;
  @override
  Future<Either<String, bool>> logout() async {
    try {
      final refreshToken = await serviceLocator<LocalStorageService>()
          .getRefreshToken();
      if (refreshToken == null) {
        return Left('Refresh token not found');
      }
      final result = await _apiClient.post(
        ApiEndpoints.driverLogoutPath,
        options: Options(headers: {'refresh-token': refreshToken}),
      );
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 200 || response.data['statusCode'] == 200) {
          await serviceLocator<LocalStorageService>().clearTokens();
          return Right(true);
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
  Future<Either<String, ProfileModel>> getProfile() async {
    try {
      final token = await serviceLocator<LocalStorageService>().getToken();
      if (token == null) {
        return Left('Token not found');
      }
      final result = await _apiClient.get(
        ApiEndpoints.getUserProfilePath,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 200 || response.data['statusCode'] == 200) {
          final profileResponse = response.data;
          return Right(ProfileModel.fromJson(profileResponse['data']));
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
  Future<Either<String, ProfileModel>> updaetUserProfile(
    ProfileModel profileModel,
  ) async {
    return Right(profileModel);
    // try {
    //   // 1. Create the Map for FormData with only text fields
    //   Map<String, dynamic> data = {
    //     "full_name": profileModel.fullName,
    //     "email": profileModel.email,
    //   };

    //   // 2. Handle avatar — file path OR base64, both sent as binary
    //   if (profileModel.avatar != null) {
    //     final file = File(profileModel.avatar!);

    //     if (file.existsSync()) {
    //       // It's a local file path → send as binary directly
    //       data["avatar"] = await MultipartFile.fromFile(
    //         profileModel.avatar!,
    //         filename: profileModel.avatar!.split('/').last,
    //       );
    //     } else {
    //       // It's a base64 string → decode to bytes and send as binary
    //       try {
    //         final bytes = base64Decode(profileModel.avatar!);
    //         data["avatar"] = MultipartFile.fromBytes(
    //           bytes,
    //           filename: "avatar.jpg",
    //         );
    //       } catch (_) {
    //         // Not a valid base64 string, skip avatar
    //       }
    //     }
    //   }

    //   // 3. Wrap in FormData object
    //   FormData formData = FormData.fromMap(data);
    //   final result = await _apiClient.patch(
    //     ApiEndpoints.getUserProfilePath,
    //     body: formData,
    //   );
    //   if (result.isLeft) {
    //     return Left(result.left);
    //   } else {
    //     final response = result.right as Response;
    //     if (response.statusCode == 200 || response.data['statusCode'] == 200) {
    //       final profileResponse = response.data;
    //       return Right(ProfileModel.fromJson(profileResponse['data']));
    //     } else {
    //       final mesg = response.data['message'];
    //       return Left(mesg);
    //     }
    //   }
    // } catch (e) {
    //   return Left(e.toString());
    // }
  }

  @override
  Future<Either<String, List<AddressModel>>> getAddresses() async {
    try {
      final result = await _apiClient.get(ApiEndpoints.getAddressesPath);
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 200 || response.data['statusCode'] == 200) {
          final profileResponse = response.data;
          return Right(
            (profileResponse['data'] as List)
                .map((e) => AddressModel.fromJson(e))
                .toList(),
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
  Future<Either<String, bool>> addAddress(AddressModel addressModel) async {
    try {
      final result = await _apiClient.post(
        ApiEndpoints.getAddressesPath,
        body: addressModel.toJson(),
      );
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 201 || response.data['statusCode'] == 201) {
          return Right(true);
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
  Future<Either<String, bool>> deleteAddress(String addressId) async {
    try {
      final result = await _apiClient.delete(
        '${ApiEndpoints.getAddressesPath}/$addressId',
      );
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 200 || response.data['statusCode'] == 200) {
          return Right(true);
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
  Future<Either<String, bool>> updateAddress(AddressModel addressModel) async {
    try {
      final result = await _apiClient.patch(
        '${ApiEndpoints.getAddressesPath}/${addressModel.id}',
        body: addressModel.toJson(),
      );
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 200 || response.data['statusCode'] == 200) {
          return Right(true);
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
  Future<Either<String, bool>> changeUserPassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final result = await _apiClient.post(
        ApiEndpoints.changeUserPasswordPath,
        body: {'current_password': oldPassword, 'new_password': newPassword},
      );
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 200 || response.data['statusCode'] == 200) {
          return Right(true);
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
  Future<Either<String, DriverBasicInfoModel>> getDriverBasicInfo() async {
    try {
      final token = await serviceLocator<LocalStorageService>().getToken();
      if (token == null) {
        return Left('Token not found');
      }
      final result = await _apiClient.get(
        ApiEndpoints.driverBasicInfoPath,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 200 || response.data['statusCode'] == 200) {
          return Right(DriverBasicInfoModel.fromJson(response.data['data']));
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
  Future<Either<String, DriverLegalInfoModel>> getDriverLegalInfo() async {
    try {
      final token = await serviceLocator<LocalStorageService>().getToken();
      if (token == null) {
        return Left('Token not found');
      }
      final result = await _apiClient.get(
        ApiEndpoints.driverLegelInfoPath,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 200 || response.data['statusCode'] == 200) {
          return Right(DriverLegalInfoModel.fromJson(response.data['data']));
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
  Future<Either<String, DriverBasicInfoModel>> updateDriverBasicInfo(
    DriverBasicInfoModel model,
  ) async {
    try {
      final token = await serviceLocator<LocalStorageService>().getToken();
      if (token == null) {
        return Left('Token not found');
      }
      final result = await _apiClient.put(
        ApiEndpoints.driverBasicInfoPath,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        body: model.toJson(),
      );
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 200 || response.data['statusCode'] == 200) {
          return Right(DriverBasicInfoModel.fromJson(response.data['data']));
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
  Future<Either<String, DriverDocumentsModel>> getDriverDocuments() async {
    try {
      final token = await serviceLocator<LocalStorageService>().getToken();
      if (token == null) {
        return Left('Token not found');
      }
      final result = await _apiClient.get(
        ApiEndpoints.getDriverDocumentsPath,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 200 || response.data['statusCode'] == 200) {
          return Right(DriverDocumentsModel.fromJson(response.data));
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
  Future<Either<String, bool>> uploadDriverDocument(
    String file,
    String type,
    String expiryDate,
  ) async {
    try {
      final token = await serviceLocator<LocalStorageService>().getToken();
      if (token == null) {
        return Left('Token not found');
      }
      final formData = FormData.fromMap({
        'type': type,
        'expiry_date': expiryDate,
        'file': await MultipartFile.fromFile(
          file,
          filename: file.split('/').last,
        ),
      });

      final result = await _apiClient.post(
        ApiEndpoints.getDriverDocumentsPath,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        body: formData,
      );
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 201 || response.data['statusCode'] == 201) {
          return Right(true);
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
  Future<Either<String, bool>> renewDriverDocument(
    String documentId,
    String file,
    String expiryDate,
  ) async {
    try {
      final token = await serviceLocator<LocalStorageService>().getToken();
      if (token == null) {
        return Left('Token not found');
      }
      final formData = FormData.fromMap({
        'expiry_date': expiryDate,
        'file': await MultipartFile.fromFile(
          file,
          filename: file.split('/').last,
        ),
      });

      final result = await _apiClient.put(
        '${ApiEndpoints.getDriverDocumentsPath}/$documentId/renew',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        body: formData,
      );
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 200 || response.data['statusCode'] == 200) {
          return Right(true);
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
  Future<Either<String, bool>> deleteDriverAccount() async {
    try {
      final token = await serviceLocator<LocalStorageService>().getToken();
      if (token == null) {
        return Left('Token not found');
      }
      final result = await _apiClient.delete(
        ApiEndpoints.deleteDriverAccountPath,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 200 || response.data['statusCode'] == 200) {
          return Right(true);
        } else {
          final mesg = response.data['message'];
          return Left(mesg);
        }
      }
    } catch (e) {
      return Left(handleException(e));
    }
  }
}
