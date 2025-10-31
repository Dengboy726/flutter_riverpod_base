import 'package:dio/dio.dart';

import '../../errors/exceptions.dart';
import '../../utils/logger.dart';

/// 错误拦截器
///
/// 将 DioException 转换为应用异常，并记录错误日志。
///
/// 使用示例:
/// ```dart
/// final dio = Dio()..interceptors.add(ErrorInterceptor());
/// ```
class ErrorInterceptor extends Interceptor {
  /// 创建错误拦截器
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 将 DioException 转换为应用异常
    final exception = err.toAppException();

    // 记录错误
    AppLogger.error('请求失败: ${err.requestOptions.uri}', err);

    // 创建新的 DioException 包含转换后的异常
    final newErr = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: exception,
      stackTrace: err.stackTrace,
    );

    super.onError(newErr, handler);
  }
}
