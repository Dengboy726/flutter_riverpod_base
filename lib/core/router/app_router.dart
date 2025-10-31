import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../pages/home/views/home_page.dart';
import '../../pages/login/views/login_page.dart';
import '../../pages/profile/views/profile_page.dart';
import '../../pages/register/views/register_page.dart';
import '../../pages/settings/views/settings_page.dart';
import '../../pages/splash/views/splash_page.dart';
import '../l10n/app_localizations.dart';

/// 路由提供者
final routerProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // 启动页
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),

      // 认证相关路由
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),

      // 主应用路由
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),

    ],
    errorBuilder: (context, state) {
      final l10n = AppLocalizations.of(context);
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                l10n?.pageNotFound ?? '页面未找到',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                '${l10n?.errorCode ?? '错误代码'}: ${state.error}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: Text(l10n?.backToHome ?? '返回首页'),
              ),
            ],
          ),
        ),
      );
    },
  ),
);
