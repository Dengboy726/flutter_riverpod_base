import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../core/auth/providers/auth_provider.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final rememberMe = ValueNotifier(false);
    final obscurePassword = ValueNotifier(true);

    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    // 监听认证状态变化
    useEffect(() {
      if (authState.isAuthenticated) {
        context.go('/home');
      }
      return null;
    }, [authState.isAuthenticated]);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 60.h),

                // 标题
                Text(
                  l10n.login,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getColorScheme(context).primary,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 8.h),

                Text(
                  l10n.login,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.getColorScheme(context).onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 48.h),

                // 邮箱输入框
                AppTextField(
                  label: l10n.email,
                  hint: l10n.email,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.emailRequired;
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return l10n.emailInvalid;
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

                // 密码输入框
                AppTextField(
                  label: l10n.password,
                  hint: l10n.password,
                  controller: passwordController,
                  obscureText: obscurePassword.value,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.passwordRequired;
                    }
                    if (value.length < 8) {
                      return l10n.passwordTooShort;
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

                // 记住我和忘记密码
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe.value,
                          onChanged: (value) {
                            rememberMe.value = value ?? false;
                          },
                        ),
                        Text(
                          l10n.rememberMe,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: 实现忘记密码功能
                      },
                      child: Text(l10n.forgotPassword),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                // 登录按钮
                AppButton(
                  text: l10n.login,
                  onPressed: authState.isLoading
                      ? null
                      : () {
                          if (formKey.currentState?.validate() ?? false) {
                            authNotifier.login(
                              emailController.text,
                              passwordController.text,
                            );
                          }
                        },
                  isLoading: authState.isLoading,
                  isFullWidth: true,
                  size: AppButtonSize.large,
                ),

                SizedBox(height: 24.h),

                // 错误信息
                if (authState.errorMessage != null)
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppTheme.getColorScheme(context).errorContainer,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppTheme.getColorScheme(context).error,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            authState.errorMessage!,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppTheme.getColorScheme(context).error,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: 32.h),

                // 注册链接
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.register,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        context.go('/register');
                      },
                      child: Text(l10n.register),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
