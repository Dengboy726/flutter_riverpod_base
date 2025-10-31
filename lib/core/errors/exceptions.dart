import 'package:dio/dio.dart';
import 'status_codes.dart';

/// 服务器异常
///
/// 当服务器返回错误响应时抛出的异常。
/// 通常表示服务器端处理请求时发生了错误，如业务逻辑错误、数据验证失败等。
///
/// 使用场景:
/// - HTTP 4xx 和 5xx 状态码响应
/// - 服务器返回的错误信息
/// - 业务逻辑验证失败
///
/// 示例:
/// ```dart
/// throw ServerException(
///   message: '用户不存在',
///   code: StatusCode.NOT_FOUND,
///   details: {'userId': '12345'},
/// );
/// ```
class ServerException implements Exception {
  /// 创建服务器异常实例
  ///
  /// 参数:
  /// - [message] 错误消息，描述具体的错误信息
  /// - [code] 状态码，用于标识错误类型，可选
  /// - [details] 额外的错误详情，包含调试信息，可选
  const ServerException({required this.message, this.code, this.details});

  /// 错误消息
  ///
  /// 描述具体的错误信息，通常来自服务器的错误响应
  final String message;

  /// 状态码
  ///
  /// 用于标识错误类型的状态码，有助于错误分类和处理
  final StatusCode? code;

  /// 错误详情
  ///
  /// 包含额外的调试信息，如请求ID、时间戳等
  final Map<String, dynamic>? details;

  @override
  String toString() => 'ServerException: $message';
}

/// 网络异常
///
/// 当网络连接出现问题时抛出的异常。
/// 包括网络不可用、连接超时、DNS解析失败等情况。
///
/// 使用场景:
/// - 网络连接不可用
/// - 请求超时
/// - DNS解析失败
/// - 网络配置错误
///
/// 示例:
/// ```dart
/// throw NetworkException(
///   message: '网络连接失败',
///   code: StatusCode.CONNECTION_ERROR,
/// );
/// ```
class NetworkException implements Exception {
  /// 创建网络异常实例
  const NetworkException({required this.message, this.code, this.details});

  /// 错误消息
  ///
  /// 描述具体的错误信息，通常来自网络连接的错误响应
  final String message;

  /// 状态码
  ///
  /// 用于标识错误类型的状态码，有助于错误分类和处理
  final StatusCode? code;

  /// 错误详情
  ///
  /// 包含额外的调试信息，如请求ID、时间戳等
  final Map<String, dynamic>? details;

  @override
  String toString() => 'NetworkException: $message';
}

/// 缓存异常
///
/// 当缓存操作失败时抛出的异常。
/// 通常用于缓存读取、写入或删除操作失败的情况。
///
/// 使用场景:
/// - 缓存读取失败
/// - 缓存写入失败
/// - 缓存删除失败
class CacheException implements Exception {
  /// 创建缓存异常实例
  const CacheException({required this.message, this.code, this.details});

  /// 错误消息
  ///
  /// 描述具体的错误信息，通常来自缓存操作的错误响应
  final String message;

  /// 状态码
  ///
  /// 用于标识错误类型的状态码，有助于错误分类和处理
  final StatusCode? code;

  /// 错误详情
  ///
  /// 包含额外的调试信息，如请求ID、时间戳等
  final Map<String, dynamic>? details;

  @override
  String toString() => 'CacheException: $message';
}

/// 验证异常
///
/// 当数据验证失败时抛出的异常。
/// 通常用于数据验证、表单验证等场景。
///
/// 使用场景:
/// - 数据验证失败
/// - 表单验证失败
/// - 参数验证失败

/// 创建验证异常实例
class ValidationException implements Exception {
  /// 创建验证异常实例
  ///
  /// 参数:
  /// - [message] 错误消息，描述具体的错误信息
  /// - [code] 状态码，用于标识错误类型，可选
  /// - [details] 额外的错误详情，包含调试信息，可选
  const ValidationException({required this.message, this.code, this.details});

  /// 错误消息
  ///
  /// 描述具体的错误信息，通常来自数据验证的错误响应
  final String message;

  /// 状态码
  ///
  /// 用于标识错误类型的状态码，有助于错误分类和处理
  final StatusCode? code;

  /// 错误详情
  ///
  /// 包含额外的调试信息，如请求ID、时间戳等
  final Map<String, dynamic>? details;

  @override
  String toString() => 'ValidationException: $message';
}

/// 认证异常
///
/// 当认证失败时抛出的异常。
/// 通常用于认证、授权等场景。
///
/// 使用场景:
/// - 认证失败
/// - 授权失败
class AuthenticationException implements Exception {
  /// 创建认证异常实例
  ///
  /// 参数:
  /// - [message] 错误消息，描述具体的错误信息
  /// - [code] 状态码，用于标识错误类型，可选
  /// - [details] 额外的错误详情，包含调试信息，可选
  const AuthenticationException({
    required this.message,
    this.code,
    this.details,
  });

  /// 错误消息
  ///
  /// 描述具体的错误信息，通常来自认证的错误响应
  final String message;

  /// 状态码
  ///
  /// 用于标识错误类型的状态码，有助于错误分类和处理
  final StatusCode? code;

  /// 错误详情
  ///
  /// 包含额外的调试信息，如请求ID、时间戳等
  final Map<String, dynamic>? details;

  @override
  String toString() => 'AuthenticationException: $message';
}

/// 授权异常
///
/// 当授权失败时抛出的异常。
/// 通常用于授权、权限等场景。
///
/// 使用场景:
/// - 授权失败
/// - 权限不足
class AuthorizationException implements Exception {
  /// 创建授权异常实例
  ///
  /// 参数:
  /// - [message] 错误消息，描述具体的错误信息
  /// - [code] 状态码，用于标识错误类型，可选
  /// - [details] 额外的错误详情，包含调试信息，可选
  const AuthorizationException({
    required this.message,
    this.code,
    this.details,
  });

  /// 错误消息
  ///
  /// 描述具体的错误信息，通常来自授权的错误响应
  final String message;

  /// 状态码
  ///
  /// 用于标识错误类型的状态码，有助于错误分类和处理
  final StatusCode? code;

  /// 错误详情
  ///
  /// 包含额外的调试信息，如请求ID、时间戳等
  final Map<String, dynamic>? details;

  @override
  String toString() => 'AuthorizationException: $message';
}

/// 超时异常
///
/// 当请求或操作超过指定时间限制时抛出的异常。
/// 通常用于网络请求超时、数据库操作超时等场景。
///
/// 使用场景:
/// - HTTP请求超时
/// - 数据库查询超时
/// - 文件操作超时
/// - 长时间运行的操作超时
///
/// 示例:
/// ```dart
/// throw TimeoutException(
///   message: '请求超时',
///   code: StatusCode.TIMEOUT,
/// );
/// ```
class TimeoutException implements Exception {
  /// 创建超时异常实例
  ///
  /// 参数:
  /// - [message] 错误消息，描述具体的错误信息
  /// - [code] 状态码，用于标识错误类型，可选
  /// - [details] 额外的错误详情，包含调试信息，可选
  const TimeoutException({required this.message, this.code, this.details});

  /// 错误消息
  ///
  /// 描述具体的错误信息，通常来自超时的错误响应
  final String message;

  /// 状态码
  ///
  /// 用于标识错误类型的状态码，有助于错误分类和处理
  final StatusCode? code;

  /// 错误详情
  ///
  /// 包含额外的调试信息，如请求ID、时间戳等
  final Map<String, dynamic>? details;

  @override
  String toString() => 'TimeoutException: $message';
}

/// 文件异常
///
/// 当文件操作失败时抛出的异常。
/// 通常用于文件读取、写入或删除操作失败的情况。
///
/// 使用场景:
/// - 文件读取失败
/// - 文件写入失败
/// - 文件删除失败
class FileException implements Exception {
  /// 创建文件异常实例
  ///
  /// 参数:
  /// - [message] 错误消息，描述具体的错误信息
  /// - [code] 状态码，用于标识错误类型，可选
  /// - [details] 额外的错误详情，包含调试信息，可选
  const FileException({required this.message, this.code, this.details});

  /// 错误消息
  ///
  /// 描述具体的错误信息，通常来自文件操作的错误响应
  final String message;

  /// 状态码
  ///
  /// 用于标识错误类型的状态码，有助于错误分类和处理
  final StatusCode? code;

  /// 错误详情
  ///
  /// 包含额外的调试信息，如请求ID、时间戳等
  final Map<String, dynamic>? details;

  @override
  String toString() => 'FileException: $message';
}

/// Dio异常扩展
///
/// 提供将 [DioException] 转换为应用特定异常的功能。
/// 这个扩展简化了网络层的错误处理，将Dio的异常统一转换为应用层的异常类型。
///
/// 转换规则:
/// - [DioExceptionType.connectionTimeout] -> [TimeoutException]
/// - [DioExceptionType.sendTimeout] -> [TimeoutException]
/// - [DioExceptionType.receiveTimeout] -> [TimeoutException]
/// - [DioExceptionType.badResponse] -> [ServerException]
/// - [DioExceptionType.cancel] -> [NetworkException] with [StatusCode.CANCELLED]
/// - [DioExceptionType.connectionError] -> [NetworkException]
/// - [DioExceptionType.badCertificate] -> [NetworkException] with [StatusCode.BAD_CERTIFICATE]
/// - 其他类型 -> [NetworkException] with [StatusCode.UNKNOWN]
///
/// 使用示例:
/// ```dart
/// try {
///   final response = await dio.get('/api/data');
/// } on DioException catch (e) {
///   final appException = e.toAppException();
///   // 处理应用特定的异常
/// }
/// ```
extension DioExceptionExtension on DioException {
  /// 将Dio异常转换为应用特定的异常
  ///
  /// 根据 [DioException] 的类型和状态码，转换为相应的应用异常。
  /// 这个方法提供了统一的异常转换逻辑，简化了错误处理。
  ///
  /// 返回:
  /// - [Exception] 转换后的应用特定异常
  ///
  /// 示例:
  /// ```dart
  /// try {
  ///   final response = await dio.get('/api/data');
  /// } on DioException catch (e) {
  ///   final appException = e.toAppException();
  ///   if (appException is ServerException) {
  ///     // 处理服务器错误
  ///   } else if (appException is TimeoutException) {
  ///     // 处理超时错误
  ///   }
  /// }
  /// ```
  Exception toAppException() {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          message: '请求超时，请检查网络连接',
          code: StatusCode.TIMEOUT,
          details: {'originalError': toString()},
        );

      case DioExceptionType.badResponse:
        final statusCode = response?.statusCode;
        final message = _getErrorMessageFromResponse(response);

        if (statusCode == 401) {
          return AuthenticationException(
            message: message,
            code: StatusCode.UNAUTHORIZED,
            details: {'statusCode': statusCode},
          );
        } else if (statusCode == 403) {
          return AuthorizationException(
            message: message,
            code: StatusCode.FORBIDDEN,
            details: {'statusCode': statusCode},
          );
        } else if (statusCode == 404) {
          return ServerException(
            message: message,
            code: StatusCode.NOT_FOUND,
            details: {'statusCode': statusCode},
          );
        } else if (statusCode != null && statusCode >= 500) {
          return ServerException(
            message: message,
            code: StatusCode.INTERNAL_SERVER_ERROR,
            details: {'statusCode': statusCode},
          );
        } else {
          return ServerException(
            message: message,
            code: StatusCode.BAD_REQUEST,
            details: {'statusCode': statusCode},
          );
        }

      case DioExceptionType.cancel:
        return NetworkException(
          message: '请求已取消',
          code: StatusCode.CANCELLED,
          details: {'originalError': toString()},
        );

      case DioExceptionType.connectionError:
        return NetworkException(
          message: '网络连接失败，请检查网络设置',
          code: StatusCode.CONNECTION_ERROR,
          details: {'originalError': toString()},
        );

      case DioExceptionType.badCertificate:
        return NetworkException(
          message: '证书验证失败',
          code: StatusCode.BAD_CERTIFICATE,
          details: {'originalError': toString()},
        );

      case DioExceptionType.unknown:
        return NetworkException(
          message: '未知网络错误',
          code: StatusCode.UNKNOWN,
          details: {'originalError': toString()},
        );
    }
  }

  String _getErrorMessageFromResponse(Response<dynamic>? response) {
    if (response?.data is Map<String, dynamic>) {
      final data = response!.data as Map<String, dynamic>;
      return (data['message'] as String?) ??
          (data['error'] as String?) ??
          '请求失败';
    }
    return '请求失败';
  }
}
