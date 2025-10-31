import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_enterprise_scaffold/core/constants/app_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



/// 应用通用文本输入框
///
/// 封装了常用输入场景（单/多行、可见性切换、前后缀图标、校验与格式化等），
/// 并继承主题的输入装饰样式，适用于表单与独立输入场景。
class AppTextField extends StatefulWidget {
  /// 创建文本输入框组件

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.inputFormatters,
    this.contentPadding,
    this.borderRadius,
    this.fillColor,
    this.filled = false,
    this.autofocus = false,
  });

  /// 标签文本（显示在输入框上方，建议本地化）
  final String? label;

  /// 占位提示（建议本地化）
  final String? hint;

  /// 帮助说明（建议本地化）
  final String? helperText;

  /// 错误提示（外部校验时传入，建议本地化）
  final String? errorText;

  /// 文本控制器
  final TextEditingController? controller;

  /// 键盘类型
  final TextInputType keyboardType;

  /// 键盘动作，默认为完成
  final TextInputAction textInputAction;

  /// 是否密文显示（用于密码）
  final bool obscureText;

  /// 是否可编辑
  final bool enabled;

  /// 是否只读
  final bool readOnly;

  /// 行数控制
  final int? maxLines;

  /// 最小行数
  final int? minLines;

  /// 最大长度
  final int? maxLength;

  /// 前置图标
  final Widget? prefixIcon;

  /// 后置图标
  final Widget? suffixIcon;

  /// 表单校验
  final String? Function(String?)? validator;

  /// 输入变化回调
  final void Function(String)? onChanged;

  /// 提交回调
  final void Function(String)? onSubmitted;

  /// 点击回调
  final void Function()? onTap;

  /// 外部焦点控制
  final FocusNode? focusNode;

  /// 输入格式化器
  final List<TextInputFormatter>? inputFormatters;

  /// 内容内边距
  final EdgeInsetsGeometry? contentPadding;

  /// 圆角半径
  final double? borderRadius;

  /// 填充色
  final Color? fillColor;

  /// 是否填充
  final bool filled;

  /// 是否自动聚焦
  final bool autofocus;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: _obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          focusNode: _focusNode,
          inputFormatters: widget.inputFormatters,
          autofocus: widget.autofocus,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            helperText: widget.helperText,
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: _buildSuffixIcon(),
            contentPadding:
                widget.contentPadding ??
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            filled: widget.filled,
            fillColor:
                widget.fillColor ??
                (widget.filled ? colorScheme.surface : null),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                widget.borderRadius ?? AppConstants.borderRadius,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                widget.borderRadius ?? AppConstants.borderRadius,
              ),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                widget.borderRadius ?? AppConstants.borderRadius,
              ),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                widget.borderRadius ?? AppConstants.borderRadius,
              ),
              borderSide: BorderSide(color: colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                widget.borderRadius ?? AppConstants.borderRadius,
              ),
              borderSide: BorderSide(color: colorScheme.error, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                widget.borderRadius ?? AppConstants.borderRadius,
              ),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 构建后缀图标
  ///
  /// 当 obscureText 为 true 时，提供可见性切换按钮；
  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    return widget.suffixIcon;
  }
}
