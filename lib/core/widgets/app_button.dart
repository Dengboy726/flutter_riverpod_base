import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 按钮类型
enum AppButtonType {
  /// 主按钮
  primary,

  /// 次按钮
  secondary,

  /// 轮廓按钮
  outline,

  /// 文本按钮
  text,

  /// 危险按钮
  danger,
}

/// 按钮尺寸
enum AppButtonSize {
  /// 小按钮
  small,

  /// 中按钮
  medium,

  /// 大按钮
  large,
}

/// 通用应用按钮组件
///
/// 支持不同类型与尺寸、可加载状态、可自定义图标与样式。
class AppButton extends StatelessWidget {
  /// 创建通用应用按钮组件
  const AppButton({
    required this.text,
    super.key,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.padding,
    this.child,
  });

  /// 文本内容（当 [child] 为空时生效）
  final String text;

  /// 点击回调
  final VoidCallback? onPressed;

  /// 按钮类型
  final AppButtonType type;

  /// 按钮尺寸
  final AppButtonSize size;

  /// 是否显示加载中
  final bool isLoading;

  /// 是否占满整行
  final bool isFullWidth;

  /// 可选的前置图标
  final IconData? icon;

  /// 自定义背景颜色
  final Color? backgroundColor;

  /// 自定义文字颜色
  final Color? textColor;

  /// 圆角半径
  final double? borderRadius;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 自定义子组件（优先于 [text]）
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final buttonStyle = _getButtonStyle(context, colorScheme);
    final textStyle = _getTextStyle(context, colorScheme);
    final buttonPadding = _getPadding();
    final buttonBorderRadius = borderRadius ?? 8.0;

    final buttonChild =
        child ??
        Row(
          mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) ...[
              SizedBox(
                width: _getIconSize(),
                height: _getIconSize(),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getTextColor(colorScheme),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
            ] else if (icon != null) ...[
              Icon(
                icon,
                size: _getIconSize(),
                color: _getTextColor(colorScheme),
              ),
              SizedBox(width: 8.w),
            ],
            Text(text, style: textStyle),
          ],
        );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle.copyWith(
          backgroundColor: WidgetStateProperty.all(
            _getBackgroundColor(colorScheme),
          ),
          foregroundColor: WidgetStateProperty.all(_getTextColor(colorScheme)),
          padding: WidgetStateProperty.all(buttonPadding),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonBorderRadius),
            ),
          ),
        ),
        child: buttonChild,
      ),
    );
  }

  ButtonStyle _getButtonStyle(BuildContext context, ColorScheme colorScheme) {
    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton.styleFrom(
          elevation: 2,
          shadowColor: colorScheme.primary.withOpacity(0.3),
        );
      case AppButtonType.secondary:
        return ElevatedButton.styleFrom(
          elevation: 1,
          shadowColor: colorScheme.secondary.withOpacity(0.3),
        );
      case AppButtonType.outline:
        return OutlinedButton.styleFrom(elevation: 0);
      case AppButtonType.text:
        return TextButton.styleFrom(elevation: 0);
      case AppButtonType.danger:
        return ElevatedButton.styleFrom(
          elevation: 2,
          shadowColor: colorScheme.error.withOpacity(0.3),
        );
    }
  }

  TextStyle _getTextStyle(BuildContext context, ColorScheme colorScheme) {
    final baseStyle = _getBaseTextStyle(context);

    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.secondary:
      case AppButtonType.danger:
        return baseStyle.copyWith(
          color: _getTextColor(colorScheme),
          fontWeight: FontWeight.w600,
        );
      case AppButtonType.outline:
        return baseStyle.copyWith(
          color: _getTextColor(colorScheme),
          fontWeight: FontWeight.w500,
        );
      case AppButtonType.text:
        return baseStyle.copyWith(
          color: _getTextColor(colorScheme),
          fontWeight: FontWeight.w500,
        );
    }
  }

  TextStyle _getBaseTextStyle(BuildContext context) {
    switch (size) {
      case AppButtonSize.small:
        return TextStyle(fontSize: 12.sp);
      case AppButtonSize.medium:
        return TextStyle(fontSize: 14.sp);
      case AppButtonSize.large:
        return TextStyle(fontSize: 16.sp);
    }
  }

  EdgeInsetsGeometry _getPadding() {
    if (padding != null) {
      return padding!;
    }

    switch (size) {
      case AppButtonSize.small:
        return EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h);
      case AppButtonSize.medium:
        return EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h);
      case AppButtonSize.large:
        return EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h);
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 14.sp;
      case AppButtonSize.medium:
        return 16.sp;
      case AppButtonSize.large:
        return 18.sp;
    }
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    if (backgroundColor != null) {
      return backgroundColor!;
    }

    switch (type) {
      case AppButtonType.primary:
        return colorScheme.primary;
      case AppButtonType.secondary:
        return colorScheme.secondary;
      case AppButtonType.outline:
      case AppButtonType.text:
        return Colors.transparent;
      case AppButtonType.danger:
        return colorScheme.error;
    }
  }

  Color _getTextColor(ColorScheme colorScheme) {
    if (textColor != null) {
      return textColor!;
    }

    switch (type) {
      case AppButtonType.primary:
        return colorScheme.onPrimary;
      case AppButtonType.secondary:
        return colorScheme.onSecondary;
      case AppButtonType.outline:
        return colorScheme.primary;
      case AppButtonType.text:
        return colorScheme.primary;
      case AppButtonType.danger:
        return colorScheme.onError;
    }
  }
}
