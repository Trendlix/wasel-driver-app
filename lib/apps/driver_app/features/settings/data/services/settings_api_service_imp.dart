import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:get_it/get_it.dart';
import 'package:wasel_driver/apps/core/network/api/api_client.dart';
import 'package:wasel_driver/apps/core/network/api/api_endpoints.dart';
import 'package:wasel_driver/apps/core/network/local/local_storage_service.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/data/models/faq_type_model.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/data/models/terms_condition_model.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/data/models/ticket_category_model.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/data/models/ticket_model.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/data/models/user_prefrences_model.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/data/services/settings_api_service.dart';

class SettingsApiServiceImpl implements SettingsApiService {
  final ApiClient _apiClient;

  SettingsApiServiceImpl(this._apiClient);

  @override
  Future<Either<String, String>> submitTicket(TicketModel ticket) async {
    try {
      final formData = FormData.fromMap({
        'subject': ticket.subject,
        'category_id': ticket.category.toString(),
        'priority': ticket.priority,
        'description': ticket.description,
        'attachments': await Future.wait(
          ticket.files.map(
            (file) async => await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ),
        ),
      });

      final result = await _apiClient.post(
        ApiEndpoints.submitTicketPath,
        body: formData,
      );
      if (result.isLeft) {
        return Left(result.left);
      }
      {
        final response = result.right as Response;
        if (response.statusCode == 201) {
          return Right(response.data['data']['id'].toString());
        }
        return Left(response.data['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, UserPreferencesModel>> getUserPreferences() async {
    try {
      final result = await _apiClient.get(ApiEndpoints.userPreferencesPath);
      if (result.isLeft) {
        return Left(result.left);
      }
      {
        final response = result.right as Response;
        if (response.statusCode == 200) {
          return Right(UserPreferencesModel.fromJson(response.data));
        }
        return Left(response.data['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> updateUserPreferences(
    UserPreferencesModel userPreferences,
  ) async {
    try {
      final result = await _apiClient.patch(
        ApiEndpoints.userPreferencesPath,
        body: userPreferences.toJson(),
      );
      if (result.isLeft) {
        return Left(result.left);
      }
      {
        final response = result.right as Response;
        if (response.statusCode == 200) {
          return Right(true);
        }
        return Left(response.data['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<TicketCategoryModel>>>
  getTicketCategories() async {
    try {
      final result = await _apiClient.get(ApiEndpoints.getTicketCategoriesPath);
      if (result.isLeft) {
        return Left(result.left);
      }
      {
        final response = result.right as Response;
        if (response.statusCode == 200) {
          return Right(
            (response.data['data'] as List)
                .map((e) => TicketCategoryModel.fromJson(e))
                .toList(),
          );
        }
        return Left(response.data['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, TermsConditionModel>> getTermsCondition() async {
    try {
      final token = await GetIt.instance<LocalStorageService>().getToken();
      if (token == null) {
        return Left('Token not found');
      }
      final result = await _apiClient.get(
        ApiEndpoints.termsAndConditionsPath,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (result.isLeft) {
        return Left(result.left);
      }
      {
        final response = result.right as Response;
        if (response.statusCode == 200) {
          return Right(TermsConditionModel.fromJson(response.data));
        }
        return Left(response.data['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<FaqModel>>> getFaqs() async {
    try {
      final result = await _apiClient.get(
        ApiEndpoints.frequentlyAskedQuestionsPath,
      );
      if (result.isLeft) {
        return Left(result.left);
      }
      {
        final response = result.right as Response;
        if (response.statusCode == 200) {
          return Right(
            (response.data['data'] as List)
                .map((e) => FaqModel.fromJson(e))
                .toList(),
          );
        }
        return Left(response.data['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
