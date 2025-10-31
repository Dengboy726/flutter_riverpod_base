/// 验证常量类
///
/// 定义应用中所有数据验证相关的常量，包括密码长度、用户名长度等。
class ValidationConstants {
  ValidationConstants._();

  // 密码验证
  /// 最小密码长度
  static const int minPasswordLength = 8;

  /// 最大密码长度
  static const int maxPasswordLength = 128;

  // 用户名验证
  /// 最小用户名长度
  static const int minUsernameLength = 3;

  /// 最大用户名长度
  static const int maxUsernameLength = 50;
}
