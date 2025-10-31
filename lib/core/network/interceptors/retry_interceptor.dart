import 'dart:math';
import 'package:dio/dio.dart';

import '../../constants/app_constants.dart';
import '../../utils/logger.dart';

/// 重试拦截器
///
/// 当请求失败时，根据错误类型和状态码决定是否重试。
///
/// 使用示例:
/// ```dart
/// final dio = Dio()..interceptors.add(RetryInterceptor());
/// ```
class RetryInterceptor extends Interceptor {
  /// 创建重试拦截器
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_shouldRetry(err)) {
      final retryCount = (err.requestOptions.extra['retryCount'] as int?) ?? 0;

      if (retryCount < AppConstants.maxRetryAttempts) {
        AppLogger.info(
          '重试请求 (第${retryCount + 1}次/${AppConstants.maxRetryAttempts}次)',
        );

        // 计算延迟时间（指数退避）
        final delay = Duration(
          milliseconds:
              AppConstants.retryDelay.inMilliseconds *
              pow(2, retryCount).toInt(),
        );

        await Future<void>.delayed(delay);

        // 更新重试计数
        err.requestOptions.extra['retryCount'] = retryCount + 1;

        try {
          final response = await Dio().fetch<Response<dynamic>>(
            err.requestOptions,
          );
          handler.resolve(response);
          return;
        } on Exception catch (e) {
          // 重试失败，继续处理错误
          AppLogger.warning('第${retryCount + 1}次重试失败: $e');
        }
      } else {
        AppLogger.warning('已达到最大重试次数 (${AppConstants.maxRetryAttempts})');
      }
    }

    super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    // 网络错误或超时错误可以重试
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      return true;
    }

    // 服务器错误（5xx）可以重试
    if (err.response?.statusCode != null) {
      final statusCode = err.response!.statusCode!;
      if (statusCode >= 500 && statusCode < 600) {
        return true;
      }
    }

    // 特定错误码可以重试
    if (err.response?.statusCode == 429) {
      // Too Many Requests
      return true;
    }

    return false;
  }
}
