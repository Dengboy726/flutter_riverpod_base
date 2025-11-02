import 'api_endpoints.dart';
import 'app_config.dart';
import 'file_constants.dart';
import 'route_constants.dart';
import 'storage_keys.dart';
import 'ui_constants.dart';
import 'validation_constants.dart';

// 导出所有常量类（必须在类声明之前）
export 'api_endpoints.dart' show ApiEndpoints;
export 'app_config.dart' show AppConfig;
export 'file_constants.dart' show FileConstants;
export 'route_constants.dart' show RouteConstants;
export 'storage_keys.dart' show StorageKeys;
export 'ui_constants.dart' show UIConstants;
export 'validation_constants.dart' show ValidationConstants;

/// 应用常量类
///
/// 定义应用中所有常量，便于统一管理和维护。
/// 为了保持向后兼容性，这个类重新导出所有拆分的常量类。
/// 建议直接使用各个专门的常量类：
/// - [StorageKeys] - 存储键
/// - [AppConfig] - 应用配置
/// - [UIConstants] - UI 常量
/// - [ValidationConstants] - 验证常量
/// - [FileConstants] - 文件常量
/// - [RouteConstants] - 路由常量
/// - [ApiEndpoints] - API 端点
class AppConstants {
  AppConstants._();

  /// 应用名称（用于展示与日志）
  static const String appName = AppConfig.appName;

  /// 应用版本（手动维护或由构建注入）
  static const String appVersion = AppConfig.appVersion;

  // 存储键
  /// 认证令牌持久化键（统一存储，包含 accessToken、refreshToken 和 expiresAt）
  static const String tokensKey = StorageKeys.tokensKey;

  /// 用户信息持久化键
  static const String userKey = StorageKeys.userKey;

  /// 主题模式持久化键
  static const String themeKey = StorageKeys.themeKey;

  /// 语言代码持久化键
  static const String languageKey = StorageKeys.languageKey;

  // API 配置
  /// 接口基础地址（不包含版本）
  static const String baseUrl = AppConfig.baseUrl;

  /// 接口版本前缀（示例：/v1）
  static const String apiVersion = AppConfig.apiVersion;

  /// 刷新令牌接口路径（拼接 baseUrl + apiVersion）
  static const String refreshToken = ApiEndpoints.refreshToken;

  /// 连接超时
  static const Duration connectTimeout = AppConfig.connectTimeout;

  /// 接收超时
  static const Duration receiveTimeout = AppConfig.receiveTimeout;

  /// 发送超时
  static const Duration sendTimeout = AppConfig.sendTimeout;

  // 分页配置
  /// 默认分页大小
  static const int defaultPageSize = AppConfig.defaultPageSize;

  /// 最大分页大小
  static const int maxPageSize = AppConfig.maxPageSize;

  // 网络配置
  /// 最大重试次数
  static const int maxRetryAttempts = AppConfig.maxRetryAttempts;

  /// 重试间隔
  static const Duration retryDelay = AppConfig.retryDelay;

  // 缓存配置
  /// 默认缓存过期时间
  static const Duration cacheExpiration = AppConfig.cacheExpiration;

  /// 缓存最大体积（字节）
  static const int maxCacheSize = AppConfig.maxCacheSize;

  // 日志配置
  /// 是否启用日志
  static const bool enableLogging = AppConfig.enableLogging;

  /// 单个日志文件最大体积（字节）
  static const int maxLogFileSize = AppConfig.maxLogFileSize;

  /// 保留的日志文件数量上限
  static const int maxLogFiles = AppConfig.maxLogFiles;

  // 主题配置
  /// 全局圆角半径
  static const double borderRadius = UIConstants.borderRadius;

  /// 卡片阴影高度
  static const double cardElevation = UIConstants.cardElevation;

  /// AppBar 阴影高度
  static const double appBarElevation = UIConstants.appBarElevation;

  // 动画配置
  /// 短动画时长
  static const Duration shortAnimation = UIConstants.shortAnimation;

  /// 中动画时长
  static const Duration mediumAnimation = UIConstants.mediumAnimation;

  /// 长动画时长
  static const Duration longAnimation = UIConstants.longAnimation;

  // 验证配置
  /// 最小密码长度
  static const int minPasswordLength = ValidationConstants.minPasswordLength;

  /// 最大密码长度
  static const int maxPasswordLength = ValidationConstants.maxPasswordLength;

  /// 最小用户名长度
  static const int minUsernameLength = ValidationConstants.minUsernameLength;

  /// 最大用户名长度
  static const int maxUsernameLength = ValidationConstants.maxUsernameLength;

  // 文件上传配置
  /// 最大上传文件大小（字节）
  static const int maxFileSize = FileConstants.maxFileSize;

  /// 允许的图片类型扩展名
  static const List<String> allowedImageTypes = FileConstants.allowedImageTypes;

  /// 允许的文档类型扩展名
  static const List<String> allowedDocumentTypes =
      FileConstants.allowedDocumentTypes;
}
