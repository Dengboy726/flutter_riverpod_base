import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/app_button.dart';

/// 设置页面
///
/// 应用设置和配置选项页面。
class SettingsPage extends ConsumerWidget {
  /// 创建设置页面实例
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);
    final language = ref.watch(languageProvider);
    final languageNotifier = ref.read(languageProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // 主题设置
          _buildSectionCard(
            context,
            title: AppStrings.themeSettings,
            children: [
              _buildThemeOption(
                context,
                title: AppStrings.lightTheme,
                isSelected: themeMode == ThemeMode.light,
                onTap: () => themeNotifier.setThemeMode(ThemeMode.light),
              ),
              _buildThemeOption(
                context,
                title: AppStrings.darkTheme,
                isSelected: themeMode == ThemeMode.dark,
                onTap: () => themeNotifier.setThemeMode(ThemeMode.dark),
              ),
              _buildThemeOption(
                context,
                title: AppStrings.systemTheme,
                isSelected: themeMode == ThemeMode.system,
                onTap: () => themeNotifier.setThemeMode(ThemeMode.system),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // 语言设置
          _buildSectionCard(
            context,
            title: AppStrings.languageSettings,
            children: [
              _buildLanguageOption(
                context,
                title: AppStrings.chinese,
                isSelected: language.languageCode == 'zh',
                onTap: () =>
                    languageNotifier.setLanguage(const Locale('zh', 'CN')),
              ),
              _buildLanguageOption(
                context,
                title: AppStrings.english,
                isSelected: language.languageCode == 'en',
                onTap: () =>
                    languageNotifier.setLanguage(const Locale('en', 'US')),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // 账户设置
          _buildSectionCard(
            context,
            title: AppStrings.account,
            children: [
              _buildSettingsItem(
                context,
                icon: Icons.person,
                title: '个人资料',
                onTap: () => context.go('/home/profile'),
              ),
              _buildSettingsItem(
                context,
                icon: Icons.security,
                title: '安全设置',
                onTap: () {
                  // TODO(developer): 实现安全设置
                },
              ),
              _buildSettingsItem(
                context,
                icon: Icons.notifications,
                title: '通知设置',
                onTap: () {
                  // TODO(developer): 实现通知设置
                },
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // 应用设置
          _buildSectionCard(
            context,
            title: '应用设置',
            children: [
              _buildSettingsItem(
                context,
                icon: Icons.storage,
                title: '存储管理',
                onTap: () {
                  // TODO(developer): 实现存储管理
                },
              ),
              _buildSettingsItem(
                context,
                icon: Icons.bug_report,
                title: '日志查看',
                onTap: () {
                  // TODO(developer): 实现日志查看
                },
              ),
              _buildSettingsItem(
                context,
                icon: Icons.cached,
                title: '清除缓存',
                onTap: () {
                  _showClearCacheDialog(context);
                },
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // 关于
          _buildSectionCard(
            context,
            title: AppStrings.about,
            children: [
              _buildSettingsItem(
                context,
                icon: Icons.info,
                title: '应用信息',
                onTap: () {
                  _showAppInfoDialog(context);
                },
              ),
              _buildSettingsItem(
                context,
                icon: Icons.feedback,
                title: AppStrings.feedback,
                onTap: () {
                  // TODO(developer): 实现反馈功能
                },
              ),
              _buildSettingsItem(
                context,
                icon: Icons.help,
                title: AppStrings.help,
                onTap: () {
                  // TODO(developer): 实现帮助功能
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) => Card(
    child: Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.getColorScheme(context).primary,
            ),
          ),
          SizedBox(height: 12.h),
          ...children,
        ],
      ),
    ),
  );

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8.r),
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      child: Row(
        children: [
          Radio<ThemeMode>(
            value: _getThemeModeFromTitle(title),
            groupValue: isSelected ? _getThemeModeFromTitle(title) : null,
            onChanged: (value) => onTap(),
          ),
          SizedBox(width: 8.w),
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    ),
  );

  Widget _buildLanguageOption(
    BuildContext context, {
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8.r),
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      child: Row(
        children: [
          Radio<String>(
            value: title,
            groupValue: isSelected ? title : null,
            onChanged: (value) => onTap(),
          ),
          SizedBox(width: 8.w),
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    ),
  );

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8.r),
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20.sp,
            color: AppTheme.getColorScheme(context).onSurfaceVariant,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16.sp,
            color: AppTheme.getColorScheme(context).onSurfaceVariant,
          ),
        ],
      ),
    ),
  );

  ThemeMode _getThemeModeFromTitle(String title) {
    switch (title) {
      case '浅色主题':
        return ThemeMode.light;
      case '深色主题':
        return ThemeMode.dark;
      case '跟随系统':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除缓存'),
        content: const Text('确定要清除应用缓存吗？这将删除所有临时数据。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          AppButton(
            text: AppStrings.confirm,
            onPressed: () {
              // TODO(developer): 实现清除缓存功能
              Navigator.of(context).pop();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('缓存已清除')));
            },
            type: AppButtonType.danger,
          ),
        ],
      ),
    );
  }

  void _showAppInfoDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('应用信息'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('应用名称: ${AppStrings.appName}'),
            SizedBox(height: 8.h),
            const Text('版本: 1.0.0'),
            SizedBox(height: 8.h),
            const Text('构建号: 1'),
            SizedBox(height: 8.h),
            const Text('Flutter 版本: 3.10.0'),
          ],
        ),
        actions: [
          AppButton(
            text: AppStrings.ok,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
