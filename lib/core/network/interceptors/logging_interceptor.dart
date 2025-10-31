import 'package:dio/dio.dart';

import '../../utils/logger.dart';

/// 日志拦截器
///
/// 记录请求和响应的日志。
///
/// 使用示例:
/// ```dart
/// final dio = Dio()..interceptors.add(LoggingInterceptor());
/// ```
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.logRequest(
      options.method,
      options.uri.toString(),
      options.headers,
      options.data,
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    AppLogger.logResponse(
      response.requestOptions.method,
      response.requestOptions.uri.toString(),
      response.statusCode ?? 0,
      response.headers.map,
      response.data,
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.logError(
      err.requestOptions.method,
      err.requestOptions.uri.toString(),
      err,
    );
    super.onError(err, handler);
  }
}
