import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vista_flicks/framework/provider/network/network.dart';

part 'network_exceptions.freezed.dart';

@freezed
class NetworkExceptions with _$NetworkExceptions {
  const factory NetworkExceptions.requestCancelled() = RequestCancelled;

  const factory NetworkExceptions.unauthorizedRequest() = UnauthorizedRequest;

  const factory NetworkExceptions.badRequest() = BadRequest;

  const factory NetworkExceptions.notFound(String reason, Response? response) =
      NotFound;

  const factory NetworkExceptions.methodNotAllowed() = MethodNotAllowed;

  const factory NetworkExceptions.notAcceptable() = NotAcceptable;

  const factory NetworkExceptions.requestTimeout() = RequestTimeout;

  const factory NetworkExceptions.sendTimeout() = SendTimeout;

  const factory NetworkExceptions.conflict() = Conflict;

  const factory NetworkExceptions.internalServerError() = InternalServerError;

  const factory NetworkExceptions.notImplemented() = NotImplemented;

  const factory NetworkExceptions.serviceUnavailable() = ServiceUnavailable;

  const factory NetworkExceptions.noInternetConnection() = NoInternetConnection;

  const factory NetworkExceptions.formatException() = FormatException;

  const factory NetworkExceptions.unableToProcess() = UnableToProcess;

  const factory NetworkExceptions.defaultError(String error) = DefaultError;

  const factory NetworkExceptions.unexpectedError() = UnexpectedError;

  const factory NetworkExceptions.badCertificate() = BadCertificate;

  const factory NetworkExceptions.connectionError() = ConnectionError;

  static NetworkExceptions handleResponse(
      int? statusCode, DioException error, Response? response) {
    //print("....error status code...$statusCode");
    errorStatusCode = statusCode!;
    switch (statusCode) {
      case 400:
        return NetworkExceptions.notFound(error.message ?? 'Unknown', response);
      case 401:
        return const NetworkExceptions.unauthorizedRequest();
      case 403:
        return NetworkExceptions.notFound(error.message ?? 'Unknown', response);
      case 404:
      case 422:
        return NetworkExceptions.notFound(error.message ?? 'Unknown', response);
      case 409:
        return const NetworkExceptions.conflict();
      case 408:
        return const NetworkExceptions.requestTimeout();
      case 500:
        return const NetworkExceptions.internalServerError();
      case 503:
        return const NetworkExceptions.serviceUnavailable();
      case 504:
        return const NetworkExceptions.serviceUnavailable();
      default:
        var responseCode = statusCode;
        return NetworkExceptions.defaultError(
            'Received invalid status code: $responseCode');
    }
  }

  static NetworkExceptions getDioException(error) {
    if (error is Exception) {
      try {
        late NetworkExceptions networkExceptions;
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              networkExceptions = const NetworkExceptions.requestCancelled();
              break;
            case DioExceptionType.connectionTimeout:
              networkExceptions = const NetworkExceptions.requestTimeout();
              break;
            case DioExceptionType.unknown:
              if (error.error.runtimeType.toString() == 'SocketException') {
                networkExceptions =
                    const NetworkExceptions.noInternetConnection();
              } else {
                networkExceptions = const NetworkExceptions.sendTimeout();
              }
              break;
            case DioExceptionType.receiveTimeout:
              networkExceptions = const NetworkExceptions.sendTimeout();
              break;
            case DioExceptionType.badResponse:
              networkExceptions = NetworkExceptions.handleResponse(
                  error.response!.statusCode, error, error.response);
              break;
            case DioExceptionType.sendTimeout:
              networkExceptions = const NetworkExceptions.sendTimeout();
              break;
            case DioExceptionType.badCertificate:
              networkExceptions = const NetworkExceptions.badCertificate();
              break;
            case DioExceptionType.connectionError:
              networkExceptions = const NetworkExceptions.connectionError();
              break;
          }
        } else if (error.runtimeType.toString() == 'SocketException') {
          networkExceptions = const NetworkExceptions.noInternetConnection();
        } else if (error.runtimeType.toString() == 'FormatException') {
          networkExceptions = const NetworkExceptions.formatException();
        } else {
          networkExceptions = const NetworkExceptions.unexpectedError();
        }
        return networkExceptions;
      } catch (_) {
        return const NetworkExceptions.unexpectedError();
      }
    } else {
      if (error.toString().contains('is not a subtype of')) {
        if (kDebugMode) {
          print(error.toString());
        }
        return const NetworkExceptions.unableToProcess();
      } else {
        return const NetworkExceptions.unexpectedError();
      }
    }
  }

  static String getErrorMessage(NetworkExceptions networkExceptions) {
    var errorMessage = '';
    networkExceptions.when(notImplemented: () {
      errorMessage = 'Not Implemented';
    }, requestCancelled: () {
      errorMessage = 'Request Cancelled';
    }, internalServerError: () {
      errorMessage = 'Internal Server Error';
    }, notFound: (String reason, Response? response) {
      errorMessage = response?.toString() ?? reason;
    }, serviceUnavailable: () {
      errorMessage = 'Service unavailable';
    }, methodNotAllowed: () {
      errorMessage = 'Method Allowed';
    }, badRequest: () {
      errorMessage = 'Bad request';
    }, unauthorizedRequest: () {
      errorMessage = 'Unauthorized request';
    }, unexpectedError: () {
      errorMessage = 'Unexpected error occurred';
    }, requestTimeout: () {
      errorMessage = 'Connection request timeout';
    }, noInternetConnection: () {
      errorMessage = 'No internet connection';
    }, conflict: () {
      errorMessage = 'Error due to a conflict';
    }, sendTimeout: () {
      errorMessage = 'Send timeout in connection with API server';
    }, unableToProcess: () {
      errorMessage = 'Unable to process the data';
    }, defaultError: (String error) {
      errorMessage = error;
    }, formatException: () {
      errorMessage = 'FormatException something went wrong with data';
    }, notAcceptable: () {
      errorMessage = 'Not acceptable';
    }, badCertificate: () {
      errorMessage = 'Bade Certificate';
    }, connectionError: () {
      errorMessage = 'Connection error';
    });
    return errorMessage;
  }

  static int errorStatusCode = 0;
}
