import 'package:injectable/injectable.dart';

import '../../provider/network/dio/dio_logger.dart';
import '../inject.dart';

@module
abstract class DioLoggerModule {
  @LazySingleton(env: [Env.dev, Env.prod, Env.reel])
  DioLogger getDioLogger() {
    final dioLogger = DioLogger();
    return dioLogger;
  }
}
