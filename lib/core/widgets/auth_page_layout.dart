import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 认证页面布局组件
///
/// 提供统一的认证页面布局结构，包含顶部图片区域和白色卡片区域。
/// 白色卡片的内容通过 [child] 参数传入。
///
/// 使用示例:
/// ```dart
/// AuthPageLayout(
///   child: Column(
///     children: [
///       // 表单内容
///     ],
///   ),
/// )
/// ```
class AuthPageLayout extends StatelessWidget {
  /// 创建认证页面布局组件
  const AuthPageLayout({required this.child, super.key, this.cardPadding});

  /// 白色卡片内容区域的子组件
  final Widget child;

  /// 白色卡片的内边距，默认为 horizontal: 32.w, vertical: 30.h
  final EdgeInsetsGeometry? cardPadding;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      // 顶部图片区域
      _buildTopImageArea(),

      // 白色卡片内容区域
      _buildContentCard(),
    ],
  );

  /// 构建顶部图片区域
  ///
  /// 显示认证页面的装饰性图片区域。
  /// SafeArea 已处理状态栏，从 top: 0 开始，margin: top: 10, bottom: 20, left: 30, right: 30，高度为 170.h，图片向上溢出 28.21.h。
  Widget _buildTopImageArea() => Positioned(
    left: 0,
    top: 0, // SafeArea 已处理状态栏
    right: 0,
    child: Container(
      width: double.infinity,
      height: 170.h,
      margin: const EdgeInsets.only(top: 10, bottom: 20, left: 30, right: 30),
      child: Stack(
        children: [
          Positioned(
            left: 30.62.w,
            top: -28.21.h,
            child: Image.asset(
              'assets/images/IllustratorDumb.png',
              width: 320.w,
              height: 220.42.h,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    ),
  );

  /// 构建白色卡片内容区域
  ///
  /// 包含认证表单的所有内容。
  /// 位置从顶部 200.h (10 margin + 170 图片区域高度 + 20 margin) 开始，底部对齐，圆角 30.r。
  Widget _buildContentCard() => Positioned(
    left: 0,
    top: 200.h, // 10 (margin top) + 170 (图片区域高度) + 20 (margin bottom)
    right: 0,
    bottom: 0, // 填充到底部
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: SingleChildScrollView(
        padding:
            cardPadding ??
            EdgeInsets.symmetric(horizontal: 32.w, vertical: 30.h),
        child: child,
      ),
    ),
  );
}
