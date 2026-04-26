import 'dart:developer' show log;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:wasel_driver/apps/core/errors/exception_model.dart';
import 'package:wasel_driver/apps/core/errors/handel_dio_errors.dart';
import 'package:wasel_driver/apps/core/network/api/api_client.dart';
import 'package:wasel_driver/apps/core/network/api/api_endpoints.dart';
import 'package:wasel_driver/apps/core/network/api/app_interceptor.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';

class DioClient implements ApiClient {
  Dio? _dioClient;

  DioClient() {
    _dioClient = configAPiCLient();
  }
  @override
  Dio configAPiCLient() {
    final dio = Dio();
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
              return true;
            };
        return client;
      },
    );
    dio.options.baseUrl = ApiEndpoints.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.sendTimeout = const Duration(seconds: 30);
    dio.options.responseType = ResponseType.json;
    dio.interceptors.add(AppInterceptor());
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          compact: false,
          // logPrint: AppLogger.instance.log,
          logPrint: (object) => log(object.toString()),
        ),
      );
    }
    return dio;
  }

  @override
  Future<Either<String, Response>> delete(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dioClient!.delete(
        path,
        cancelToken: cancelToken,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );
      return Right(response);
    } on DioException catch (er) {
      final error = handleDioError(er);
      return _handleErrorMessage(error);
    }
  }

  @override
  Future<Either<String, Response>> get(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dioClient!.get(
        path,
        cancelToken: cancelToken,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );
      return Right(response);
    } on DioException catch (er) {
      final error = handleDioError(er);
      return _handleErrorMessage(error);
    }
  }

  @override
  Future<Either<String, Response>> post(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dioClient!.post(
        path,
        cancelToken: cancelToken,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );
      return Right(response);
    } on DioException catch (er) {
      final error = handleDioError(er);
      return _handleErrorMessage(error);
    }
  }

  @override
  Future<Either<String, Response>> put(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dioClient!.put(
        path,
        cancelToken: cancelToken,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );
      return Right(response);
    } on DioException catch (er) {
      final error = handleDioError(er);
      return _handleErrorMessage(error);
    }
  }

  @override
  Future<Response<dynamic>> fetch(RequestOptions requestOptions) async {
    return _dioClient!.fetch(requestOptions);
  }

  Left<String, Response<dynamic>> _handleErrorMessage(dynamic error) {
    // Refined version
    final errorMessage = error.message;
    if (errorMessage is List && errorMessage.isNotEmpty) {
      return Left(errorMessage.first.toString());
    } else if (errorMessage is List && errorMessage.isEmpty) {
      return const Left("An unknown error occurred"); // Fallback for empty list
    }
    return Left(errorMessage?.toString() ?? "An unexpected error occurred");
  }

  @override
  Future<Either<String, dynamic>> patch(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dioClient!.patch(
        path,
        cancelToken: cancelToken,
        data: body,
        queryParameters: queryParameters,
        options: options,
      );
      return Right(response);
    } on DioException catch (er) {
      final error = handleDioError(er);
      return _handleErrorMessage(error);
    }
  }
}
