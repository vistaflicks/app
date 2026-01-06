import 'package:dio/dio.dart';

import '../../../utils/local_storage/session.dart';

class DioClient {
  final Dio _dio;

  DioClient(this._dio);

  /*
  * ----GET Request
  * */

  /// Set headers and header Authorization
  Map<String, dynamic> getHeader({bool addToken = true}) {
    Map<String, dynamic> headers = {
      'Accept': 'application/json',
      'contentType': 'application/json',
      'Accept-Language': Session.appLanguage,
      'userType': 'app',
    };

    ///Authorization Header
    String token = Session.userAccessToken;
    if (token.isNotEmpty && addToken) {
      headers.addAll({'Authorization': 'Bearer ${Session.userAccessToken}'});
    }
    return headers;
  }

  Future<dynamic> getRequest(
    String endPoint, {
    dynamic requestBody,
    Map<String, dynamic>? queryParameters,
    bool isBytes = false,
    Options? options,
  }) async {
    try {
      _dio.options.headers = getHeader();

      if (isBytes) {
        return await _dio.get(
          endPoint,
          options: options ?? Options(responseType: ResponseType.bytes),
        );
      } else {
        return await _dio.get(endPoint,
            data: requestBody, queryParameters: queryParameters);
      }
    } catch (e) {
      rethrow;
    }
  }

  /*
  * ----POST Request
  * */
  Future<dynamic> postRequest(
    String endPoint,
    String requestBody, {
    bool isBytes = false,
  }) async {
    try {
      _dio.options.headers = getHeader();
      if (isBytes) {
        return await _dio.post(
          endPoint,
          data: requestBody,
          options: Options(responseType: ResponseType.bytes),
        );
      } else {
        return await _dio.post(endPoint, data: requestBody);
      }
    } catch (e) {
      rethrow;
    }
  }

  /*
  * ----POST Request FormData
  * */
  Future<dynamic> postRequestFormData(
    String endPoint,
    FormData requestBody, {
    bool isBytes = false,
  }) async {
    try {
      _dio.options.headers = getHeader();
      if (isBytes) {
        return await _dio.post(
          endPoint,
          data: requestBody,
          options: Options(responseType: ResponseType.bytes),
        );
      } else {
        return await _dio.post(endPoint, data: requestBody);
      }
    } catch (e) {
      rethrow;
    }
  }

  /*
  * ----POST Request
  * */
  Future<dynamic> patchRequest(
    String endPoint,
    String requestBody, {
    bool isBytes = false,
  }) async {
    try {
      _dio.options.headers = getHeader();
      if (isBytes) {
        return await _dio.patch(
          endPoint,
          data: requestBody,
          options: Options(responseType: ResponseType.bytes),
        );
      } else {
        return await _dio.patch(endPoint, data: requestBody);
      }
    } catch (e) {
      rethrow;
    }
  }

  /*
  * ----POST Request FormData
  * */
  Future<dynamic> patchRequestFormData(
    String endPoint,
    FormData requestBody, {
    bool isBytes = false,
  }) async {
    try {
      _dio.options.headers = getHeader();
      if (isBytes) {
        return await _dio.patch(
          endPoint,
          data: requestBody,
          options: Options(responseType: ResponseType.bytes),
        );
      } else {
        return await _dio.patch(endPoint, data: requestBody);
      }
    } catch (e) {
      rethrow;
    }
  }

  /*
  * ----PUT Request
  * */
  Future<dynamic> putRequest(String endPoint, dynamic requestBody,
      {Map<String, dynamic>? headers}) async {
    try {
      _dio.options.headers = headers ?? getHeader();
      return await _dio.put(endPoint, data: requestBody);
    } catch (e) {
      rethrow;
    }
  }

  /*
  * ----PUT Request FormData
  * */
  Future<dynamic> putRequestFormData(
    String endPoint,
    FormData requestBody,
  ) async {
    try {
      _dio.options.headers = getHeader();
      return await _dio.put(endPoint, data: requestBody);
    } catch (e) {
      rethrow;
    }
  }

  /*
  * ----DELETE Request
  * */
  Future<dynamic> deleteRequest(String endPoint, String? requestBody) async {
    try {
      _dio.options.headers = getHeader();
      return await _dio.delete(endPoint, data: requestBody);
    } catch (e) {
      rethrow;
    }
  }
}
