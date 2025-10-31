/// 状态码枚举
///
/// 定义了应用中使用的所有状态码，包括HTTP状态码和自定义错误码。
/// 这个枚举提供了统一的错误码管理，确保错误处理的一致性。
///
/// 使用示例:
/// ```dart
/// // 创建异常时使用状态码
/// throw ServerException(
///   message: '服务器错误',
///   code: StatusCode.internalServerError,
/// );
///
/// // 检查状态码类型
/// if (statusCode.isRetryable) {
///   // 执行重试逻辑
/// }
/// ```
enum StatusCode {
  // HTTP 成功状态码
  /// 请求成功
  OK(200),

  /// 创建成功
  CREATED(201),

  /// 请求已接受
  ACCEPTED(202),

  /// 无内容
  NO_CONTENT(204),

  /// 请求参数错误
  BAD_REQUEST(400),

  /// 未授权
  UNAUTHORIZED(401),

  /// 禁止访问
  FORBIDDEN(403),

  /// 资源不存在
  NOT_FOUND(404),

  /// 方法不允许
  METHOD_NOT_ALLOWED(405),

  /// 资源冲突
  CONFLICT(409),

  /// 请求参数验证失败
  UNPROCESSABLE_ENTITY(422),

  /// 请求过于频繁
  TOO_MANY_REQUESTS(429),

  /// 服务器内部错误
  INTERNAL_SERVER_ERROR(500),

  /// 网关错误
  BAD_GATEWAY(502),

  /// 服务不可用
  SERVICE_UNAVAILABLE(503),

  /// 网关超时
  GATEWAY_TIMEOUT(504),

  /// 未知错误
  UNKNOWN(-1),

  /// 请求已取消
  CANCELLED(-2),

  /// 网络连接错误
  CONNECTION_ERROR(-3),

  /// 证书验证失败
  BAD_CERTIFICATE(-4),

  /// 请求超时
  TIMEOUT(-5),

  /// 缓存错误
  CACHE_ERROR(-6),

  /// 文件操作错误
  FILE_ERROR(-7),

  /// 数据验证错误
  VALIDATION_ERROR(-8);

  /// 状态码构造函数
  ///
  /// 参数:
  /// - [value] 状态码的整数值
  const StatusCode(this.value);

  /// 状态码的整数值
  ///
  /// 对于HTTP状态码，使用标准的HTTP状态码值（如200、404、500等）
  /// 对于自定义错误码，使用负数值（如-1、-2等）以区别于HTTP状态码
  final int value;

  /// 从整数值创建状态码
  ///
  /// 根据提供的整数值查找对应的状态码枚举值。
  /// 如果找不到匹配的状态码，则返回 [StatusCode.UNKNOWN]。
  ///
  /// 参数:
  /// - [value] 要查找的整数值
  ///
  /// 返回:
  /// - [StatusCode] 对应的状态码枚举值，如果未找到则返回 [StatusCode.UNKNOWN]
  ///
  /// 示例:
  /// ```dart
  /// final statusCode = StatusCode.fromValue(404); // 返回 StatusCode.NOT_FOUND
  /// final unknownCode = StatusCode.fromValue(999); // 返回 StatusCode.UNKNOWN
  /// ```
  static StatusCode fromValue(int value) {
    for (final statusCode in StatusCode.values) {
      if (statusCode.value == value) {
        return statusCode;
      }
    }
    return StatusCode.UNKNOWN;
  }

  /// 是否为成功状态码
  bool get isSuccess => value >= 200 && value < 300;

  /// 是否为客户端错误
  bool get isClientError => value >= 400 && value < 500;

  /// 是否为服务器错误
  bool get isServerError => value >= 500 && value < 600;

  /// 是否为网络错误
  bool get isNetworkError => value < 0;

  /// 是否为可重试的错误
  bool get isRetryable {
    if (isNetworkError) {
      return true;
    }
    if (isServerError) {
      return true;
    }
    if (value == 408 || value == 429) {
      return true; // 超时和限流
    }
    return false;
  }

  /// 获取用户友好的描述
  String get description {
    switch (this) {
      case StatusCode.OK:
        return '请求成功';
      case StatusCode.CREATED:
        return '创建成功';
      case StatusCode.ACCEPTED:
        return '请求已接受';
      case StatusCode.NO_CONTENT:
        return '无内容';
      case StatusCode.BAD_REQUEST:
        return '请求参数错误';
      case StatusCode.UNAUTHORIZED:
        return '未授权，请重新登录';
      case StatusCode.FORBIDDEN:
        return '禁止访问';
      case StatusCode.NOT_FOUND:
        return '资源不存在';
      case StatusCode.METHOD_NOT_ALLOWED:
        return '方法不允许';
      case StatusCode.CONFLICT:
        return '资源冲突';
      case StatusCode.UNPROCESSABLE_ENTITY:
        return '请求参数验证失败';
      case StatusCode.TOO_MANY_REQUESTS:
        return '请求过于频繁';
      case StatusCode.INTERNAL_SERVER_ERROR:
        return '服务器内部错误';
      case StatusCode.BAD_GATEWAY:
        return '网关错误';
      case StatusCode.SERVICE_UNAVAILABLE:
        return '服务不可用';
      case StatusCode.GATEWAY_TIMEOUT:
        return '网关超时';
      case StatusCode.UNKNOWN:
        return '未知错误';
      case StatusCode.CANCELLED:
        return '请求已取消';
      case StatusCode.CONNECTION_ERROR:
        return '网络连接失败';
      case StatusCode.BAD_CERTIFICATE:
        return '证书验证失败';
      case StatusCode.TIMEOUT:
        return '请求超时';
      case StatusCode.CACHE_ERROR:
        return '缓存错误';
      case StatusCode.FILE_ERROR:
        return '文件操作错误';
      case StatusCode.VALIDATION_ERROR:
        return '数据验证错误';
    }
  }
}
