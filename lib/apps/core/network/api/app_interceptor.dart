import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:wasel_driver/apps/core/di/app_service_locator.dart';
import 'package:wasel_driver/apps/core/network/api/dio_client.dart';
import 'package:wasel_driver/apps/core/network/local/local_storage_service.dart';
import 'package:wasel_driver/apps/core/routes/navigation_manager.dart';
import 'package:wasel_driver/apps/core/widgets/custom_snackbar_widget.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/data/services/driver_auth_api_service_imp.dart';

class AppInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    String? accessToken = await _getAccessToken();
    String? refreshToken = await _getRefreshToken();

    if (accessToken != null) {
      // 1. Check expiration with a 60-second leeway to handle clock drift
      bool isNearExpiration =
          JwtDecoder.isExpired(accessToken) || _isAboutToExpire(accessToken);

      if (isNearExpiration && refreshToken != null) {
        bool refreshed = await _handleRefreshToken();
        if (refreshed) {
          accessToken = await _getAccessToken();
        } else {
          // If refresh fails, we don't necessarily logout yet.
          // We let the request proceed; if it returns 401, onError will handle logout.
          // This prevents logging out users due to temporary network issues.
        }
      }

      if (accessToken != null) {
        options.headers["Authorization"] = "Bearer $accessToken";
      }
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 2. Handle 401 Unauthorized (Expired or Invalid Token)
    if (err.response?.statusCode == 401) {
      bool refreshed = await _handleRefreshToken();
      if (refreshed) {
        final newToken = await _getAccessToken();
        err.requestOptions.headers["Authorization"] = "Bearer $newToken";

        // Retry the original request with the new token
        try {
          final response = await serviceLocator<DioClient>().fetch(
            err.requestOptions,
          );
          return handler.resolve(response);
        } on DioException catch (retryErr) {
          return handler.next(retryErr);
        }
      } else {
        // If refresh fails here, the session is truly dead.
        _forceLogout();
      }
    }

    handler.next(err);
  }

  /// Helper to check if token expires in the next 60 seconds
  bool _isAboutToExpire(String token) {
    try {
      DateTime expirationDate = JwtDecoder.getExpirationDate(token);
      return expirationDate.isBefore(
        DateTime.now().add(const Duration(seconds: 60)),
      );
    } catch (_) {
      return true;
    }
  }

  Future<bool> _handleRefreshToken() async {
    try {
      final refreshToken = await _getRefreshToken();
      if (refreshToken == null) return false;

      // Note: AuthApiServiceImp should use a Dio instance WITHOUT this interceptor
      final response = await serviceLocator<DriverAuthApiServiceImp>()
          .askToGetRefreshToken(refreshToken);

      return await response.fold((err) async => false, (result) async {
        await _saveTokens(result.$1, result.$2);
        return true;
      });
    } catch (e) {
      return false;
    }
  }

  void _forceLogout() {
    final context =
        GetIt.instance<NavigationManager>().navigatorKey.currentContext;
    if (context != null) {
      showSnackError(context, 'Session Expired, Please Login Again');
    }
    GetIt.instance<NavigationManager>().logoutAndNavigateToLogin();
  }

  Future<String?> _getAccessToken() async =>
      await serviceLocator<LocalStorageService>().getToken();
  Future<String?> _getRefreshToken() async =>
      await serviceLocator<LocalStorageService>().getRefreshToken();

  Future<void> _saveTokens(String acc, String ref) async {
    await serviceLocator<LocalStorageService>().saveToken(acc);
    await serviceLocator<LocalStorageService>().saveRefreshToken(ref);
  }
}
