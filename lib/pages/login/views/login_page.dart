import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/auth_page_layout.dart';
import '../../../core/auth/providers/auth_provider.dart';

/// 登录页面
///
/// 提供用户登录功能，包含公司代码、邮箱/用户ID和密码输入框。
class LoginPage extends HookConsumerWidget {
  /// 创建登录页面实例
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 使用 hooks 管理状态
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final companyCodeController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final obscurePassword = useState<bool>(true);

    // 错误信息状态（用于固定布局高度，避免挤压）
    final companyCodeError = useMemoized(() => ValueNotifier<String?>(null));
    final emailError = useMemoized(() => ValueNotifier<String?>(null));
    final passwordError = useMemoized(() => ValueNotifier<String?>(null));

    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final router = ref.read(routerProvider);

    // 监听认证状态变化，登录成功后跳转到确认页面
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      // 登录成功（有用户数据但还未确认）时跳转到确认页面
      final hasUserData = next.user != null;
      final wasLoading = previous?.isLoading ?? false;
      final isNotLoading = !next.isLoading;
      final wasNotAuthenticated = previous?.isAuthenticated != true;

      // 登录请求完成且有用户数据时，跳转到确认页面
      if (wasLoading && isNotLoading && hasUserData && wasNotAuthenticated) {
        router.goNamed(RouteConstants.loginConfirmName);
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: SafeArea(
        bottom: false,
        child: AuthPageLayout(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题区域
                _buildTitleSection(l10n: l10n),

                SizedBox(height: 30.h),

                // 输入框区域
                _buildInputFieldsSection(
                  l10n: l10n,
                  companyCodeController: companyCodeController,
                  emailController: emailController,
                  passwordController: passwordController,
                  obscurePassword: obscurePassword,
                  companyCodeError: companyCodeError,
                  emailError: emailError,
                  passwordError: passwordError,
                ),

                SizedBox(height: 34.h),

                // 登录按钮
                _buildLoginButton(
                  formKey: formKey,
                  l10n: l10n,
                  emailController: emailController,
                  passwordController: passwordController,
                  authState: authState,
                  authNotifier: authNotifier,
                ),

                // 错误信息
                if (authState.errorMessage != null)
                  _buildErrorMessage(message: authState.errorMessage!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建标题区域
  ///
  /// 显示登录页面的主标题和副标题。
  /// 主标题：35sp，Manrope 字体，加粗
  /// 副标题：14sp，Open Sans 字体，灰色
  ///
  /// 参数:
  /// - [l10n] 本地化实例
  Widget _buildTitleSection({required AppLocalizations l10n}) => Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(vertical: 5.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.login,
          style: TextStyle(
            color: AppTheme.black,
            fontSize: 35.sp,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            height: 1.20,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          l10n.enterDetailsToLogin,
          style: TextStyle(
            color: AppTheme.grey2,
            fontSize: 14.sp,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w400,
            height: 1.20,
          ),
        ),
      ],
    ),
  );

  /// 构建输入框区域
  ///
  /// 包含三个输入框：公司代码、邮箱/用户ID、密码。
  /// 每个输入框之间间距 15.h。
  /// "Forgot password?" 链接位于所有输入框下方。
  ///
  /// 参数:
  /// - [l10n] 本地化实例
  /// - [companyCodeController] 公司代码输入框控制器
  /// - [emailController] 邮箱/用户ID输入框控制器
  /// - [passwordController] 密码输入框控制器
  /// - [obscurePassword] 密码可见性状态
  /// - [companyCodeError] 公司代码错误状态
  /// - [emailError] 邮箱错误状态
  /// - [passwordError] 密码错误状态
  Widget _buildInputFieldsSection({
    required AppLocalizations l10n,
    required TextEditingController companyCodeController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required ValueNotifier<bool> obscurePassword,
    required ValueNotifier<String?> companyCodeError,
    required ValueNotifier<String?> emailError,
    required ValueNotifier<String?> passwordError,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Company Code 输入框
      _buildInputField(
        label: l10n.companyCode,
        hint: l10n.enterCompanyCode,
        controller: companyCodeController,
        errorNotifier: companyCodeError,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return l10n.companyCodeRequired;
          }
          return null;
        },
      ),

      SizedBox(height: 15.h),

      // Email or User Id 输入框
      _buildInputField(
        label: l10n.emailOrUserId,
        hint: l10n.emailOrPhoneNumber,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        errorNotifier: emailError,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return l10n.emailRequired;
          }
          // 允许邮箱或用户名
          return null;
        },
      ),

      SizedBox(height: 15.h),

      // Password 输入框
      _buildInputField(
        label: l10n.password,
        hint: l10n.enterPassword,
        controller: passwordController,
        obscureText: obscurePassword.value,
        suffixIcon: Icon(
          obscurePassword.value
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppTheme.grey2,
        ),
        onSuffixTap: () {
          obscurePassword.value = !obscurePassword.value;
        },
        errorNotifier: passwordError,
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

      // SizedBox(height: 16.h),

      // Forgot password 链接
      Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            // TODO: 实现忘记密码功能
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            l10n.forgotPassword,
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 12.sp,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
              height: 1.20,
            ),
          ),
        ),
      ),
    ],
  );

  /// 构建登录按钮
  ///
  /// 处理登录逻辑：验证表单 -> 调用登录接口。
  /// 加载状态显示 CircularProgressIndicator，禁用时按钮不可点击。
  ///
  /// 参数:
  /// - [formKey] 表单的 GlobalKey，用于表单验证
  /// - [l10n] 本地化实例
  /// - [emailController] 邮箱/用户ID输入框控制器
  /// - [passwordController] 密码输入框控制器
  /// - [authState] 认证状态，用于判断是否加载中
  /// - [authNotifier] 认证通知器，用于调用登录方法
  Widget _buildLoginButton({
    required GlobalKey<FormState> formKey,
    required AppLocalizations l10n,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required AuthState authState,
    required dynamic authNotifier,
  }) => SizedBox(
    width: double.infinity,
    height: 48.h,
    child: ElevatedButton(
      onPressed: authState.isLoading
          ? null
          : () {
              if (formKey.currentState?.validate() ?? false) {
                authNotifier.login(
                  emailController.text.trim(),
                  passwordController.text,
                );
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.r),
        ),
        elevation: 0,
      ),
      child: authState.isLoading
          ? SizedBox(
              width: 20.w,
              height: 20.h,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              l10n.login,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w600,
                height: 1.30,
              ),
            ),
    ),
  );

  /// 构建错误信息显示组件
  ///
  /// 当登录失败时显示错误信息。
  /// 红色背景（10% 透明度），包含错误图标和错误文本。
  ///
  /// 参数:
  /// - [message] 错误信息文本
  Widget _buildErrorMessage({required String message}) => Container(
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(
      color: AppTheme.errorColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Row(
      children: [
        Icon(Icons.error_outline, color: AppTheme.errorColor, size: 20.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: AppTheme.errorColor,
              fontSize: 14.sp,
              fontFamily: 'Open Sans',
            ),
          ),
        ),
      ],
    ),
  );

  /// 构建输入框组件
  ///
  /// 通用的输入框构建函数，支持标签、占位符、验证、密码可见性切换等。
  /// 圆角 50.r（胶囊型），背景色 #F4F4F5，聚焦时显示主色边框。
  /// 错误信息显示在输入框下方的固定高度区域，避免布局挤压。
  ///
  /// 参数:
  /// - [label] 输入框标签文本，显示在输入框上方
  /// - [hint] 占位符文本
  /// - [controller] 文本控制器
  /// - [keyboardType] 键盘类型，默认为文本键盘
  /// - [obscureText] 是否密文显示（用于密码），默认 false
  /// - [suffixIcon] 后缀图标（如密码可见性切换图标）
  /// - [onSuffixTap] 后缀图标点击回调
  /// - [errorNotifier] 错误信息状态管理，用于在固定高度区域显示错误
  /// - [validator] 验证函数，返回错误信息或 null
  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required ValueNotifier<String?> errorNotifier,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    VoidCallback? onSuffixTap,
    String? Function(String?)? validator,
  }) => SizedBox(
    height: 94.h,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 标签区域（固定高度）
        SizedBox(
          height: 18.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: TextStyle(
                  color: AppTheme.grey1,
                  fontSize: 12.sp,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w400,
                  height: 1.20,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),

        // 输入框（固定高度容器，避免验证时布局挤压）
        SizedBox(
          height: 48.h,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              final error = validator?.call(value);
              // 更新错误状态（用于在固定高度区域显示错误）
              errorNotifier.value = error;
              return error;
            },
            onChanged: (_) {
              // 输入时清空错误提示
              errorNotifier.value = null;
            },
            style: TextStyle(
              color: AppTheme.black,
              fontSize: 16.sp,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
              height: 1.30,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppTheme.grey2,
                fontSize: 16.sp,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w400,
                height: 1.30,
              ),
              filled: true,
              fillColor: AppTheme.grey5,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 14.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.r),
                borderSide: const BorderSide(
                  color: AppTheme.primaryColor,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.r),
                borderSide: const BorderSide(color: AppTheme.errorColor),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.r),
                borderSide: const BorderSide(
                  color: AppTheme.errorColor,
                  width: 2,
                ),
              ),
              // 隐藏错误文本以固定布局高度，避免挤压
              // 错误信息将在输入框下方的固定区域显示
              errorStyle: const TextStyle(height: 0, fontSize: 0),
              errorMaxLines: 1,
              // 完全隐藏辅助文本区域
              isDense: true,
              suffixIcon: suffixIcon != null
                  ? GestureDetector(
                      onTap: onSuffixTap,
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: suffixIcon,
                      ),
                    )
                  : null,
            ),
          ),
        ),
        // 错误信息显示区域（固定高度，避免布局挤压）
        // 高度固定为 20.h，有错误时显示，无错误时保持空白占位
        SizedBox(
          height: 20.h,
          child: ValueListenableBuilder<String?>(
            valueListenable: errorNotifier,
            builder: (context, errorText, _) => errorText != null
                ? Padding(
                    padding: EdgeInsets.only(left: 16.w, top: 4.h),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        errorText,
                        style: TextStyle(
                          color: AppTheme.errorColor,
                          fontSize: 12.sp,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                          height: 1.20,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    ),
  );
}
