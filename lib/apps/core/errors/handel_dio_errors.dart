import 'package:dio/dio.dart';
import 'package:wasel_driver/apps/core/errors/status_code.dart';
import 'exception_model.dart';

const String _connectionTimeoutError = 'connectionTimeoutError';
const String _noInternetConnection = 'noInternetConnection';
const String _internalServerError = 'internal server error';
const String _undefinedError = 'undefined error';
const String _cancelRequestError = 'Request was cancelled';

ServerException handleDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const FetchDataException(_connectionTimeoutError);

    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode;
      final errorMessage = error.response!.data['message'];

      switch (statusCode) {
        case StatusCode.badRequest:
          return BadRequestException(errorMessage);
        case StatusCode.unauthorized:
        case StatusCode.forbidden:
          return UnauthorizedException(errorMessage);
        case StatusCode.notFound:
          return NotFoundException(errorMessage);
        case StatusCode.conflict:
          return ConflictException(errorMessage);
        case StatusCode.unProcessableEntity:
          return UnProcessableEntityException(errorMessage);
        case StatusCode.internalServerError:
          return InternalServerErrorException(
            errorMessage ?? _internalServerError,
          );
        case StatusCode.noInternet:
          return const NoInternetException(_noInternetConnection);
        case StatusCode.timeout:
          return const TimeOutException(_connectionTimeoutError);
        default:
          return const FetchDataException(_connectionTimeoutError);
      }

    case DioExceptionType.cancel:
      return ServerException(_cancelRequestError);

    case DioExceptionType.unknown:
    case DioExceptionType.badCertificate:
    case DioExceptionType.connectionError:
      return const NoInternetException(_noInternetConnection);

    // default:
    //   return const ServerException(_undefinedError);
  }
}

String handleException(dynamic e) {
  if (e is TypeError) return 'Invalid data format';
  if (e is DioException) {
    return e.response?.data?['message']?.toString() ?? 'Network error';
  }
  if (e is FormatException) return 'Invalid format';
  return 'Something went wrong';
}
