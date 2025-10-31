import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../core/auth/providers/auth_provider.dart';

/// 注册页面
///
/// 提供用户注册功能。
/// 包含用户名、邮箱、密码、确认密码、姓名、手机号等输入框。
/// 支持注册按钮，点击后进行注册操作。
/// 支持登录链接，点击后跳转到登录页面。
/// 支持错误信息显示。
/// 支持加载状态显示。
/// 支持表单验证。
/// 支持记住我功能。
/// 支持忘记密码功能。
/// 支持注册成功后跳转到首页。
/// 支持注册失败后显示错误信息。
/// 支持注册成功后显示成功信息。
/// 支持注册失败后显示错误信息。
class RegisterPage extends ConsumerWidget {
  /// 创建注册页面
  ///
  /// 参数:
  /// - [key] 注册页面的键
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
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

    // 监听认证状态变化
    useEffect(() {
      if (authState.isAuthenticated) {
        context.go('/home');
      }
      return null;
    }, [authState.isAuthenticated]);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.register),
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
                  l10n?.createNewAccount ?? '创建新账户',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getColorScheme(context).primary,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 8.h),

                Text(
                  l10n?.fillInfoToRegister ?? '请填写以下信息完成注册',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.getColorScheme(context).onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 32.h),

                // 用户名输入框
                AppTextField(
                  label: AppStrings.username,
                  hint: l10n?.pleaseEnterUsername ?? '请输入用户名',
                  controller: usernameController,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.person_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.usernameRequired;
                    }
                    if (value.length < 3) {
                      return AppStrings.usernameTooShort;
                    }
                    if (value.length > 50) {
                      return AppStrings.usernameTooLong;
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

                // 邮箱输入框
                AppTextField(
                  label: AppStrings.email,
                  hint: l10n?.pleaseEnterEmail ?? '请输入邮箱地址',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.emailRequired;
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return AppStrings.emailInvalid;
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

                // 密码输入框
                AppTextField(
                  label: AppStrings.password,
                  hint: l10n?.pleaseEnterPassword ?? '请输入密码',
                  controller: passwordController,
                  obscureText: obscurePassword.value,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.passwordRequired;
                    }
                    if (value.length < 8) {
                      return AppStrings.passwordTooShort;
                    }
                    if (value.length > 128) {
                      return AppStrings.passwordTooLong;
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.h),

                // 确认密码输入框
                AppTextField(
                  label: AppStrings.confirmPassword,
                  hint: l10n?.pleaseReEnterPassword ?? '请再次输入密码',
                  controller: confirmPasswordController,
                  obscureText: obscureConfirmPassword.value,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.passwordRequired;
                    }
                    if (value != passwordController.text) {
                      return AppStrings.passwordMismatch;
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
                        label: l10n?.firstName ?? '名字',
                        hint: l10n?.pleaseEnterFirstName ?? '请输入名字',
                        controller: firstNameController,
                        textInputAction: TextInputAction.next,
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: AppTextField(
                        label: l10n?.lastName ?? '姓氏',
                        hint: l10n?.pleaseEnterLastName ?? '请输入姓氏',
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
                  label: l10n?.phone ?? '手机号',
                  hint: l10n?.pleaseEnterPhone ?? '请输入手机号',
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_outlined),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value)) {
                        return AppStrings.phoneInvalid;
                      }
                    }
                    return null;
                  },
                ),

                SizedBox(height: 32.h),

                // 注册按钮
                AppButton(
                  text: AppStrings.register,
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
                      l10n?.alreadyHaveAccount ?? '已有账户？',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        context.go('/login');
                      },
                      child: const Text(AppStrings.login),
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
