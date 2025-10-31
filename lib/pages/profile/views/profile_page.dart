import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../core/auth/providers/auth_provider.dart';

/// 个人资料页面
///
/// 显示用户个人信息和设置选项。
class ProfilePage extends ConsumerStatefulWidget {
  /// 创建个人资料页面实例
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final authState = ref.read(authNotifierProvider);
    final user = authState.user;

    _usernameController = TextEditingController(text: user?.username ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('个人资料'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          AppButton(
            text: AppStrings.save,
            onPressed: _saveProfile,
            type: AppButtonType.text,
            size: AppButtonSize.small,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 头像部分
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60.r,
                      backgroundColor: AppTheme.getColorScheme(context).primary,
                      child: Text(
                        authState.user?.username.isNotEmpty ?? false
                            ? authState.user!.username[0].toUpperCase()
                            : 'U',
                        style: TextStyle(
                          fontSize: 32.sp,
                          color: AppTheme.getColorScheme(context).onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    AppButton(
                      text: '更换头像',
                      onPressed: () {
                        // TODO(developer): 实现头像上传功能
                      },
                      type: AppButtonType.outline,
                      size: AppButtonSize.small,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              // 基本信息
              Text(
                '基本信息',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 16.h),

              // 用户名
              AppTextField(
                label: AppStrings.username,
                controller: _usernameController,
                enabled: false, // 用户名通常不可修改
                prefixIcon: const Icon(Icons.person_outlined),
              ),

              SizedBox(height: 16.h),

              // 邮箱
              AppTextField(
                label: AppStrings.email,
                controller: _emailController,
                enabled: false, // 邮箱通常不可修改
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
              ),

              SizedBox(height: 16.h),

              // 姓名
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: '名字',
                      controller: _firstNameController,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: AppTextField(
                      label: '姓氏',
                      controller: _lastNameController,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // 手机号
              AppTextField(
                label: AppStrings.phone,
                controller: _phoneController,
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

              // 账户状态
              Text(
                '账户状态',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 16.h),

              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      _buildStatusItem(
                        context,
                        icon: Icons.verified,
                        title: '邮箱验证',
                        status: authState.user?.isEmailVerified ?? false,
                        onTap: () {
                          // TODO(developer): 实现邮箱验证功能
                        },
                      ),
                      Divider(height: 24.h),
                      _buildStatusItem(
                        context,
                        icon: Icons.security,
                        title: '账户安全',
                        status: true,
                        onTap: () {
                          // TODO(developer): 实现安全设置
                        },
                      ),
                      Divider(height: 24.h),
                      _buildStatusItem(
                        context,
                        icon: Icons.notifications,
                        title: '通知设置',
                        status: true,
                        onTap: () {
                          // TODO(developer): 实现通知设置
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              // 危险操作
              Text(
                '危险操作',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.getColorScheme(context).error,
                ),
              ),

              SizedBox(height: 16.h),

              AppButton(
                text: '修改密码',
                onPressed: () {
                  _showChangePasswordDialog(context);
                },
                type: AppButtonType.outline,
                isFullWidth: true,
              ),

              SizedBox(height: 16.h),

              AppButton(
                text: '删除账户',
                onPressed: () {
                  _showDeleteAccountDialog(context, authNotifier);
                },
                type: AppButtonType.danger,
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool status,
    required VoidCallback onTap,
  }) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8.r),
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: status
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              status ? '已验证' : '未验证',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: status ? Colors.green : Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Icon(
            Icons.arrow_forward_ios,
            size: 16.sp,
            color: AppTheme.getColorScheme(context).onSurfaceVariant,
          ),
        ],
      ),
    ),
  );

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO(developer): 实现保存个人资料功能
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('个人资料已保存')));
    }
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('修改密码'),
        content: const Text('修改密码功能正在开发中...'),
        actions: [
          AppButton(
            text: AppStrings.ok,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(
    BuildContext context,
    AuthNotifier authNotifier,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除账户'),
        content: const Text('确定要删除您的账户吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          AppButton(
            text: '删除',
            onPressed: () {
              Navigator.of(context).pop();
              // TODO(developer): 实现删除账户功能
            },
            type: AppButtonType.danger,
          ),
        ],
      ),
    );
  }
}
