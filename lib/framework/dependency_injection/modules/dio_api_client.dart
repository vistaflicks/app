import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../provider/network/dio/dio_client.dart';
import '../../provider/network/dio/dio_logger.dart';
import '../../provider/network/dio/network_interceptor.dart';
import '../inject.dart';

@module
abstract class NetworkModule {
  @LazySingleton(env: [Env.prod])
  DioClient getProductionDioClient(DioLogger dioLogger) {
    final dio =
        Dio(BaseOptions(baseUrl: 'https://backend.vistareels.com/api/v1/user'));
    dio.interceptors.add(networkInterceptor());
    dio.interceptors.add(dioLogger);
    final client = DioClient(dio);
    return client;
  }

  @LazySingleton(env: [Env.dev])
  DioClient getDebugDioClient(DioLogger dioLogger) {
    final dio =
        // Dio(BaseOptions(baseUrl: 'http://192.168.1.25:9001/api/v1/user'));
        Dio(BaseOptions(
            baseUrl: 'https://vistabackend.codnestx.com/api/v1/user'));
    dio.interceptors.add(networkInterceptor());
    dio.interceptors.add(dioLogger);
    final client = DioClient(dio);
    return client;
  }

  @LazySingleton(env: [Env.reel])
  DioClient getReelDioClient(DioLogger dioLogger) {
    final dio =
        // Dio(BaseOptions(baseUrl: 'http://192.168.1.25:9001/api/v1/user'));
        Dio(BaseOptions(
            baseUrl:
                'https://vista-flicks-recommendation-api.onrender.com/api/v1/'));
    dio.interceptors.add(networkInterceptor());
    dio.interceptors.add(dioLogger);
    final client = DioClient(dio);
    return client;
  }
}
