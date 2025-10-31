/// UI 常量类
///
/// 定义应用中所有 UI 相关的常量，包括主题配置、动画配置等。
class UIConstants {
  UIConstants._();

  // 主题配置
  /// 全局圆角半径
  static const double borderRadius = 8;

  /// 卡片阴影高度
  static const double cardElevation = 2;

  /// AppBar 阴影高度
  static const double appBarElevation = 0;

  // 动画配置
  /// 短动画时长
  static const Duration shortAnimation = Duration(milliseconds: 200);

  /// 中动画时长
  static const Duration mediumAnimation = Duration(milliseconds: 300);

  /// 长动画时长
  static const Duration longAnimation = Duration(milliseconds: 500);
}
