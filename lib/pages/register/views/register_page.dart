import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../core/auth/providers/auth_provider.dart';

/// 注册页面
///
/// 提供用户注册功能。
/// 包含用户名、邮箱、密码、确认密码、姓名、手机号等输入框。
class RegisterPage extends ConsumerWidget {
  /// 创建注册页面实例
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final usernameController = TextEditingController();
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final phoneController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final obscurePassword = ValueNotifier(true);
    final obscureConfirmPassword = ValueNotifier(true);

    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final router = ref.read(routerProvider);

    // 监听认证状态变化，注册成功后自动跳转
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      final wasNotAuthenticated = previous?.isAuthenticated != true;
      if (wasNotAuthenticated && next.isAuthenticated) {
        router.goNamed(RouteConstants.homeName);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.register),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 标题
                Text(
                  l10n.createNewAccount,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getColorScheme(context).primary,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 8.h),

                Text(
                  l10n.fillInfoToRegister,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.getColorScheme(context).onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 32.h),

                // 用户名输入框
                AppTextField(
                  label: l10n.username,
                  hint: l10n.pleaseEnterUsername,
                  controller: usernameController,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.person_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.usernameRequired;
                    }
                    if (value.length < 3) {
                      return l10n.usernameTooShort;
                    }
                    if (value.length > 50) {
                      return l10n.usernameTooLong;
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

                // 邮箱输入框
                AppTextField(
                  label: l10n.email,
                  hint: l10n.pleaseEnterEmail,
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
                  hint: l10n.pleaseEnterPassword,
                  controller: passwordController,
                  obscureText: obscurePassword.value,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.passwordRequired;
                    }
                    if (value.length < 8) {
                      return l10n.passwordTooShort;
                    }
                    if (value.length > 128) {
                      return l10n.passwordTooLong;
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

                // 确认密码输入框
                AppTextField(
                  label: l10n.confirmPassword,
                  hint: l10n.pleaseReEnterPassword,
                  controller: confirmPasswordController,
                  obscureText: obscureConfirmPassword.value,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.passwordRequired;
                    }
                    if (value != passwordController.text) {
                      return l10n.passwordMismatch;
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

                // 姓名输入框（可选）
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: l10n.firstName,
                        hint: l10n.pleaseEnterFirstName,
                        controller: firstNameController,
                        textInputAction: TextInputAction.next,
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: AppTextField(
                        label: l10n.lastName,
                        hint: l10n.pleaseEnterLastName,
                        controller: lastNameController,
                        textInputAction: TextInputAction.next,
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // 手机号输入框（可选）
                AppTextField(
                  label: l10n.phone,
                  hint: l10n.pleaseEnterPhone,
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_outlined),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value)) {
                        return l10n.phoneInvalid;
                      }
                    }
                    return null;
                  },
                ),

                SizedBox(height: 32.h),

                // 注册按钮
                AppButton(
                  text: l10n.register,
                  onPressed: authState.isLoading
                      ? null
                      : () {
                          if (formKey.currentState?.validate() ?? false) {
                            authNotifier.register(
                              usernameController.text.trim(),
                              emailController.text.trim(),
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

                // 登录链接
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.alreadyHaveAccount,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        context.goNamed(RouteConstants.loginName);
                      },
                      child: Text(l10n.login),
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
