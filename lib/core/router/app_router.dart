import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../pages/home/views/home_page.dart';
import '../../pages/login/views/login_confirm_page.dart';
import '../../pages/login/views/login_page.dart';
import '../../pages/profile/views/profile_page.dart';
import '../../pages/register/views/register_page.dart';
import '../../pages/settings/views/settings_page.dart';
import '../../pages/splash/views/splash_page.dart';
import '../constants/route_constants.dart';
import '../l10n/app_localizations.dart';

/// 路由提供者
final routerProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: RouteConstants.splash,
    debugLogDiagnostics: true,
    routes: [
      // 启动页
      GoRoute(
        path: RouteConstants.splash,
        name: RouteConstants.splashName,
        builder: (context, state) => const SplashPage(),
      ),

      // 认证相关路由
      GoRoute(
        path: RouteConstants.login,
        name: RouteConstants.loginName,
        builder: (context, state) => const LoginPage(),
        routes: [
          GoRoute(
            path: 'confirm',
            name: RouteConstants.loginConfirmName,
            builder: (context, state) => const LoginConfirmPage(),
          ),
        ],
      ),
      GoRoute(
        path: RouteConstants.register,
        name: RouteConstants.registerName,
        builder: (context, state) => const RegisterPage(),
      ),

      // 主应用路由
      GoRoute(
        path: RouteConstants.home,
        name: RouteConstants.homeName,
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'profile',
            name: RouteConstants.profileName,
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: 'settings',
            name: RouteConstants.settingsName,
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
                onPressed: () => context.go(RouteConstants.home),
                child: Text(l10n?.backToHome ?? '返回首页'),
              ),
            ],
          ),
        ),
      );
    },
  ),
);
