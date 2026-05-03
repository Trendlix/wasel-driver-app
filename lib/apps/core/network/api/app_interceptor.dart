import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:wasel_driver/apps/core/di/app_service_locator.dart';
import 'package:wasel_driver/apps/core/network/api/dio_client.dart';
import 'package:wasel_driver/apps/core/network/local/local_storage_service.dart';
import 'package:wasel_driver/apps/core/routes/navigation_manager.dart';
import 'package:wasel_driver/apps/core/widgets/custom_snackbar_widget.dart';
import 'package:wasel_driver/apps/driver_app/features/auth/data/services/driver_auth_api_service_imp.dart';

class AppInterceptor extends Interceptor {
  bool _isRefreshing = false;
  Completer<bool>? _refreshCompleter;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Just attach token directly — no expiry check, trust the server
    final token = await _getAccessToken();
    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // If already refreshing, WAIT for it instead of starting another
      if (_isRefreshing) {
        final success = await _refreshCompleter!.future;
        if (success) {
          final newToken = await _getAccessToken();
          err.requestOptions.headers["Authorization"] = "Bearer $newToken";
          final response = await serviceLocator<DioClient>().fetch(
            err.requestOptions,
          );
          return handler.resolve(response);
        } else {
          _forceLogout();
          return handler.next(err);
        }
      }

      // First request to hit 401 — start the refresh
      _isRefreshing = true;
      _refreshCompleter = Completer<bool>();

      final refreshed = await _handleRefreshToken();
      _refreshCompleter!.complete(refreshed); // notify all waiting requests
      _isRefreshing = false;
      _refreshCompleter = null;

      if (refreshed) {
        final newToken = await _getAccessToken();
        err.requestOptions.headers["Authorization"] = "Bearer $newToken";
        final response = await serviceLocator<DioClient>().fetch(
          err.requestOptions,
        );
        return handler.resolve(response);
      } else {
        _forceLogout();
      }
    }

    handler.next(err);
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
