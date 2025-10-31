/// 应用配置常量类
///
/// 定义应用的配置常量，包括 API 配置、网络配置、缓存配置、日志配置等。
class AppConfig {
  AppConfig._();

  /// 应用名称（用于展示与日志）
  static const String appName = 'Flutter Enterprise Scaffold';

  /// 应用版本（手动维护或由构建注入）
  static const String appVersion = '1.0.0';

  // API 配置
  /// 接口基础地址（不包含版本）
  static const String baseUrl = 'https://api.example.com';

  /// 接口版本前缀（示例：/v1）
  static const String apiVersion = '/v1';

  /// 连接超时
  static const Duration connectTimeout = Duration(seconds: 30);

  /// 接收超时
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// 发送超时
  static const Duration sendTimeout = Duration(seconds: 30);

  // 网络配置
  /// 最大重试次数
  static const int maxRetryAttempts = 3;

  /// 重试间隔
  static const Duration retryDelay = Duration(seconds: 1);

  // 分页配置
  /// 默认分页大小
  static const int defaultPageSize = 20;

  /// 最大分页大小
  static const int maxPageSize = 100;

  // 缓存配置
  /// 默认缓存过期时间
  static const Duration cacheExpiration = Duration(hours: 24);

  /// 缓存最大体积（字节）
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB

  // 日志配置
  /// 是否启用日志
  static const bool enableLogging = true;

  /// 单个日志文件最大体积（字节）
  static const int maxLogFileSize = 10 * 1024 * 1024; // 10MB

  /// 保留的日志文件数量上限
  static const int maxLogFiles = 5;
}
