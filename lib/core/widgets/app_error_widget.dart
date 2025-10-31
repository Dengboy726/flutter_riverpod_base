import 'package:flutter/material.dart';
import 'package:flutter_enterprise_scaffold/core/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_button.dart';

// 枚举值采用全大写下划线命名，符合项目枚举命名规范

/// 错误类型（枚举值使用 UPPER_SNAKE_CASE）
///
/// 用于标识错误的来源与类别，便于组件根据类型展示合适的图标与标题：
/// - NETWORK: 网络连接问题
/// - SERVER: 服务端返回错误
/// - VALIDATION: 输入或参数校验错误
/// - UNKNOWN: 未知或未分类错误
/// - EMPTY: 空数据占位
enum AppErrorType {
  /// 网络连接问题（如断网、超时）
  NETWORK,

  /// 服务端错误（如 5xx）
  SERVER,

  /// 参数/表单校验失败
  VALIDATION,

  /// 未知错误
  UNKNOWN,

  /// 空数据占位
  EMPTY,
}

/// 通用错误展示组件
///
/// 展示错误图标、标题、描述与重试按钮。
class AppErrorWidget extends StatelessWidget {
  /// 创建通用错误展示组件
  const AppErrorWidget({
    required this.message,
    super.key,
    this.type = AppErrorType.UNKNOWN,
    this.onRetry,
    this.retryText,
    this.icon,
    this.showRetryButton = true,
  });

  /// 具体错误描述
  final String message;

  /// 错误类型
  final AppErrorType type;

  /// 重试回调（可为空，按钮将根据 [showRetryButton] 与是否有回调来决定可用性）
  final VoidCallback? onRetry;

  /// 重试按钮文案（为空则使用本地化文案）
  final String? retryText;

  /// 自定义图标（为空则根据错误类型选择）
  final IconData? icon;

  /// 是否显示重试按钮
  final bool showRetryButton;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final errorConfig = _getErrorConfig(colorScheme, l10n);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? errorConfig.icon,
              size: 64.sp,
              color: errorConfig.color,
            ),
            SizedBox(height: 16.h),
            Text(
              errorConfig.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (showRetryButton) ...[
              SizedBox(height: 24.h),
              AppButton(text: retryText ?? l10n.retry, onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }

  _ErrorConfig _getErrorConfig(ColorScheme colorScheme, AppLocalizations l10n) {
    switch (type) {
      case AppErrorType.NETWORK:
        return _ErrorConfig(
          icon: Icons.wifi_off_rounded,
          color: colorScheme.error,
          title: l10n.networkError,
        );
      case AppErrorType.SERVER:
        return _ErrorConfig(
          icon: Icons.error_outline_rounded,
          color: colorScheme.error,
          title: l10n.serverError,
        );
      case AppErrorType.VALIDATION:
        return _ErrorConfig(
          icon: Icons.warning_amber_rounded,
          color: Colors.orange,
          title: l10n.validationError,
        );
      case AppErrorType.EMPTY:
        return _ErrorConfig(
          icon: Icons.inbox_rounded,
          color: colorScheme.onSurfaceVariant,
          title: l10n.noData,
        );
      case AppErrorType.UNKNOWN:
        return _ErrorConfig(
          icon: Icons.error_outline_rounded,
          color: colorScheme.error,
          title: l10n.unknownError,
        );
    }
  }
}

class _ErrorConfig {
  _ErrorConfig({required this.icon, required this.color, required this.title});
  final IconData icon;
  final Color color;
  final String title;
}

/// 网络错误组件
class AppNetworkErrorWidget extends StatelessWidget {
  /// 创建网络错误组件
  const AppNetworkErrorWidget({super.key, this.message, this.onRetry});

  /// 错误描述（为空时使用本地化的网络错误文案）
  final String? message;

  /// 重试回调
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppErrorWidget(
      message: message ?? l10n.networkError,
      type: AppErrorType.NETWORK,
      onRetry: onRetry,
      retryText: l10n.retry,
    );
  }
}

/// 服务器错误组件
class AppServerErrorWidget extends StatelessWidget {
  /// 创建服务器错误组件
  const AppServerErrorWidget({super.key, this.message, this.onRetry});

  /// 错误描述（为空时使用本地化的服务器错误文案）
  final String? message;

  /// 重试回调
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppErrorWidget(
      message: message ?? l10n.serverError,
      type: AppErrorType.SERVER,
      onRetry: onRetry,
      retryText: l10n.refresh,
    );
  }
}

/// 空数据组件
class AppEmptyWidget extends StatelessWidget {
  /// 创建空数据组件
  const AppEmptyWidget({
    super.key,
    this.message,
    this.onRefresh,
    this.refreshText,
  });

  /// 空数据提示文案
  final String? message;

  /// 刷新回调
  final VoidCallback? onRefresh;

  /// 刷新按钮文案
  final String? refreshText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppErrorWidget(
      message: message ?? l10n.noData,
      type: AppErrorType.EMPTY,
      onRetry: onRefresh,
      retryText: refreshText ?? l10n.refresh,
      showRetryButton: onRefresh != null,
    );
  }
}

/// 验证错误组件
class AppValidationErrorWidget extends StatelessWidget {
  /// 创建验证错误组件
  const AppValidationErrorWidget({
    required this.message,
    super.key,
    this.onRetry,
  });

  /// 错误描述
  final String message;

  /// 重试回调
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppErrorWidget(
      message: message,
      type: AppErrorType.VALIDATION,
      onRetry: onRetry,
      retryText: l10n.retry,
    );
  }
}
