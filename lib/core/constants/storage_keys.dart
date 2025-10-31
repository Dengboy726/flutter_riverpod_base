/// 存储键常量类
///
/// 定义应用中所有本地存储键的常量，便于统一管理和维护。
/// 这些键用于 SharedPreferences 等本地存储系统。
class StorageKeys {
  StorageKeys._();

  // 认证相关
  /// 认证令牌持久化键（统一存储，包含 accessToken、refreshToken 和 expiresAt）
  ///
  /// 使用 JSON 格式存储 AuthTokens 对象，包含完整的令牌信息。
  /// 这是推荐的存储方式，建议统一使用此键。
  ///
  /// 格式: { "accessToken": "...", "refreshToken": "...", "expiresAt": "...", "tokenType": "Bearer" }
  static const String tokensKey = 'tokens';

  // 用户相关
  /// 用户信息持久化键
  static const String userKey = 'user_data';

  // 应用设置相关
  /// 主题模式持久化键
  static const String themeKey = 'theme_mode';

  /// 语言代码持久化键
  static const String languageKey = 'language_code';
}
