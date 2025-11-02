import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/auth/providers/auth_provider.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/home_drawer.dart';
import '../../../core/utils/logger.dart' show AppLogger;
import '../widget/limited_tag_wrap.dart';

/// 首页 - 聊天列表页面
///
/// 显示所有聊天会话的列表，包含频道选择、筛选功能和聊天项。
class HomePage extends ConsumerWidget {
  /// 创建首页实例
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(routerProvider);

    // 监听退出登录状态变化
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      final wasAuthenticated = previous?.isAuthenticated == true;
      final isNotAuthenticated = !next.isAuthenticated;
      final isNotLoading = !next.isLoading;
      final hadUser = previous?.user != null;

      if (wasAuthenticated && isNotAuthenticated && isNotLoading && hadUser) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.logoutSuccess),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
        router.goNamed(RouteConstants.loginName);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF4FAFF),
      drawer: SizedBox(width: 262.w, child: const HomeDrawer()),
      floatingActionButton: _buildFloatingActionButton(),

      body: Stack(
        children: [
          // 主要内容区域
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部导航栏
              Builder(builder: _buildTopNavigationBar),

              // 频道选择栏
              Builder(builder: _buildChannelSelector),

              // 筛选按钮栏
              Builder(builder: _buildFilterButtons),

              // 聊天列表
              Expanded(child: _buildChatList()),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建顶部导航栏
  ///
  /// 显示应用标题和右侧操作按钮。
  Widget _buildTopNavigationBar(BuildContext context) => Container(
    width: double.infinity,
    height: 114.h,
    padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 44.h),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(color: const Color(0xFFE5E5E5), offset: Offset(0, 1.h)),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 左侧：菜单按钮和标题
        Row(
          children: [
            InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Image.asset(
                'assets/images/home/menu.png',
                width: 24.w,
                height: 24.h,
              ),
            ),
            SizedBox(width: 20.w),

            Row(
              children: [
                Image.asset(
                  'assets/images/home/D.png',
                  width: 30.w,
                  height: 34.55.h,
                ),
                SizedBox(width: 5.w),
                Text(
                  'Live chat',
                  style: TextStyle(
                    color: const Color(0xFF1C1C1E),
                    fontSize: 24.sp,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    height: 1.20,
                  ),
                ),
              ],
            ),
          ],
        ),

        // 右侧：操作按钮
        Row(
          children: [
            // 通知按钮（带红点）
            SizedBox(
              width: 24.w,
              height: 24.h,
              child: Stack(
                children: [
                  InkWell(
                    onTap: () {
                      // TODO(developer): 实现通知功能
                      AppLogger.info('通知功能');
                    },
                    child: Image.asset(
                      'assets/images/home/bell.png',
                      width: 24.w,
                      height: 24.h,
                    ),
                  ),
                  Positioned(
                    left: 12.w,
                    top: 1.5.h,
                    child: Container(
                      width: 9.w,
                      height: 9.h,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFFF1919),
                        shape: OvalBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            // 搜索按钮
            InkWell(
              onTap: () {
                // TODO(developer): 实现搜索功能
                AppLogger.info('搜索功能');
              },
              child: Image.asset(
                'assets/images/home/search.png',
                width: 24.w,
                height: 24.h,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  /// 构建频道选择栏
  ///
  /// 显示可水平滚动的。
  Widget _buildChannelSelector(BuildContext context) => Container(
    width: double.infinity,
    height: 70.h,
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: const Color(0x07000000),
          blurRadius: 6,
          offset: Offset(0, 4.h),
        ),
      ],
    ),
    child: Stack(
      children: [
        // 滚动列表（整个区域垂直居中）
        Positioned.fill(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildChannelItem(label: 'All Channel', isSelected: true),
                      _buildChannelItem(
                        label: 'Shenzhen branch',
                        hasIcon: true,
                      ),
                      _buildChannelItem(label: 'Causeway Bay Branch'),
                      _buildChannelItem(label: 'Tuen Mun Branch'),
                      _buildChannelItem(
                        label: 'Tsim Sha Tsui Branch',
                        hasIcon: true,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 56.w), // 为渐变遮罩和按钮预留空间
            ],
          ),
        ),
        // 右侧渐变遮罩（叠加在滚动列表上，与频道项同高）
        Positioned(
          right: 56.w, // 按钮宽度(24) + 间距(16) + 按钮宽度(16) = 56
          top: 0,
          bottom: 0,
          child: Center(
            child: Container(
              width: 40.w,
              height: 50.h, // 与 _buildChannelItem 高度一致
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0x00FAFCFF), // 完全透明
                    Color(0xFFFAFCFF), // 白色
                  ],
                ),
              ),
            ),
          ),
        ),
        // 右侧按钮（与频道项文本垂直居中对齐）
        Positioned(
          right: 16.w,
          top: 0,
          bottom: 0,
          child: Center(
            child: Builder(
              builder: (buttonContext) => InkWell(
                onTap: () => _showChannelDropdown(buttonContext),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 24.sp,
                  color: const Color(0xFF1C1C1E),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  /// 构建单个频道项
  ///
  /// 显示频道名称，选中状态为深色，未选中为浅色。
  Widget _buildChannelItem({
    required String label,
    bool isSelected = false,
    bool hasIcon = false,
  }) => Container(
    height: 50.h,
    margin: EdgeInsets.only(right: 20.w),
    alignment: Alignment.center,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (hasIcon) ...[
          SizedBox(width: 24.w, height: 24.h), // 图标占位
          SizedBox(width: 5.w),
        ],
        Text(
          label,
          style: TextStyle(
            color: isSelected
                ? const Color(0xFF1C1C1E)
                : const Color(0xFF888F9F),
            fontSize: 14.sp,
            fontFamily: 'Open Sans',
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            height: 1.20,
          ),
        ),
      ],
    ),
  );

  /// 构建筛选按钮栏
  ///
  /// 显示 Status、Tag、Assignee 三个筛选按钮。
  Widget _buildFilterButtons(BuildContext context) => Container(
    width: double.infinity,
    height: 60.h,
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    decoration: const ShapeDecoration(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
    ),
    child: Row(
      children: [
        _buildFilterButton(context: context, label: 'Status', isSelected: true),
        SizedBox(width: 10.w),
        _buildFilterButton(context: context, label: 'Tag'),
        SizedBox(width: 10.w),
        _buildFilterButton(context: context, label: 'Assignee'),
      ],
    ),
  );

  /// 构建单个筛选按钮
  ///
  /// 显示筛选标签，选中状态为深色边框和文字，未选中为浅色。
  /// 点击时显示下拉菜单。
  Widget _buildFilterButton({
    required BuildContext context,
    required String label,
    bool isSelected = false,
  }) => Builder(
    builder: (buttonContext) => GestureDetector(
      onTap: () => _showFilterDropdown(buttonContext, label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: isSelected
                  ? const Color(0xFFD2F2F6)
                  : const Color(0xFFD2F2F6),
            ),
            borderRadius: BorderRadius.circular(50.r),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF1C1C1E)
                    : const Color(0xFF404040),
                fontSize: 14.sp,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w400,
                height: 1.20,
              ),
            ),
            SizedBox(width: 10.w),
            Icon(
              Icons.keyboard_arrow_down,
              size: 18.sp,
              color: isSelected
                  ? const Color(0xFF1C1C1E)
                  : const Color(0xFF404040),
            ),
          ],
        ),
      ),
    ),
  );

  /// 显示筛选下拉菜单或弹窗
  ///
  /// 根据筛选类型显示对应的下拉菜单选项或弹窗。
  /// 对于 Tag 筛选，显示弹窗；其他类型显示下拉菜单。
  void _showFilterDropdown(BuildContext context, String filterType) {
    // Tag 筛选显示弹窗
    if (filterType == 'Tag') {
      _showTagFilterDialog(context);
      return;
    }

    // 其他筛选类型显示下拉菜单
    // 获取按钮的 RenderBox（Container 的）
    final RenderBox? buttonBox = context.findRenderObject() as RenderBox?;
    if (buttonBox == null) return;

    // 获取 overlay 的 RenderBox
    final RenderBox? overlayBox =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (overlayBox == null) return;

    // 计算按钮在屏幕上的位置
    final Offset buttonPosition = buttonBox.localToGlobal(Offset.zero);

    // 根据筛选类型获取选项列表
    final List<String> options = _getFilterOptions(filterType);

    // 计算菜单宽度：基于选项文本的最大宽度，但至少130，最大不超过屏幕宽度的80%
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: '',
        style: TextStyle(fontSize: 14.sp, fontFamily: 'Open Sans'),
      ),
    );

    double maxTextWidth = 0;
    for (final option in options) {
      textPainter.text = TextSpan(
        text: option,
        style: TextStyle(
          fontSize: 14.sp,
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.w400,
        ),
      );
      textPainter.layout();
      if (textPainter.width > maxTextWidth) {
        maxTextWidth = textPainter.width;
      }
    }

    // 菜单宽度 = 文本最大宽度 + 左右padding（15 * 2）+ 一些额外空间
    final double screenWidth = overlayBox.size.width;
    const double minMenuWidth = 130.0;
    const double maxMenuWidthPercent = 0.8;
    const double horizontalPadding = 30.0; // 左右各15
    final double calculatedWidth = maxTextWidth + horizontalPadding;
    final double menuWidth = calculatedWidth.clamp(
      minMenuWidth,
      screenWidth * maxMenuWidthPercent,
    );

    final double estimatedMenuHeight =
        (options.length * 30.0) + 30.0; // 每个选项约30，加上padding

    // 菜单中心对齐到按钮中心，这样菜单就在按钮正下方居中
    final double buttonCenterX = buttonPosition.dx + (buttonBox.size.width / 2);
    final double menuLeft = buttonCenterX - (menuWidth / 2);

    // 菜单顶部位置：按钮底部 + 4.h 间距
    final double menuTop = buttonPosition.dy + buttonBox.size.height + 4.h;
    final double menuBottom = menuTop + estimatedMenuHeight;

    // 检查溢出并调整位置
    final double screenHeight = overlayBox.size.height;
    double finalMenuTop = menuTop;
    double finalMenuLeft = menuLeft;

    // 如果菜单底部超出屏幕，向上调整
    if (menuBottom > screenHeight) {
      finalMenuTop = screenHeight - estimatedMenuHeight - 4.h;
      if (finalMenuTop < 0) {
        finalMenuTop = 4.h;
      }
    }

    // 检查右侧溢出
    if (finalMenuLeft + menuWidth > overlayBox.size.width) {
      finalMenuLeft = overlayBox.size.width - menuWidth - 16.w;
    }

    // 检查左侧溢出
    if (finalMenuLeft < 0) {
      finalMenuLeft = 16.w;
    }

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        finalMenuLeft,
        finalMenuTop,
        overlayBox.size.width - finalMenuLeft - menuWidth,
        screenHeight - finalMenuTop - estimatedMenuHeight,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      color: Colors.white,
      elevation: 0,
      items: options
          .map(
            (option) => PopupMenuItem<String>(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              value: option,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    option,
                    style: TextStyle(
                      color: const Color(0xFF1C1C1E),
                      fontSize: 14.sp,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w400,
                      height: 1.20,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    ).then((selectedValue) {
      if (selectedValue != null) {
        // TODO(developer): 处理选中的筛选选项
      }
    });
  }

  /// 获取筛选选项列表
  ///
  /// 根据筛选类型返回对应的选项列表。
  List<String> _getFilterOptions(String filterType) {
    switch (filterType) {
      case 'Status':
        return ['All', 'Read', 'Unread', 'Not Reply'];
      case 'Tag':
        return ['All Tags', 'VIP', 'New', 'Refer by fd'];
      case 'Assignee':
        return ['All Assignees', 'Unassigned', 'Assigned'];
      default:
        return [];
    }
  }

  /// 显示标签筛选弹窗
  ///
  /// 显示标签选择对话框，包含已选标签区域、标签选择区域和筛选按钮。
  void _showTagFilterDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (dialogContext) => const _TagFilterDialog(),
    );
  }

  /// 显示频道下拉弹窗
  ///
  /// 显示频道选择对话框，包含可滚动的频道列表。
  /// 弹窗位置紧贴在按钮正下方。
  void _showChannelDropdown(BuildContext context) {
    // 获取按钮的 RenderBox
    final RenderBox? buttonBox = context.findRenderObject() as RenderBox?;
    if (buttonBox == null) return;

    // 获取 overlay 的 RenderBox
    final RenderBox? overlayBox =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (overlayBox == null) return;

    // 计算按钮在屏幕上的位置（包括所有容器的位置）
    final Offset buttonPosition = buttonBox.localToGlobal(Offset.zero);
    final buttonSize = buttonBox.size;

    // 弹窗尺寸
    const double dialogWidth = 220.0;
    const double maxDialogHeight = 400.0; // 最大高度，实际高度根据内容调整

    // 计算弹窗位置：按钮正下方，右对齐按钮右边缘
    // 根据实际间距调整：右移40像素，上移60像素，使弹窗紧贴按钮
    final double dialogLeft =
        buttonPosition.dx + buttonSize.width - dialogWidth + 80.0;
    // 使用按钮底部位置，上移60像素消除间距
    final double dialogTop = buttonPosition.dy + buttonSize.height - 45.0;

    // 检查溢出并调整位置
    final double screenWidth = overlayBox.size.width;
    final double screenHeight = overlayBox.size.height;
    double finalLeft = dialogLeft;
    double finalTop = dialogTop;

    // 检查右侧溢出
    if (finalLeft + dialogWidth > screenWidth) {
      finalLeft = screenWidth - dialogWidth - 16;
    }

    // 检查左侧溢出
    if (finalLeft < 0) {
      finalLeft = 5;
    }

    // 检查底部溢出，如果溢出则显示在按钮上方
    if (finalTop + maxDialogHeight > screenHeight) {
      finalTop = buttonPosition.dy - maxDialogHeight;
      // 如果上方也不够，则调整到可见区域
      if (finalTop < 0) {
        finalTop = 16;
      }
    }

    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (dialogContext) => Stack(
        children: [
          // 透明遮罩，点击关闭
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(dialogContext).pop(),
              child: Container(color: Colors.transparent),
            ),
          ),
          // 弹窗内容
          Positioned(
            left: finalLeft,
            top: finalTop,
            child: const _ChannelDropdownDialog(),
          ),
        ],
      ),
    );
  }

  /// 构建聊天列表
  ///
  /// 显示所有聊天会话的列表。
  Widget _buildChatList() => SingleChildScrollView(
    child: Column(
      children: [
        _buildChatItem(
          avatarColor: const Color(0xFFC4DFFA),
          name: 'Archived',
          time: '5m',
          message: 'All the archived conversation from WhatsApp',
        ),
        _buildDivider(),
        _buildChatItem(
          avatarUrl: 'https://placehold.co/52x52',
          name: 'Renaldy 1984',
          time: '1h',
          message: 'Start a new conversation',
          unreadCount: 3,
        ),
        _buildDivider(),
        _buildChatItem(
          avatarColor: const Color(0xFFC4DFFA),
          avatarInitial: 'S',
          name: 'Samuel Morganisa',
          time: 'Fri',
          message: 'How much this product?',
          unreadCount: 99,
        ),
        _buildDivider(),
        _buildChatItem(
          avatarUrl: 'https://placehold.co/52x52',
          name: 'Zahra Hussein',
          time: '1w',
          unreadCount: 100,
          message:
              'That works, i was actually planning to get a smoothie anyways👍 ',
          tags: [
            TagItem(text: 'Flutter', color: Colors.blue, filled: true),
            TagItem(text: 'Dart', color: Colors.orange, filled: false),
            TagItem(text: 'Riverpod', color: Colors.green, filled: true),
            TagItem(text: 'Hooks', color: Colors.purple, filled: false),
            TagItem(text: 'Firebase', color: Colors.red, filled: true),
            TagItem(text: 'BLoC', color: Colors.cyan, filled: false),
            TagItem(text: 'GetX', color: Colors.indigo, filled: true),
            TagItem(text: 'Flutter', color: Colors.blue, filled: true),
            TagItem(text: 'Dart', color: Colors.orange, filled: false),
            TagItem(text: 'Riverpod', color: Colors.green, filled: true),
            TagItem(text: 'Hooks', color: Colors.purple, filled: false),
            TagItem(text: 'Firebase', color: Colors.red, filled: true),
            TagItem(text: 'BLoC', color: Colors.cyan, filled: false),
            TagItem(text: 'GetX', color: Colors.indigo, filled: true),
          ],
        ),
        _buildDivider(),
        _buildChatItem(
          avatarUrl: 'https://placehold.co/52x52',
          name: 'Valentina Díaz',
          time: '1w',
          message: 'Typing...',
          tags: [
            TagItem(text: 'New', color: const Color(0xFFFFC107)),
            TagItem(text: 'no package', color: const Color(0xFF808080)),
          ],
        ),
        _buildDivider(),
        _buildChatItem(
          avatarUrl: 'https://placehold.co/52x52',
          name: 'Neeraj Das',
          time: '07/29/25',
          message: 'Where is the office?',
        ),
        _buildDivider(),
        _buildChatItem(
          avatarUrl: 'https://placehold.co/52x52',
          name: 'Anastasia Murphy',
          time: '07/29/25',
          message: 'Start a new conversation',
        ),
      ],
    ),
  );

  /// 构建聊天项
  ///
  /// 显示单个聊天会话的信息，包括头像、名称、时间、消息预览、未读数和标签。
  Widget _buildChatItem({
    String? avatarUrl,
    Color? avatarColor,
    String? avatarInitial,
    required String name,
    required String time,
    required String message,
    int? unreadCount,
    List<TagItem>? tags,
  }) => Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 头像
        _buildChatAvatar(
          url: avatarUrl,
          color: avatarColor,
          initial: avatarInitial,
        ),
        SizedBox(width: 10.w),

        // 内容区域和右侧按钮
        Expanded(
          child: Row(
            children: [
              // 内容区域（名称、时间、消息、标签）
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 名称和时间
                    Row(
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: const Color(0xFF1C1C1E),
                            fontSize: 14.sp,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w700,
                            height: 1.20,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          width: 4.w,
                          height: 4.h,
                          decoration: const ShapeDecoration(
                            color: Color(0xFF949494),
                            shape: OvalBorder(),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          time,
                          style: TextStyle(
                            color: const Color(0xFF949494),
                            fontSize: 12.sp,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w400,
                            height: 1.20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),

                    // 消息预览和标签
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            message,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFF545454),
                              fontSize: 12.sp,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w400,
                              height: 1.20,
                            ),
                          ),
                        ),
                        if (tags != null && tags.isNotEmpty) ...[
                          SizedBox(height: 5.h),
                          LimitedTagWrap(tags: tags),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: 10.w),

              // 右侧：未读数和更多按钮（垂直居中）
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (unreadCount != null && unreadCount > 0) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 9.w,
                        vertical: 5.h,
                      ),
                      decoration: ShapeDecoration(
                        color: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                      ),
                      child: Text(
                        unreadCount > 90 ? '99+' : unreadCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                          height: 1.20,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ],
                  SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: IconButton(
                      icon: const Icon(Icons.more_horiz),
                      iconSize: 24.sp,
                      color: const Color(0xFF545454),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: 24.w,
                        minHeight: 24.h,
                      ),
                      onPressed: () {
                        // TODO(developer): 实现更多操作菜单
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );

  /// 构建聊天头像
  ///
  /// 显示用户头像，可以是图片、纯色背景或文字首字母。
  Widget _buildChatAvatar({String? url, Color? color, String? initial}) {
    final hasImage = url != null;
    final hasColor = color != null;
    final hasInitial = initial != null;

    return SizedBox(
      width: 54.w,
      height: 54.h,
      child: Stack(
        children: [
          // 主头像
          Positioned(
            left: 1.w,
            top: 1.h,
            child: Container(
              width: 52.w,
              height: 52.h,
              decoration: ShapeDecoration(
                image: hasImage
                    ? DecorationImage(
                        image: NetworkImage(url),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: hasImage
                    ? null
                    : (hasColor ? color : const Color(0xFFC4DFFA)),
                shape: hasImage
                    ? RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 3.25,
                          color: Color(0x191E1E1E),
                        ),
                        borderRadius: BorderRadius.circular(96.30.r),
                      )
                    : const OvalBorder(),
              ),
              child: hasInitial && !hasImage
                  ? Center(
                      child: Text(
                        initial,
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 30.sp,
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w700,
                          height: 1.20,
                        ),
                      ),
                    )
                  : null,
            ),
          ),

          // 在线状态指示器
          Positioned(
            left: 30.w,
            top: 30.h,
            child: Container(
              width: 24.w,
              height: 24.h,
              decoration: const ShapeDecoration(
                color: Color(0xFFD2F2F6),
                shape: OvalBorder(
                  side: BorderSide(width: 2, color: Color(0xFFFAFCFF)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建分隔线
  ///
  /// 显示聊天项之间的分隔线。
  Widget _buildDivider() => Container(
    width: double.infinity,
    height: 1,
    color: const Color(0xFFDCECFC),
  );

  /// 构建底部浮动按钮
  ///
  /// 显示新建聊天按钮。
  Widget _buildFloatingActionButton() => Container(
    width: 70.w,
    height: 70.h,
    decoration: ShapeDecoration(
      color: const Color(0xFFC4DFFA),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(58.33.r),
      ),
    ),
    child: Icon(Icons.add, color: AppTheme.primaryColor, size: 45.sp),
  );
}

/// 聊天标签数据类
///
/// 用于表示聊天项的标签信息。
class _ChatTag {
  /// 创建聊天标签实例
  const _ChatTag({
    required this.text,
    required this.color,
    this.isOutline = false,
    this.isFilled = false,
  });

  /// 标签文本
  final String text;

  /// 标签颜色
  final Color color;

  /// 是否为轮廓样式
  final bool isOutline;

  /// 是否为填充样式（半透明填充）
  final bool isFilled;
}

/// 标签筛选弹窗
///
/// 显示标签选择对话框，包含标题、已选标签、标签选择区域和筛选按钮。
class _TagFilterDialog extends StatefulWidget {
  /// 创建标签筛选弹窗实例
  const _TagFilterDialog();

  @override
  State<_TagFilterDialog> createState() => _TagFilterDialogState();
}

/// 标签筛选弹窗状态
class _TagFilterDialogState extends State<_TagFilterDialog> {
  /// 已选中的标签列表
  final Set<String> _selectedTags = {};

  /// 滚动控制器
  final ScrollController _scrollController = ScrollController();

  /// 是否显示滚动条
  bool _showScrollbar = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollbar);
    // 延迟检查，等待布局完成
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScrollbarVisibility();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollbar);
    _scrollController.dispose();
    super.dispose();
  }

  /// 更新滚动条状态
  ///
  /// 根据滚动位置和内容高度判断是否需要显示滚动条。
  void _updateScrollbar() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final shouldShow = maxScroll > 0;
      if (_showScrollbar != shouldShow) {
        setState(() {
          _showScrollbar = shouldShow;
        });
      }
    }
  }

  /// 检查滚动条可见性
  ///
  /// 在布局完成后检查内容是否超出容器高度。
  void _checkScrollbarVisibility() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      if (_showScrollbar != (maxScroll > 0)) {
        setState(() {
          _showScrollbar = maxScroll > 0;
        });
      }
    }
  }

  /// 所有可用的标签列表
  final List<_FilterTagData> _availableTags = const [
    _FilterTagData(text: 'VIP', color: Color(0xFFFFC107), opacity: 0.1),
    _FilterTagData(
      text: '6 months package',
      color: Color(0xFFB7C62F),
      opacity: 0.1,
    ),
    _FilterTagData(text: 'CNY', color: Color(0xFFFF0745), opacity: 0.1),
    _FilterTagData(text: 'VIP', color: Color(0xFFED770A), opacity: 0.2),
    _FilterTagData(text: 'New', color: Color(0xFF675CED), opacity: 0.2),
    _FilterTagData(
      text: 'Welcome gift',
      color: Color(0xFFED770A),
      isOutline: true,
    ),
    _FilterTagData(text: 'refer by fd', color: Color(0xFF50AE55), opacity: 0.2),
    _FilterTagData(text: 'CNY', color: Color(0xFFFFC107), opacity: 0.1),
    _FilterTagData(text: 'HK', color: Color(0xFF48D68F), isOutline: true),
    _FilterTagData(
      text: 'CB client',
      color: Color(0xFF58BFCC),
      isOutline: true,
    ),
    _FilterTagData(
      text: 'no package',
      color: Color(0xFF808080),
      isOutline: true,
    ),
    _FilterTagData(text: 'New', color: Color(0xFFFFC107), isOutline: true),
    _FilterTagData(text: 'refer by fd', color: Color(0xFF48D68F), opacity: 0.1),
    _FilterTagData(text: 'HK', color: Color(0xFF58BFCC), opacity: 0.2),
    _FilterTagData(
      text: 'Welcome gift',
      color: Color(0xFFED770A),
      opacity: 0.2,
    ),
    _FilterTagData(
      text: '6 months package',
      color: Color(0xFFB7C62F),
      isOutline: true,
    ),
    _FilterTagData(
      text: 'Blacklist',
      color: Color(0xFF404040),
      backgroundColor: Color(0xFFB3B3B3),
    ),
    _FilterTagData(text: 'New', color: Color(0xFFFFC107), isOutline: true),
    _FilterTagData(text: 'refer by fd', color: Color(0xFF48D68F), opacity: 0.1),
    _FilterTagData(text: 'HK', color: Color(0xFF58BFCC), opacity: 0.2),
    _FilterTagData(
      text: 'Welcome gift',
      color: Color(0xFFED770A),
      opacity: 0.2,
    ),
    _FilterTagData(text: 'New', color: Color(0xFFFFC107), isOutline: true),
    _FilterTagData(text: 'refer by fd', color: Color(0xFF48D68F), opacity: 0.1),
    _FilterTagData(text: 'HK', color: Color(0xFF58BFCC), opacity: 0.2),
    _FilterTagData(
      text: 'Welcome gift',
      color: Color(0xFFED770A),
      opacity: 0.2,
    ),
    _FilterTagData(text: 'New', color: Color(0xFFFFC107), isOutline: true),
    _FilterTagData(text: 'refer by fd', color: Color(0xFF48D68F), opacity: 0.1),
    _FilterTagData(text: 'HK', color: Color(0xFF58BFCC), opacity: 0.2),
    _FilterTagData(
      text: 'Welcome gift',
      color: Color(0xFFED770A),
      opacity: 0.2,
    ),
    _FilterTagData(text: 'New', color: Color(0xFFFFC107), isOutline: true),
    _FilterTagData(text: 'refer by fd', color: Color(0xFF48D68F), opacity: 0.1),
    _FilterTagData(text: 'HK', color: Color(0xFF58BFCC), opacity: 0.2),
    _FilterTagData(
      text: 'Welcome gift',
      color: Color(0xFFED770A),
      opacity: 0.2,
    ),
    _FilterTagData(text: 'New', color: Color(0xFFFFC107), isOutline: true),
    _FilterTagData(text: 'refer by fd', color: Color(0xFF48D68F), opacity: 0.1),
    _FilterTagData(text: 'HK', color: Color(0xFF58BFCC), opacity: 0.2),
    _FilterTagData(
      text: 'Welcome gift',
      color: Color(0xFFED770A),
      opacity: 0.2,
    ),
  ];

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: 382.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 15,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题区域
          _buildTitleSection(context),
          SizedBox(height: 15.h),

          // 分隔线
          _buildDivider(),
          SizedBox(height: 15.h),

          // 已选标签区域（如果有选中的标签）
          if (_selectedTags.isNotEmpty) ...[
            _buildSelectedTagsSection(),
            SizedBox(height: 15.h),
            _buildDivider(),
            SizedBox(height: 15.h),
          ],

          // 标签选择区域（可滚动）
          _buildTagsSelectionArea(),
          SizedBox(height: 15.h),

          // Filter Tags 按钮
          _buildFilterButton(),
        ],
      ),
    ),
  );

  /// 构建标题区域
  ///
  /// 包含标题、描述文字和关闭按钮。
  Widget _buildTitleSection(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tags',
              style: TextStyle(
                color: const Color(0xFF404040),
                fontSize: 18.sp,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w700,
                height: 1.20,
              ),
            ),
            SizedBox(height: 6.h),
            SizedBox(
              width: 304.w,
              child: Text(
                'Choose your tags to filter.',
                style: TextStyle(
                  color: const Color(0xFF949494),
                  fontSize: 14.sp,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w400,
                  height: 1.20,
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(width: 10.w),
      // 关闭按钮
      Container(
        width: 36.w,
        height: 36.h,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(),
        child: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF404040)),
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    ],
  );

  /// 构建分隔线
  Widget _buildDivider() => Opacity(
    opacity: 0.50,
    child: Container(
      width: double.infinity,
      height: 1.h,
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Color(0xFFC4DFFA),
          ),
        ),
      ),
    ),
  );

  /// 构建已选标签区域
  Widget _buildSelectedTagsSection() => Wrap(
    spacing: 10.w,
    runSpacing: 10.h,
    children: _selectedTags.map((tagText) {
      final tagData = _availableTags.firstWhere(
        (tag) => tag.text == tagText,
        orElse: () => _availableTags.first,
      );
      return _buildTagChip(
        tagData: tagData,
        isSelected: true,
        onTap: () {
          setState(() {
            _selectedTags.remove(tagText);
          });
        },
      );
    }).toList(),
  );

  /// 构建标签选择区域
  ///
  /// 可滚动的标签列表，高度180，支持多行显示和滚动。
  /// 仅在内容超出高度时显示。
  Widget _buildTagsSelectionArea() => SizedBox(
    width: double.infinity,
    height: 180.h,
    child: Stack(
      children: [
        // 标签列表（可滚动）
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            // 监听滚动通知，更新滚动条位置
            if (notification is ScrollUpdateNotification ||
                notification is ScrollEndNotification) {
              setState(() {
                // 触发重建以更新滚动条位置
              });
            }
            return false;
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: _availableTags.map((tagData) {
                final isSelected = _selectedTags.contains(tagData.text);
                return _buildTagChip(
                  tagData: tagData,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedTags.remove(tagData.text);
                      } else {
                        _selectedTags.add(tagData.text);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ),
        // 右侧滚动条（仅在有内容超出时显示）
        if (_showScrollbar)
          Positioned(right: 4.w, top: 4.h, child: _buildCustomScrollbar()),
      ],
    ),
  );

  /// 构建自定义滚动条
  ///
  /// 显示可拖拽的滚动条，支持点击和拖拽滚动。
  /// 滑块位置和大小根据当前滚动位置动态计算。
  Widget _buildCustomScrollbar() {
    if (!_scrollController.hasClients) {
      return const SizedBox.shrink();
    }

    final position = _scrollController.position;
    final maxScroll = position.maxScrollExtent;
    final currentScroll = position.pixels;
    final viewportHeight = position.extentInside;
    final contentHeight = position.extentTotal;

    // 计算滚动条轨道和滑块的高度
    final trackHeight = 171.h;
    // 滑块高度 = 可视区域高度 / 总内容高度 * 轨道高度
    final thumbHeight = (viewportHeight / contentHeight * trackHeight).clamp(
      20.0,
      trackHeight,
    );
    // 滑块顶部位置 = 当前滚动位置 / 最大滚动位置 * (轨道高度 - 滑块高度)
    final thumbTop = maxScroll > 0
        ? (currentScroll / maxScroll * (trackHeight - thumbHeight)).clamp(
            0.0,
            trackHeight - thumbHeight,
          )
        : 0.0;

    return GestureDetector(
      onVerticalDragStart: (_) {
        // 拖拽开始
      },
      onVerticalDragUpdate: (details) {
        if (!_scrollController.hasClients || maxScroll <= 0) return;
        final dragDelta = details.delta.dy;
        // 将拖拽距离转换为滚动距离
        final scrollRatio = dragDelta / (trackHeight - thumbHeight);
        final scrollDelta = scrollRatio * maxScroll;
        final newScroll = (_scrollController.position.pixels + scrollDelta)
            .clamp(0.0, maxScroll);
        _scrollController.jumpTo(newScroll);
      },
      onTapDown: (details) {
        if (!_scrollController.hasClients || maxScroll <= 0) return;
        final localY = details.localPosition.dy;
        // 点击位置对应的滚动比例
        final scrollRatio = (localY / trackHeight).clamp(0.0, 1.0);
        final targetScroll = scrollRatio * maxScroll;
        _scrollController.jumpTo(targetScroll);
      },
      child: Container(
        width: 6.w,
        height: trackHeight,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: const Color(0xFFF4F4F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.40.r),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 1.w,
              top: thumbTop,
              child: Container(
                width: 4.w,
                height: thumbHeight,
                decoration: ShapeDecoration(
                  color: const Color(0xFF89BFF5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建标签芯片
  Widget _buildTagChip({
    required _FilterTagData tagData,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    Color backgroundColor;
    Color textColor;
    BorderSide? borderSide;

    if (tagData.isOutline) {
      backgroundColor = Colors.white;
      textColor = tagData.color;
      borderSide = BorderSide(width: 1, color: tagData.color);
    } else if (tagData.backgroundColor != null) {
      backgroundColor = tagData.backgroundColor!;
      textColor = tagData.color;
    } else {
      backgroundColor = tagData.color.withOpacity(tagData.opacity ?? 0.2);
      textColor = tagData.color;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 20.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            side: borderSide ?? BorderSide.none,
            borderRadius: BorderRadius.circular(40.r),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              tagData.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 12.sp,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w600,
                height: 1.20,
              ),
            ),
            if (isSelected) ...[
              SizedBox(width: 5.w),
              Container(
                width: 12.w,
                height: 12.h,
                decoration: const ShapeDecoration(
                  color: Color(0xFF1480EB),
                  shape: OvalBorder(),
                ),
                child: Icon(Icons.check, size: 8.sp, color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 构建筛选按钮
  Widget _buildFilterButton() => SizedBox(
    width: double.infinity,
    height: 48.h,
    child: ElevatedButton(
      onPressed: () {
        // TODO(developer): 处理筛选逻辑
        Navigator.of(context).pop();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1480EB),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        elevation: 0,
      ),
      child: Text(
        'Filter Tags',
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
  );
}

/// 标签筛选数据类
class _FilterTagData {
  /// 创建标签筛选数据实例
  const _FilterTagData({
    required this.text,
    required this.color,
    this.opacity,
    this.isOutline = false,
    this.backgroundColor,
  });

  /// 标签文本
  final String text;

  /// 标签颜色
  final Color color;

  /// 透明度（用于填充样式）
  final double? opacity;

  /// 是否为轮廓样式
  final bool isOutline;

  /// 背景颜色（用于特殊标签，如 Blacklist）
  final Color? backgroundColor;
}

/// 频道下拉弹窗
///
/// 显示频道选择对话框，包含可滚动的频道列表。
class _ChannelDropdownDialog extends StatefulWidget {
  /// 创建频道下拉弹窗实例
  const _ChannelDropdownDialog();

  @override
  State<_ChannelDropdownDialog> createState() => _ChannelDropdownDialogState();
}

/// 频道下拉弹窗状态
class _ChannelDropdownDialogState extends State<_ChannelDropdownDialog> {
  /// 滚动控制器
  final ScrollController _scrollController = ScrollController();

  /// 是否显示滚动条
  bool _showScrollbar = false;

  /// 频道数据列表
  final List<_ChannelData> _channels = const [
    _ChannelData(label: 'All', hasIcon: false),
    _ChannelData(label: 'Shenzhen branch', hasIcon: true),
    _ChannelData(label: 'Causeway Bay Branch', hasIcon: false),
    _ChannelData(label: 'Tuen Mun Branch', hasIcon: false),
    _ChannelData(label: 'Tsim Sha Tsui Branch', hasIcon: true),
    _ChannelData(label: 'Shenzhen branch', hasIcon: true),
    _ChannelData(label: 'Causeway Bay Branch', hasIcon: false),
    _ChannelData(label: 'Tuen Mun Branch', hasIcon: false),
    _ChannelData(label: 'Tsim Sha Tsui Branch', hasIcon: true),
    _ChannelData(label: 'Shenzhen branch', hasIcon: true),
    _ChannelData(label: 'Tsim Sha Tsui Branch', hasIcon: true),
    _ChannelData(label: 'Shenzhen branch', hasIcon: true),
    _ChannelData(label: 'Causeway Bay Branch', hasIcon: false),
    _ChannelData(label: 'Tuen Mun Branch', hasIcon: false),
    _ChannelData(label: 'Tsim Sha Tsui Branch', hasIcon: true),
    _ChannelData(label: 'Shenzhen branch', hasIcon: true),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollbar);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScrollbarVisibility();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollbar);
    _scrollController.dispose();
    super.dispose();
  }

  /// 更新滚动条状态
  ///
  /// 根据内容高度判断是否需要显示滚动条（内容高度超过400时显示）。
  void _updateScrollbar() {
    if (_scrollController.hasClients) {
      final contentHeight = _scrollController.position.extentTotal;
      const double maxHeight = 400.0;
      final shouldShow = contentHeight > maxHeight;
      if (_showScrollbar != shouldShow) {
        setState(() {
          _showScrollbar = shouldShow;
        });
      }
    }
  }

  /// 检查滚动条可见性
  ///
  /// 如果内容高度超过400，则显示滚动条。
  void _checkScrollbarVisibility() {
    if (_scrollController.hasClients) {
      final contentHeight = _scrollController.position.extentTotal;
      const double maxHeight = 400.0;
      final shouldShow = contentHeight > maxHeight;
      if (_showScrollbar != shouldShow) {
        setState(() {
          _showScrollbar = shouldShow;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const double maxHeight = 400.0;
    return Container(
      width: 220.w,
      constraints: BoxConstraints(maxHeight: maxHeight),
      padding: EdgeInsets.only(
        left: 15.w,
        right: 15.w,
        bottom: 15.h,
      ), // 移除顶部 padding，让内容紧贴按钮
      alignment: AlignmentGeometry.centerLeft,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 15,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // 频道列表（可滚动）
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification ||
                  notification is ScrollEndNotification) {
                setState(() {
                  // 触发重建以更新滚动条位置
                });
              }
              return false;
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _channels.map((channel) {
                  return _buildChannelDropdownItem(channel);
                }).toList(),
              ),
            ),
          ),
          // 右侧滚动条（仅在内容高度超过400时显示）
          if (_showScrollbar)
            Positioned(left: 209.w, top: 2.h, child: _buildCustomScrollbar()),
        ],
      ),
    );
  }

  /// 构建频道下拉项
  Widget _buildChannelDropdownItem(_ChannelData channel) => Container(
    height: 34.h,
    padding: EdgeInsets.symmetric(vertical: 4.h),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (channel.hasIcon) ...[
          Container(
            width: 24.w,
            height: 24.h,
            decoration: const BoxDecoration(
              color: Color(0xFFC4DFFA),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 5.w),
        ],
        Text(
          channel.label,
          style: TextStyle(
            color: const Color(0xFF1C1C1E),
            fontSize: 14.sp,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w400,
            height: 1.20,
          ),
        ),
      ],
    ),
  );

  /// 构建自定义滚动条
  Widget _buildCustomScrollbar() {
    if (!_scrollController.hasClients) {
      return const SizedBox.shrink();
    }

    final position = _scrollController.position;
    final maxScroll = position.maxScrollExtent;
    final currentScroll = position.pixels;
    final viewportHeight = position.extentInside;
    final contentHeight = position.extentTotal;

    // 滚动条轨道高度 = 最大高度400 - 左右padding(15*2) - 滚动条顶部位置(2) - 底部padding(15)
    const double maxHeight = 400.0;
    const double horizontalPadding = 30.0; // 左右padding 15*2
    const double scrollbarTop = 2.0; // 滚动条顶部位置（移除顶部padding后调整为2）
    const double bottomPadding = 15.0; // 底部padding
    final trackHeight =
        (maxHeight - horizontalPadding - scrollbarTop - bottomPadding);
    final thumbHeight = (viewportHeight / contentHeight * trackHeight).clamp(
      20.0,
      trackHeight,
    );
    final thumbTop = maxScroll > 0
        ? (currentScroll / maxScroll * (trackHeight - thumbHeight)).clamp(
            0.0,
            trackHeight - thumbHeight,
          )
        : 0.0;

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (!_scrollController.hasClients || maxScroll <= 0) return;
        final dragDelta = details.delta.dy;
        final scrollRatio = dragDelta / (trackHeight - thumbHeight);
        final scrollDelta = scrollRatio * maxScroll;
        final newScroll = (_scrollController.position.pixels + scrollDelta)
            .clamp(0.0, maxScroll);
        _scrollController.jumpTo(newScroll);
      },
      onTapDown: (details) {
        if (!_scrollController.hasClients || maxScroll <= 0) return;
        final localY = details.localPosition.dy;
        final scrollRatio = (localY / trackHeight).clamp(0.0, 1.0);
        final targetScroll = scrollRatio * maxScroll;
        _scrollController.jumpTo(targetScroll);
      },
      child: Container(
        width: 6.w,
        height: trackHeight,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: const Color(0xFFF4F4F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.40.r),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 1.w,
              top: thumbTop,
              child: Container(
                width: 4.w,
                height: thumbHeight,
                decoration: ShapeDecoration(
                  color: const Color(0xFF89BFF5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 频道数据类
class _ChannelData {
  /// 创建频道数据实例
  const _ChannelData({required this.label, this.hasIcon = false});

  /// 频道名称
  final String label;

  /// 是否有图标
  final bool hasIcon;
}
