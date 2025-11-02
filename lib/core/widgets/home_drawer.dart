import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/auth/providers/auth_provider.dart';
import '../../core/theme/app_theme.dart';

/// 首页左侧抽屉菜单
///
/// 显示用户信息、导航菜单和退出登录选项。
class HomeDrawer extends ConsumerWidget {
  /// 创建首页抽屉实例
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    final user = authState.user;
    final companyName =
        user?.metadata?['companyName'] as String? ??
        user?.username ??
        'Company';

    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 40.h),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: AppTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50.r),
              bottomRight: Radius.circular(50.r),
            ),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 10,
              offset: Offset(4, 0),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 主要内容
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 用户信息区域
                  _buildUserInfoSection(
                    context: context,
                    companyName: companyName,
                    avatarUrl: user?.avatar,
                  ),

                  SizedBox(height: 10.h),

                  // 分隔线
                  _buildDivider(),

                  SizedBox(height: 10.h),

                  // 主要菜单项
                  _buildMainMenuItems(),

                  SizedBox(height: 10.h),

                  // 分隔线
                  _buildDivider(),

                  SizedBox(height: 10.h),

                  // 次要菜单项
                  _buildSecondaryMenuItems(),
                ],
              ),
            ),

            // 底部退出登录按钮
            Positioned(
              left: 0,
              bottom: 0,
              child: _buildLogoutButton(authNotifier: authNotifier),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建用户信息区域
  ///
  /// 显示用户头像、公司名称和查看资料链接。
  Widget _buildUserInfoSection({
    required BuildContext context,
    required String companyName,
    String? avatarUrl,
  }) => Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
    child: Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 头像
            Container(
              width: 100.w,
              height: 100.h,
              decoration: ShapeDecoration(
                image: avatarUrl != null
                    ? DecorationImage(
                        image: NetworkImage(avatarUrl),
                        fit: BoxFit.fill,
                      )
                    : null,
                color: avatarUrl == null ? const Color(0xFFC4DFFA) : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(142.86.r),
                ),
              ),
              child: avatarUrl == null
                  ? Icon(Icons.business, size: 50.sp, color: Colors.white)
                  : null,
            ),
            SizedBox(height: 15.h),

            // 公司名称和查看资料
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  companyName,
                  style: TextStyle(
                    color: const Color(0xFFF7F7FF),
                    fontSize: 18.sp,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w700,
                    height: 1.20,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'View Profile',
                  style: TextStyle(
                    color: const Color(0xFFC4DFFA),
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

        // 右侧关闭按钮
        Positioned(
          left: 208.w,
          top: 10.h,
          child: SizedBox(
            width: 36.w,
            height: 36.h,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    ),
  );

  /// 构建分隔线
  ///
  /// 显示菜单项之间的分隔线。
  Widget _buildDivider() => Container(
    width: 220.w,
    height: 1.h,
    margin: EdgeInsets.symmetric(horizontal: 24.w),
    decoration: const BoxDecoration(color: Color(0xFF4E9FF0)),
  );

  /// 构建主要菜单项
  ///
  /// 显示主要功能菜单，包括 Chat、User management 等。
  Widget _buildMainMenuItems() => Container(
    width: double.infinity,
    padding: EdgeInsets.only(top: 10.h, right: 20.w, bottom: 10.h),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMenuItem(icon: Icons.chat, label: 'Chat', isSelected: true),
        SizedBox(height: 5.h),
        _buildMenuItem(icon: Icons.people, label: 'User management'),
        SizedBox(height: 5.h),
        _buildMenuItem(icon: Icons.auto_awesome, label: 'Automation'),
        SizedBox(height: 5.h),
        _buildMenuItem(icon: Icons.broadcast_on_personal, label: 'Broadcast'),
        SizedBox(height: 5.h),
        _buildMenuItem(icon: Icons.assessment, label: 'Report'),
        SizedBox(height: 5.h),
        _buildMenuItem(icon: Icons.store, label: 'Product & Service'),
      ],
    ),
  );

  /// 构建次要菜单项
  ///
  /// 显示帮助和设置菜单。
  Widget _buildSecondaryMenuItems() => Container(
    width: double.infinity,
    padding: EdgeInsets.only(top: 10.h, right: 20.w, bottom: 10.h),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMenuItem(icon: Icons.help_outline, label: 'Help'),
        SizedBox(height: 5.h),
        _buildMenuItem(icon: Icons.settings, label: 'Setting'),
      ],
    ),
  );

  /// 构建单个菜单项
  ///
  /// 显示菜单图标和标签，支持选中状态。
  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    bool isSelected = false,
  }) => Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
    decoration: ShapeDecoration(
      color: isSelected ? const Color(0x7F0F60B0) : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 24.w,
          height: 24.h,
          child: Icon(icon, size: 24.sp, color: Colors.white),
        ),
        SizedBox(width: 15.w),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontFamily: 'Open Sans',
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            height: isSelected ? 1.20 : 1.30,
          ),
        ),
      ],
    ),
  );

  /// 构建退出登录按钮
  ///
  /// 显示在抽屉底部的退出登录选项。
  Widget _buildLogoutButton({required AuthNotifier authNotifier}) => Container(
    width: 232.w,
    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
    child: InkWell(
      onTap: () => authNotifier.logout(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24.w,
            height: 24.h,
            child: const Icon(Icons.logout, color: Colors.white, size: 24),
          ),
          SizedBox(width: 15.w),
          Text(
            'Logout',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
              height: 1.30,
            ),
          ),
        ],
      ),
    ),
  );
}
