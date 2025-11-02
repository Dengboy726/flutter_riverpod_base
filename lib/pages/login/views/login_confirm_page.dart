import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/auth_page_layout.dart';
import '../../../core/auth/models/user.dart';
import '../../../core/auth/providers/auth_provider.dart';

/// 登录确认页面
///
/// 显示当前登录账户信息，允许用户确认或切换账户。
class LoginConfirmPage extends ConsumerWidget {
  /// 创建登录确认页面实例
  const LoginConfirmPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final router = ref.read(routerProvider);

    final user = authState.user;

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: SafeArea(
        bottom: false,
        child: AuthPageLayout(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 标题区域
              _buildTitleSection(
                l10n: l10n,
                authNotifier: authNotifier,
                router: router,
              ),

              SizedBox(height: 24.h),

              // 提示文本
              _buildPromptText(l10n: l10n),

              SizedBox(height: 24.h),

              // 账户信息区域
              _buildAccountInfo(user: user),

              SizedBox(height: 24.h),

              // 按钮区域
              _buildButtons(
                l10n: l10n,
                authNotifier: authNotifier,
                router: router,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建标题区域
  ///
  /// 显示页面标题和返回图标。
  Widget _buildTitleSection({
    required AppLocalizations l10n,
    required AuthNotifier authNotifier,
    required GoRouter router,
  }) => SizedBox(
    width: double.infinity,
    height: 50.h,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 36.w,
          height: 36.h,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // 切换用户：清除用户数据并返回登录页面
              authNotifier.clearUser();
              router.goNamed(RouteConstants.loginName);
            },
            style: IconButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            l10n.loginConfirm,
            style: TextStyle(
              color: const Color(0xFF404040),
              fontSize: 18.sp,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w600,
              height: 1.20,
            ),
          ),
        ),
      ],
    ),
  );

  /// 构建提示文本
  ///
  /// 显示"Continue with this account?"提示。
  Widget _buildPromptText({required AppLocalizations l10n}) => SizedBox(
    width: double.infinity,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Text(
        l10n.continueWithThisAccount,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppTheme.black,
          fontSize: 18.sp,
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.w400,
          height: 1.20,
        ),
      ),
    ),
  );

  /// 构建账户信息区域
  ///
  /// 显示用户头像、公司名称和描述。
  Widget _buildAccountInfo({required User? user}) => Container(
    width: 214.w,
    padding: EdgeInsets.symmetric(vertical: 50.h),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 用户头像
        Container(
          width: 100.w,
          height: 100.h,
          decoration: ShapeDecoration(
            image: user?.avatar != null
                ? DecorationImage(
                    image: NetworkImage(user!.avatar!),
                    fit: BoxFit.fill,
                  )
                : null,
            color: user?.avatar == null
                ? AppTheme.primaryColor.withOpacity(0.1)
                : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(142.86.r),
            ),
          ),
          child: user?.avatar == null
              ? Icon(Icons.person, size: 50.sp, color: AppTheme.primaryColor)
              : null,
        ),
        SizedBox(height: 20.h),

        // 公司/用户信息
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              // 优先使用 metadata 中的 companyName，否则使用显示名称
              user?.metadata?['companyName'] as String? ??
                  user?.displayName ??
                  'Unknown',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.black,
                fontSize: 24.sp,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                height: 1.20,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              // 使用 metadata 中的 companyDescription 或用户名
              user?.metadata?['companyDescription'] as String? ??
                  user?.username ??
                  '',
              textAlign: TextAlign.center,
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
      ],
    ),
  );

  /// 构建按钮区域
  ///
  /// 包含确认和切换用户两个按钮。
  Widget _buildButtons({
    required AppLocalizations l10n,
    required AuthNotifier authNotifier,
    required GoRouter router,
  }) => Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // 确认按钮
      SizedBox(
        width: double.infinity,
        height: 48.h,
        child: ElevatedButton(
          onPressed: () {
            // 确认登录：设置为已认证并跳转到首页
            authNotifier.confirmLogin();
            router.goNamed(RouteConstants.homeName);
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
          child: Text(
            l10n.confirm,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w600,
              height: 1.30,
            ),
          ),
        ),
      ),

      SizedBox(height: 10.h),

      // 切换用户按钮
      SizedBox(
        width: double.infinity,
        height: 48.h,
        child: ElevatedButton(
          onPressed: () {
            // 切换用户：清除用户数据并返回登录页面
            authNotifier.clearUser();
            router.goNamed(RouteConstants.loginName);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC4DFFA),
            foregroundColor: const Color(0xFF0A4075),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.r),
            ),
            elevation: 0,
          ),
          child: Text(
            l10n.changeUser,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF0A4075),
              fontSize: 16.sp,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w600,
              height: 1.30,
            ),
          ),
        ),
      ),
    ],
  );
}
