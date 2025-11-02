import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 标签项
class TagItem {
  /// 创建标签项构造函数
  const TagItem({
    required this.text,
    this.color = Colors.blue,
    this.filled = true,
  });

  /// 标签文本
  final String text;

  /// 标签颜色
  final Color color;

  /// 是否填充
  final bool filled;
}

/// 限制行数的标签包装组件
class LimitedTagWrap extends HookWidget {
  /// 标签颜色
  const LimitedTagWrap({
    required this.tags,
    super.key,
    this.maxLines = 2,
    this.spacing = 6,
    this.runSpacing = 4,
    this.textStyle = const TextStyle(fontSize: 12),
  });

  /// 标签列表
  final List<TagItem> tags;

  /// 最大行数
  final int maxLines;

  /// 水平间距
  final double spacing;

  /// 垂直间距
  final double runSpacing;

  /// 文本样式
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      double currentWidth = 0;
      var currentLine = 1;
      final visibleTags = <TagItem>[];
      var hiddenCount = 0;

      for (var i = 0; i < tags.length; i++) {
        final tag = tags[i];
        final tagWidth = _measureTextWidth(tag.text, textStyle) + 16;

        if (currentWidth + tagWidth + spacing > maxWidth) {
          currentLine++;
          if (currentLine > maxLines) {
            hiddenCount = tags.length - i;
            break;
          }
          currentWidth = 0;
        }

        visibleTags.add(tag);
        currentWidth += tagWidth + spacing;
      }

      if (hiddenCount > 0) {
        final plusTag = TagItem(
          text: '$hiddenCount+',
          color: visibleTags[visibleTags.length - 1].color,
        );
        final plusWidth = _measureTextWidth(plusTag.text, textStyle) + 16;

        // 检查是否放得下 +N
        if (currentWidth + plusWidth <= maxWidth) {
          visibleTags.add(plusTag);
        } else if (visibleTags.isNotEmpty) {
          visibleTags
            ..removeLast()
            ..add(plusTag);
        }
      }

      return Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: visibleTags.map(_buildChip).toList(),
      );
    },
  );

  double _measureTextWidth(String text, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return tp.width;
  }

  Widget _buildChip(TagItem tag) {
    final backgroundColor = tag.filled
        ? tag.color.withOpacity(0.15)
        : Colors.transparent;
    final borderColor = tag.color;
    final textColor = tag.color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: tag.filled ? null : Border.all(color: borderColor),
      ),
      child: Text(tag.text, style: textStyle.copyWith(color: textColor)),
    );
  }
}
