import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/auth/providers/auth_provider.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/router/app_router.dart';

/// 启动页面
///
/// 显示应用启动画面，包含背景图片和 Logo。
/// 负责初始化应用状态（如认证状态检查）并根据结果导航到相应页面。
class SplashPage extends ConsumerStatefulWidget {
  /// 创建启动页面实例
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  /// 是否已经导航到下一页面
  bool _hasNavigated = false;

  @override
  Widget build(BuildContext context) {
    /// 监听认证状态变化
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      // 当认证状态从未初始化变为已初始化时，处理导航
      final wasNotInitialized = previous?.isInitialized != true;
      if (wasNotInitialized && next.isInitialized && !_hasNavigated) {
        _handleNavigation(next);
      }
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash/SplashScreen.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 130.h,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/splash/DumbChat.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('DumbChat 图片加载失败: $error');
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 处理页面导航逻辑
  ///
  /// 等待1秒后根据认证状态导航到相应页面。
  ///
  /// 参数:
  /// - [authState] 当前认证状态
  void _handleNavigation(AuthState authState) {
    if (!mounted) {
      return;
    }

    _hasNavigated = true;
    final router = ref.read(routerProvider);
    Future<void>.delayed(const Duration(seconds: 1), () {
      if (!mounted) {
        return;
      }

      // 根据认证状态导航
      // 使用 goNamed 会清除整个导航栈，确保用户无法返回到启动页
      if (authState.isAuthenticated) {
        // 已认证，跳转到首页
        router.goNamed(RouteConstants.homeName);
      } else {
        // 未认证，跳转到登录页
        router.goNamed(RouteConstants.loginName);
      }
    });
  }
}
