import 'package:dio/dio.dart';

import '../utils/logger.dart';
import 'exceptions.dart';
import 'failures.dart';
import 'status_codes.dart';

/// 错误处理器
///
/// 提供统一的错误处理功能，将各种异常转换为应用层的Failure对象。
/// 支持Dio异常、通用异常和错误的统一处理。
///
/// 主要功能:
/// - 异常到Failure的转换
/// - Dio异常的特殊处理
/// - 错误消息的本地化
/// - 重试逻辑的判断
/// - 错误分类和统计
///
/// 使用示例:
/// ```dart
/// try {
///   final result = await someOperation();
/// } catch (e) {
///   final failure = ErrorHandler.handleException(e);
///   // 处理错误
/// }
/// ```
class ErrorHandler {
  /// 私有构造函数，防止实例化
  ErrorHandler._();

  /// 将异常转换为失败对象
  static Failure handleException(Exception exception) {
    AppLogger.error('Exception occurred: $exception');

    if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is NetworkException) {
      return NetworkFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is TimeoutException) {
      return TimeoutFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is AuthenticationException) {
      return AuthenticationFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is AuthorizationException) {
      return AuthorizationFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is CacheException) {
      return CacheFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is FileException) {
      return FileFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else {
      return UnknownFailure(
        message: '未知错误: $exception',
        code: StatusCode.UNKNOWN,
        details: {'originalException': exception.toString()},
      );
    }
  }

  /// 处理 Dio 异常
  static Failure handleDioException(DioException dioException) {
    AppLogger.error('DioException occurred: $dioException');
    final exception = dioException.toAppException();
    return handleException(exception);
  }

  /// 处理通用错误
  static Failure handleError(Object error) {
    AppLogger.error('Error occurred: $error');
    if (error is DioException) {
      return handleDioException(error);
    }
    if (error is Exception) {
      return handleException(error);
    }
    return UnknownFailure(
      message: '未知错误: $error',
      code: StatusCode.UNKNOWN,
      details: {'originalError': error.toString()},
    );
  }

  /// 获取用户友好的错误消息
  static String getErrorMessage(Failure failure) {
    // 优先使用 Failure 自带 message
    if (failure.message.isNotEmpty) {
      return failure.message;
    }
    // 其次使用状态码的描述（已本地化的通用描述）
    if (failure.code != null) {
      return failure.code!.description;
    }
    // 兜底文案
    return StatusCode.UNKNOWN.description;
  }

  /// 检查是否为网络错误
  static bool isNetworkError(Failure failure) =>
      failure is NetworkFailure ||
      failure is TimeoutFailure ||
      failure is ServerFailure;

  /// 检查是否为认证错误
  static bool isAuthenticationError(Failure failure) =>
      failure is AuthenticationFailure || failure is AuthorizationFailure;

  /// 检查是否为可重试的错误
  static bool isRetryableError(Failure failure) =>
      failure is NetworkFailure ||
      failure is TimeoutFailure ||
      (failure is ServerFailure &&
          failure.code != StatusCode.UNAUTHORIZED &&
          failure.code != StatusCode.FORBIDDEN &&
          failure.code != StatusCode.NOT_FOUND);
}
