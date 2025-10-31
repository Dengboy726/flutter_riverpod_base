import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 加载指示类型
///
/// 定义不同的加载展示样式：
/// - circular: 圆环进度指示
/// - linear: 线性进度指示
/// - dots: 点状动态指示
/// - shimmer: 闪烁骨架屏
enum AppLoadingType {
  /// 圆环进度
  circular,

  /// 线性进度
  linear,

  /// 点状动画
  dots,

  /// 闪烁骨架
  shimmer,
}

/// 通用加载组件
///
/// 支持圆环、线性、点状、闪烁等多种加载样式，可选展示提示信息。
class AppLoadingWidget extends StatelessWidget {
  /// 创建通用加载组件
  const AppLoadingWidget({
    super.key,
    this.type = AppLoadingType.circular,
    this.message,
    this.color,
    this.size,
    this.strokeWidth,
    this.showMessage = true,
  });

  /// 加载样式
  final AppLoadingType type;

  /// 加载提示文案（可选，建议使用本地化传入）
  final String? message;

  /// 主色
  final Color? color;

  /// 组件大小
  final double? size;

  /// 线宽（仅圆环样式生效）
  final double? strokeWidth;

  /// 是否展示提示文案
  final bool showMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final loadingColor = color ?? colorScheme.primary;
    final loadingSize = size ?? 24.sp;
    final loadingStrokeWidth = strokeWidth ?? 2.0;

    Widget loadingWidget;

    switch (type) {
      case AppLoadingType.circular:
        loadingWidget = CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
          strokeWidth: loadingStrokeWidth,
        );
      case AppLoadingType.linear:
        loadingWidget = LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
        );
      case AppLoadingType.dots:
        loadingWidget = _DotsLoadingWidget(
          color: loadingColor,
          size: loadingSize,
        );
      case AppLoadingType.shimmer:
        loadingWidget = _ShimmerLoadingWidget(color: loadingColor);
    }

    if (message != null && showMessage) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: loadingSize,
            height: loadingSize,
            child: loadingWidget,
          ),
          SizedBox(height: 16.h),
          Text(
            message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return SizedBox(
      width: loadingSize,
      height: loadingSize,
      child: loadingWidget,
    );
  }
}

class _DotsLoadingWidget extends StatefulWidget {
  const _DotsLoadingWidget({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  State<_DotsLoadingWidget> createState() => _DotsLoadingWidgetState();
}

class _DotsLoadingWidgetState extends State<_DotsLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _animations = List.generate(
      3,
      (index) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.2,
            0.6 + index * 0.2,
            curve: Curves.easeInOut,
          ),
        ),
      ),
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      3,
      (index) => AnimatedBuilder(
        animation: _animations[index],
        builder: (context, child) => Container(
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          width: widget.size * 0.3,
          height: widget.size * 0.3,
          decoration: BoxDecoration(
            color: widget.color.withOpacity(_animations[index].value),
            shape: BoxShape.circle,
          ),
        ),
      ),
    ),
  );
}

class _ShimmerLoadingWidget extends StatefulWidget {
  const _ShimmerLoadingWidget({required this.color});
  final Color color;

  @override
  State<_ShimmerLoadingWidget> createState() => _ShimmerLoadingWidgetState();
}

class _ShimmerLoadingWidgetState extends State<_ShimmerLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: -1,
      end: 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _animation,
    builder: (context, child) => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.color.withOpacity(0.3),
            widget.color,
            widget.color.withOpacity(0.3),
          ],
          stops: [
            _animation.value - 0.3,
            _animation.value,
            _animation.value + 0.3,
          ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
        ),
        borderRadius: BorderRadius.circular(4.r),
      ),
    ),
  );
}

/// 全屏加载组件
class AppFullScreenLoading extends StatelessWidget {
  /// 创建全屏加载组件
  const AppFullScreenLoading({
    super.key,
    this.message,
    this.backgroundColor,
    this.loadingColor,
  });

  /// 加载提示文案（可选，建议使用本地化传入）
  final String? message;

  /// 背景颜色
  final Color? backgroundColor;

  /// 加载颜色
  final Color? loadingColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ColoredBox(
      color: backgroundColor ?? colorScheme.surface.withOpacity(0.8),
      child: Center(
        child: AppLoadingWidget(
          message: message,
          color: loadingColor,
          size: 32.sp,
        ),
      ),
    );
  }
}

/// 内联加载组件
class AppInlineLoading extends StatelessWidget {
  /// 创建内联加载组件
  const AppInlineLoading({super.key, this.message, this.color, this.size});

  /// 加载提示文案（可选，建议使用本地化传入）
  final String? message;

  /// 主色
  final Color? color;

  /// 组件大小
  final double? size;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      AppLoadingWidget(color: color, size: size ?? 16.sp, showMessage: false),
      if (message != null) ...[
        SizedBox(width: 8.w),
        Text(message!, style: Theme.of(context).textTheme.bodyMedium),
      ],
    ],
  );
}
