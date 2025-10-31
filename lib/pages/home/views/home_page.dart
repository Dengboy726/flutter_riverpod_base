import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/models/user.dart';
import '../../../core/auth/providers/auth_provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';

/// 首页
///
/// 应用的主页面，显示用户信息和基本功能入口。
class HomePage extends ConsumerWidget {
  /// 创建首页实例
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/home/settings'),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 欢迎信息
            Card(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '欢迎使用 Flutter 企业级脚手架',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '这是一个功能完整的企业级 Flutter 应用模板，包含了认证、网络请求、状态管理、主题切换、国际化等核心功能。',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.getColorScheme(
                          context,
                        ).onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // 功能列表
            Text(
              '主要功能',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 16.h),

            Expanded(
              child: ListView(
                children: [
                  _buildFeatureCard(
                    context,
                    icon: Icons.login,
                    title: '用户认证',
                    description: '支持用户登录、注册、JWT token 管理',
                    onTap: () {
                      // TODO(developer): 导航到认证相关页面
                    },
                  ),

                  SizedBox(height: 16.h),

                  _buildFeatureCard(
                    context,
                    icon: Icons.network_check,
                    title: '网络请求',
                    description: '基于 Dio 的网络请求封装，支持拦截器和错误处理',
                    onTap: () {
                      // TODO(developer): 导航到网络测试页面
                    },
                  ),

                  SizedBox(height: 16.h),

                  _buildFeatureCard(
                    context,
                    icon: Icons.palette,
                    title: '主题管理',
                    description: '支持浅色、深色主题切换',
                    onTap: () {
                      context.go('/home/settings');
                    },
                  ),

                  SizedBox(height: 16.h),

                  _buildFeatureCard(
                    context,
                    icon: Icons.language,
                    title: '国际化',
                    description: '支持多语言切换',
                    onTap: () {
                      context.go('/home/settings');
                    },
                  ),

                  SizedBox(height: 16.h),

                  _buildFeatureCard(
                    context,
                    icon: Icons.storage,
                    title: '数据持久化',
                    description: '基于 SharedPreferences 的本地存储',
                    onTap: () {
                      // TODO(developer): 导航到存储测试页面
                    },
                  ),

                  SizedBox(height: 16.h),

                  _buildFeatureCard(
                    context,
                    icon: Icons.bug_report,
                    title: '日志管理',
                    description: '完整的日志记录和管理系统',
                    onTap: () {
                      // TODO(developer): 导航到日志查看页面
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // 用户信息
            if (authState.user != null) ...[
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24.r,
                        backgroundColor: AppTheme.getColorScheme(
                          context,
                        ).primary,
                        child: Text(
                          authState.user!.username.isNotEmpty
                              ? authState.user!.username[0].toUpperCase()
                              : 'U',
                          style: TextStyle(
                            color: AppTheme.getColorScheme(context).onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authState.user!.displayName,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              authState.user!.email,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppTheme.getColorScheme(
                                      context,
                                    ).onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      AppButton(
                        text: AppStrings.logout,
                        onPressed: authNotifier.logout,
                        type: AppButtonType.outline,
                        size: AppButtonSize.small,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) => Card(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: AppTheme.getColorScheme(context).primaryContainer,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: AppTheme.getColorScheme(context).primary,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.getColorScheme(context).onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: AppTheme.getColorScheme(context).onSurfaceVariant,
            ),
          ],
        ),
      ),
    ),
  );
}
