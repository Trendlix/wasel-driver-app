import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:wasel_driver/apps/core/network/api/api_client.dart';
import 'package:wasel_driver/apps/core/network/api/api_endpoints.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/data/models/notification_model.dart';
import 'package:wasel_driver/apps/driver_app/features/notification/data/service/notification_api_serviice.dart';

class NotificationApiServiceImp implements NotificationApiServiice {
  final ApiClient _apiClient;

  NotificationApiServiceImp(this._apiClient);

  @override
  Future<Either<String, List<NotificationModel>>> getNotifications({
    required int page,
    required int limit,
  }) async {
    try {
      final result = await _apiClient.get(
        ApiEndpoints.notificationsPath,
        queryParameters: {'page': page, 'limit': limit},
      );
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 200) {
          final List<NotificationModel> notifications =
              (response.data['data'] as List)
                  .map((i) => NotificationModel.fromJson(i))
                  .toList();
          return Right(notifications);
        } else {
          return Left(response.data['message'] ?? "something went wrong");
        }
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> markAllNotificationsAsRead() async {
    try {
      final result = await _apiClient.patch(
        ApiEndpoints.markAllNotificationsAsReadPath,
      );
      if (result.isLeft) {
        return Left(result.left);
      } else {
        final response = result.right as Response;
        if (response.statusCode == 200) {
          return Right(true);
        } else {
          return Left(response.data['message'] ?? "something went wrong");
        }
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
