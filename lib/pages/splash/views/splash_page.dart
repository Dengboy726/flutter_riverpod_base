import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/auth/providers/auth_provider.dart';

/// 启动页面
///
/// DumbChat-2025 设计稿还原
/// 设计稿链接: https://www.figma.com/design/1FcwsslmpdOy5ouD0hA1fP/DumbChat-2025?node-id=503-7283
///
/// 注意：以下实现为基础结构，请根据 Figma 设计稿中的实际标注值调整：
/// - 所有尺寸、间距值（请使用设计稿中的精确值）
/// - 所有颜色值（请使用设计稿中的精确颜色）
/// - 字体大小、粗细、颜色（请使用设计稿中的字体规范）
/// - 布局结构（请严格按照设计稿的布局）
/// - 动画效果（仅实现设计稿中明确要求的动画）
class SplashPage extends ConsumerStatefulWidget {
  /// 创建启动页面实例
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  /// 设置动画
  ///
  /// 注意：请根据设计稿调整以下内容：
  /// - 动画时长（请使用设计稿中的精确值）
  /// - 动画类型（淡入、缩放、移动等，仅实现设计稿中要求的动画）
  /// - 动画曲线（easeInOut、easeOut 等，请使用设计稿中的曲线）
  void _setupAnimations() {
    // TODO: 根据设计稿调整动画时长（请使用设计稿中的精确值，单位：毫秒）
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000), // 请替换为设计稿中的精确值
      vsync: this,
    );

    // TODO: 根据设计稿调整动画
    // 如果设计稿中没有动画，请删除动画相关代码
    // 如果设计稿中有其他类型的动画（如移动、旋转等），请根据设计稿实现

    _animationController.forward();
  }

  /// 初始化应用
  Future<void> _initializeApp() async {
    // TODO: 根据设计稿调整初始化时长（请使用设计稿中的精确值）
    // 如果设计稿中没有指定时长，请根据实际需求调整
    await Future<void>.delayed(const Duration(milliseconds: 1500)); // 请替换为设计稿中的精确值

    // 检查认证状态
    final authState = ref.read(authNotifierProvider);
    if (authState.isInitialized) {
      _navigateToNextPage();
    }
  }

  void _navigateToNextPage() {
    // 导航逻辑由路由系统处理
    // 这里不需要手动导航，因为路由系统会根据认证状态自动重定向
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: 根据设计稿调整背景色（请使用设计稿中的精确颜色值）
      // 示例：backgroundColor: Color(0xFF2196F3)
      backgroundColor: const Color(0xFFFFFFFF), // 请替换为设计稿中的精确值
      body: SafeArea(
        // TODO: 根据设计稿决定是否需要 SafeArea
        // 如果设计稿中内容延伸到状态栏下方，请移除 SafeArea
        child: _buildContent(),
      ),
    );
  }

  /// 构建主要内容
  ///
  /// 注意：请根据设计稿精确调整布局结构：
  /// - 如果是居中布局，使用 Center
  /// - 如果是顶部布局，使用 Column + MainAxisAlignment.start
  /// - 严格按照设计稿的布局结构，不添加设计稿中没有的元素
  Widget _buildContent() {
    // TODO: 根据设计稿调整布局方式
    // 当前为基础结构，请根据设计稿调整

    // 如果设计稿是居中布局
    return Center(
      child: _buildMainContent(),
    );

    // 如果设计稿是顶部对齐布局，使用：
    // return Column(
    //   children: [
    //     // 根据设计稿调整顶部间距
    //     SizedBox(height: 100.h), // 请使用设计稿中的精确值
    //     _buildMainContent(),
    //   ],
    // );
  }

  /// 构建主要内容区域
  Widget _buildMainContent() {
    // TODO: 如果设计稿中有动画，请使用 AnimatedBuilder 包裹内容
    // 如果设计稿中没有动画，请删除 AnimatedBuilder

    // 当前实现包含基础动画结构，如果设计稿中没有动画，请删除
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        // TODO: 根据设计稿实现动画效果
        // 示例：FadeTransition、ScaleTransition、SlideTransition 等
        // 仅实现设计稿中明确要求的动画效果

        // 如果设计稿中只需要淡入动画：
        // return FadeTransition(
        //   opacity: _fadeAnimation,
        //   child: child!,
        // );

        // 如果设计稿中需要缩放动画：
        // return ScaleTransition(
        //   scale: _scaleAnimation,
        //   child: child!,
        // );

        // 如果设计稿中没有动画，直接返回 child
        return child!;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // TODO: 根据设计稿调整对齐方式
        // mainAxisAlignment: MainAxisAlignment.center, // 居中
        // mainAxisAlignment: MainAxisAlignment.start, // 顶部对齐
        children: [
          // Logo/图标区域
          _buildLogo(),

          // TODO: 根据设计稿调整 Logo 和标题之间的间距（请使用设计稿中的精确值）
          SizedBox(height: 32.h), // 请替换为设计稿中的精确值

          // 标题区域
          _buildTitle(),

          // TODO: 根据设计稿决定是否有副标题
          // 如果有，添加以下代码并调整间距和样式：
          // SizedBox(height: 8.h), // 请使用设计稿中的精确值
          // _buildSubtitle(),

          // TODO: 根据设计稿决定是否有加载指示器
          // 如果有，添加以下代码并调整间距和样式：
          // SizedBox(height: 48.h), // 请使用设计稿中的精确值
          // _buildLoadingIndicator(),

          // TODO: 如果设计稿中还有其他元素（如版本号、版权信息等），请根据设计稿添加
        ],
      ),
    );
  }

  /// 构建 Logo/图标
  ///
  /// 注意：请根据设计稿精确调整以下内容：
  /// - Logo 的类型（图片、图标、自定义图形）
  /// - Logo 的尺寸（宽度和高度，请使用设计稿中的精确值）
  /// - Logo 的位置（居中、左对齐等）
  /// - Logo 的圆角、阴影等样式（仅使用设计稿中的样式）
  Widget _buildLogo() {
    // TODO: 根据设计稿选择 Logo 的实现方式

    // 方式1：如果设计稿中使用图片 Logo
    // return Image.asset(
    //   'assets/images/logo.png', // 请替换为实际的图片路径
    //   width: 120.w, // 请使用设计稿中的精确值
    //   height: 120.w, // 请使用设计稿中的精确值
    // );

    // 方式2：如果设计稿中使用图标
    // return Icon(
    //   Icons.chat, // 请使用设计稿中的图标
    //   size: 120.sp, // 请使用设计稿中的精确值
    //   color: Color(0xFF2196F3), // 请使用设计稿中的精确颜色值
    // );

    // 方式3：如果设计稿中是带背景的 Logo
    return Container(
      // TODO: 根据设计稿调整 Logo 容器尺寸（请使用设计稿中的精确值）
      width: 120.w, // 请替换为设计稿中的精确值
      height: 120.w, // 请替换为设计稿中的精确值
      // TODO: 根据设计稿调整 Logo 容器的样式
      decoration: BoxDecoration(
        // TODO: 根据设计稿调整背景色（请使用设计稿中的精确颜色值）
        color: const Color(0xFF2196F3), // 请替换为设计稿中的精确值
        // TODO: 根据设计稿调整圆角（请使用设计稿中的精确值）
        borderRadius: BorderRadius.circular(24.r), // 请替换为设计稿中的精确值
        // TODO: 如果设计稿中有阴影，请根据设计稿添加（仅使用设计稿中的阴影参数）
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.2), // 请使用设计稿中的精确值
        //     blurRadius: 20, // 请使用设计稿中的精确值
        //     offset: Offset(0, 10), // 请使用设计稿中的精确值
        //   ),
        // ],
      ),
      // TODO: 根据设计稿调整 Logo 内容
      child: Icon(
        Icons.chat, // 请使用设计稿中的图标
        size: 60.sp, // 请使用设计稿中的精确值
        // TODO: 根据设计稿调整图标颜色（请使用设计稿中的精确颜色值）
        color: Colors.white, // 请替换为设计稿中的精确值
      ),
    );
  }

  /// 构建标题
  ///
  /// 注意：请根据设计稿精确调整以下内容：
  /// - 标题文本内容（请使用设计稿中的文本）
  /// - 字体大小（请使用设计稿中的精确值）
  /// - 字体粗细（请使用设计稿中的精确值，如 FontWeight.w600）
  /// - 字体颜色（请使用设计稿中的精确颜色值）
  /// - 文本对齐方式（左对齐、居中、右对齐）
  Widget _buildTitle() {
    return Text(
      // TODO: 根据设计稿调整标题文本
      'DumbChat', // 请替换为设计稿中的实际标题
      style: TextStyle(
        // TODO: 根据设计稿调整字体大小（请使用设计稿中的精确值）
        fontSize: 32.sp, // 请替换为设计稿中的精确值
        // TODO: 根据设计稿调整字体粗细（请使用设计稿中的精确值）
        fontWeight: FontWeight.bold, // 请替换为设计稿中的精确值（如 FontWeight.w600）
        // TODO: 根据设计稿调整字体颜色（请使用设计稿中的精确颜色值）
        color: const Color(0xFF000000), // 请替换为设计稿中的精确值
        // TODO: 根据设计稿调整字间距（如果有标注）
        // letterSpacing: 0.5, // 请使用设计稿中的精确值
      ),
      // TODO: 根据设计稿调整文本对齐方式
      textAlign: TextAlign.center, // 请根据设计稿调整
    );
  }

  /// 构建副标题（如果设计稿中有）
  ///
  /// 注意：请根据设计稿精确调整所有样式参数
  /// 如果设计稿中没有副标题，可以删除此方法
  // ignore: unused_element
  Widget _buildSubtitle() {
    return Text(
      // TODO: 根据设计稿调整副标题文本
      '副标题文本', // 请替换为设计稿中的实际文本
      style: TextStyle(
        // TODO: 根据设计稿调整字体大小（请使用设计稿中的精确值）
        fontSize: 16.sp, // 请替换为设计稿中的精确值
        // TODO: 根据设计稿调整字体粗细（请使用设计稿中的精确值）
        fontWeight: FontWeight.normal, // 请替换为设计稿中的精确值
        // TODO: 根据设计稿调整字体颜色（请使用设计稿中的精确颜色值）
        color: const Color(0xFF666666), // 请替换为设计稿中的精确值
      ),
      // TODO: 根据设计稿调整文本对齐方式
      textAlign: TextAlign.center, // 请根据设计稿调整
    );
  }

  /// 构建加载指示器（如果设计稿中有）
  ///
  /// 注意：请根据设计稿精确调整以下内容：
  /// - 加载指示器的类型（圆形、线性、点状等，仅使用设计稿中的类型）
  /// - 加载指示器的颜色（请使用设计稿中的精确颜色值）
  /// - 加载指示器的尺寸（请使用设计稿中的精确值）
  /// - 加载文本（如果设计稿中有）
  /// 如果设计稿中没有加载指示器，可以删除此方法
  // ignore: unused_element
  Widget _buildLoadingIndicator() {
    // TODO: 根据设计稿选择加载指示器的类型
    // 方式1：圆形加载指示器
    return CircularProgressIndicator(
      // TODO: 根据设计稿调整颜色（请使用设计稿中的精确颜色值）
      valueColor: AlwaysStoppedAnimation<Color>(
        const Color(0xFF2196F3), // 请替换为设计稿中的精确值
      ),
      // TODO: 根据设计稿调整线宽（请使用设计稿中的精确值）
      strokeWidth: 3.0, // 请替换为设计稿中的精确值
    );

    // 方式2：如果设计稿中是其他类型的加载指示器，请根据设计稿实现
    // 方式3：如果设计稿中有加载文本，请根据设计稿添加
    // return Column(
    //   children: [
    //     CircularProgressIndicator(...),
    //     SizedBox(height: 16.h), // 请使用设计稿中的精确值
    //     Text(
    //       '加载中...', // 请使用设计稿中的文本
    //       style: TextStyle(...), // 请使用设计稿中的样式
    //     ),
    //   ],
    // );
  }
}