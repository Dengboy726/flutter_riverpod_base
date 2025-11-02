/// 路由常量类
///
/// 定义应用中所有路由路径和路由名称，便于统一管理和维护。
/// 使用常量可以避免硬编码路由路径，减少拼写错误，提高代码可维护性。
class RouteConstants {
  RouteConstants._();

  // ==================== 路由路径 ====================

  /// 启动页路由路径
  static const String splash = '/splash';

  /// 登录页路由路径
  static const String login = '/login';

  /// 注册页路由路径
  static const String register = '/register';

  /// 登录确认页路由路径
  static const String loginConfirm = '/login/confirm';

  /// 首页路由路径
  static const String home = '/home';

  /// 个人资料页路由路径（相对于 home 的子路由）
  static const String profile = '/home/profile';

  /// 设置页路由路径（相对于 home 的子路由）
  static const String settings = '/home/settings';

  // ==================== 路由名称 ====================

  /// 启动页路由名称
  static const String splashName = 'splash';

  /// 登录页路由名称
  static const String loginName = 'login';

  /// 注册页路由名称
  static const String registerName = 'register';

  /// 登录确认页路由名称
  static const String loginConfirmName = 'loginConfirm';

  /// 首页路由名称
  static const String homeName = 'home';

  /// 个人资料页路由名称
  static const String profileName = 'profile';

  /// 设置页路由名称
  static const String settingsName = 'settings';

  // ==================== 辅助方法 ====================

  /// 构建带参数的路径（用于需要传递参数的路由）
  ///
  /// 参数:
  /// - [basePath] 基础路径
  /// - [params] 路径参数键值对
  ///
  /// 返回:
  /// - [String] 构建后的完整路径
  ///
  /// 示例:
  /// ```dart
  /// RouteConstants.buildPath('/user', {'id': '123'}) // '/user/123'
  /// ```
  static String buildPath(String basePath, Map<String, String> params) {
    final buffer = StringBuffer(basePath);
    if (params.isNotEmpty) {
      buffer.write('/${params.values.join('/')}');
    }
    return buffer.toString();
  }
}
