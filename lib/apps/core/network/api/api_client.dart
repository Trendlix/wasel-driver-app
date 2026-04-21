import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

abstract class ApiClient {
  dynamic configAPiCLient();
  Future<Either<String, dynamic>> get(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  });

  Future<Either<String, dynamic>> post(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  });
  Future<Either<String, dynamic>> delete(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  });
  Future<Either<String, dynamic>> put(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  });

  Future<Either<String, dynamic>> patch(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  });

  Future<Response<dynamic>> fetch(RequestOptions requestOptions);
}
