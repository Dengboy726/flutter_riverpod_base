import 'package:equatable/equatable.dart';
import 'status_codes.dart';

/// 失败类
///
/// 当操作失败时抛出的异常。
/// 通常用于网络请求、数据操作等场景。
///
/// 使用场景:
/// - 网络请求失败
/// - 数据操作失败
/// - 文件操作失败
/// - 认证失败
/// - 授权失败
/// - 数据验证失败
/// - 缓存失败
/// - 文件操作失败
/// - 未知错误
///
/// 示例:
/// ```dart
/// throw Failure(
///   message: '网络请求失败',
///   code: StatusCode.NETWORK_ERROR,
///   details: {'statusCode': 404},
/// );
/// ```
abstract class Failure extends Equatable {
  /// 创建失败实例
  const Failure({required this.message, this.code, this.details});

  /// 错误消息
  ///
  /// 描述具体的错误信息，通常来自操作的错误响应
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
  List<Object?> get props => [message, code, details];
}

/// 网络失败
///
/// 当网络请求失败时抛出的异常。
/// 通常用于网络连接、请求超时等情况。
///
/// 使用场景:
/// - 网络连接失败
/// - 请求超时
/// - DNS解析失败

/// 创建网络失败实例
///
/// 参数:
/// - [message] 错误消息，描述具体的错误信息
/// - [code] 状态码，用于标识错误类型，可选
/// - [details] 额外的错误详情，包含调试信息，可选
class NetworkFailure extends Failure {
  /// 创建网络失败实例
  ///
  /// 参数:
  /// - [message] 错误消息，描述具体的错误信息
  /// - [code] 状态码，用于标识错误类型，可选
  /// - [details] 额外的错误详情，包含调试信息，可选
  const NetworkFailure({required super.message, super.code, super.details});
}

/// 服务器失败
///
/// 当服务器返回错误响应时抛出的异常。
/// 通常用于服务器处理请求时发生错误的情况。
///
/// 使用场景:
/// - 服务器返回错误响应
/// - 服务器处理请求时发生错误
class ServerFailure extends Failure {
  /// 创建服务器失败实例
  ///
  /// 参数:
  /// - [message] 错误消息，描述具体的错误信息
  /// - [code] 状态码，用于标识错误类型，可选
  /// - [details] 额外的错误详情，包含调试信息，可选
  const ServerFailure({required super.message, super.code, super.details});
}

/// 超时失败
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
/// 创建超时失败实例
///
/// 参数:
/// - [message] 错误消息，描述具体的错误信息
/// - [code] 状态码，用于标识错误类型，可选
/// - [details] 额外的错误详情，包含调试信息，可选
class TimeoutFailure extends Failure {
  /// 创建超时失败实例
  ///
  /// 参数:
  /// - [message] 错误消息，描述具体的错误信息
  /// - [code] 状态码，用于标识错误类型，可选
  /// - [details] 额外的错误详情，包含调试信息，可选
  const TimeoutFailure({required super.message, super.code, super.details});
}

/// 认证失败
///
/// 当认证失败时抛出的异常。
/// 通常用于认证、授权等场景。
///
/// 使用场景:
/// - 认证失败
/// - 授权失败
///
/// 创建认证失败实例
///
/// 参数:
/// - [message] 错误消息，描述具体的错误信息
/// - [code] 状态码，用于标识错误类型，可选
/// - [details] 额外的错误详情，包含调试信息，可选
class AuthenticationFailure extends Failure {
  /// 创建认证失败实例
  ///
  /// 参数:
  /// - [message] 错误消息，描述具体的错误信息
  /// - [code] 状态码，用于标识错误类型，可选
  /// - [details] 额外的错误详情，包含调试信息，可选
  const AuthenticationFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// 授权失败
///
/// 当授权失败时抛出的异常。
/// 通常用于授权、权限等场景。
///
/// 使用场景:
/// - 授权失败
/// - 权限不足
///
/// 创建授权失败实例
///
/// 参数:
/// - [message] 错误消息，描述具体的错误信息
/// - [code] 状态码，用于标识错误类型，可选
/// - [details] 额外的错误详情，包含调试信息，可选
class AuthorizationFailure extends Failure {
  /// 创建授权失败实例
  ///
  /// 参数:
  /// - [message] 错误消息，描述具体的错误信息
  /// - [code] 状态码，用于标识错误类型，可选
  /// - [details] 额外的错误详情，包含调试信息，可选
  const AuthorizationFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// 验证失败
///
/// 当数据验证失败时抛出的异常。
/// 通常用于数据验证、表单验证等场景。
///
/// 使用场景:
/// - 数据验证失败
/// - 表单验证失败
/// - 参数验证失败

/// 创建验证失败实例
///
/// 参数:
/// - [message] 错误消息，描述具体的错误信息
/// - [code] 状态码，用于标识错误类型，可选
/// - [details] 额外的错误详情，包含调试信息，可选
class ValidationFailure extends Failure {
  /// 创建验证失败实例
  ///
  /// 参数:
  /// - [message] 错误消息，描述具体的错误信息
  /// - [code] 状态码，用于标识错误类型，可选
  /// - [details] 额外的错误详情，包含调试信息，可选
  const ValidationFailure({required super.message, super.code, super.details});
}

/// 缓存失败
///
/// 当缓存操作失败时抛出的异常。
/// 通常用于缓存读取、写入或删除操作失败的情况。
///
/// 使用场景:
/// - 缓存读取失败
/// - 缓存写入失败
/// - 缓存删除失败
///
/// 创建缓存失败实例
///
/// 参数:
/// - [message] 错误消息，描述具体的错误信息
/// - [code] 状态码，用于标识错误类型，可选
/// - [details] 额外的错误详情，包含调试信息，可选
class CacheFailure extends Failure {
  /// 创建缓存失败实例
  ///
  /// 参数:
  /// - [message] 错误消息，描述具体的错误信息
  /// - [code] 状态码，用于标识错误类型，可选
  /// - [details] 额外的错误详情，包含调试信息，可选
  const CacheFailure({required super.message, super.code, super.details});
}

/// 未找到失败
///
/// 当资源未找到时抛出的异常。
/// 通常用于资源不存在的情况。
///
/// 使用场景:
/// - 资源未找到
/// - 资源不存在
/// - 资源未找到

/// 创建未找到失败实例
///
/// 参数:
/// - [message] 错误消息，描述具体的错误信息
/// - [code] 状态码，用于标识错误类型，可选
/// - [details] 额外的错误详情，包含调试信息，可选
class NotFoundFailure extends Failure {
  /// 创建未找到失败实例
  ///
  /// 参数:
  /// - [message] 错误消息，描述具体的错误信息
  /// - [code] 状态码，用于标识错误类型，可选
  /// - [details] 额外的错误详情，包含调试信息，可选
  const NotFoundFailure({required super.message, super.code, super.details});
}

/// 文件失败
///
/// 当文件操作失败时抛出的异常。
/// 通常用于文件读取、写入或删除操作失败的情况。
///
/// 使用场景:
/// - 文件读取失败
/// - 文件写入失败
/// - 文件删除失败
///
/// 创建文件失败实例
///
/// 参数:
/// - [message] 错误消息，描述具体的错误信息
/// - [code] 状态码，用于标识错误类型，可选
/// - [details] 额外的错误详情，包含调试信息，可选
class FileFailure extends Failure {
  /// 创建文件失败实例
  ///
  /// 参数:
  /// - [message] 错误消息，描述具体的错误信息
  /// - [code] 状态码，用于标识错误类型，可选
  /// - [details] 额外的错误详情，包含调试信息，可选
  const FileFailure({required super.message, super.code, super.details});
}

/// 未知失败
///
/// 当未知错误发生时抛出的异常。
/// 通常用于未知的错误情况。
///
/// 使用场景:
/// - 未知错误
/// - 未知错误
/// - 未知错误

/// 创建未知失败实例
///
/// 参数:
/// - [message] 错误消息，描述具体的错误信息
/// - [code] 状态码，用于标识错误类型，可选
/// - [details] 额外的错误详情，包含调试信息，可选
class UnknownFailure extends Failure {
  /// 创建未知失败实例
  ///
  /// 参数:
  /// - [message] 错误消息，描述具体的错误信息
  /// - [code] 状态码，用于标识错误类型，可选
  /// - [details] 额外的错误详情，包含调试信息，可选
  const UnknownFailure({required super.message, super.code, super.details});
}
