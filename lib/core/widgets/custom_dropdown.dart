import 'package:flutter/material.dart';

/// 下拉列表项

class DropdownItem {

  /// 创建下拉列表项
  const DropdownItem({
    required this.label, this.icon,
  });
  /// 图标
  final String? icon;
  /// 标签
  final String label;
}

/// 自定义下拉列表
class Customdropdown extends StatefulWidget { 

  /// 创建自定义下拉列表
  const Customdropdown({
    required this.onChanged, required this.items, super.key,
    this.value,
    this.scrollbarColor = Colors.lightBlue,
  });
  /// 自定义下拉列表
  final List<DropdownItem> items;
  /// 当前选中值
  final DropdownItem? value; 
  /// 选择回调
  final ValueChanged<DropdownItem> onChanged;
  /// 滚动条颜色
  final Color scrollbarColor;

  @override
  State<Customdropdown> createState() => _CustomdropdownState();
}

class _CustomdropdownState extends State<Customdropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  // ✅ 把 ScrollController 提升为成员变量
  final ScrollController _scrollController = ScrollController();

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlay();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlay() {
    /// 获取渲染对象
    final box = context.findRenderObject()! as RenderBox;
    final size = box.size;

    return OverlayEntry(builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, size.height + 4),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              constraints: const BoxConstraints(maxHeight: 150),
              child: ScrollConfiguration(
                behavior: const ScrollBehavior()
                    .copyWith(scrollbars: false), // ✅ 局部关闭默认滚动条
                child: RawScrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  thickness: 6,
                  radius: const Radius.circular(3),
                  thumbColor: widget.scrollbarColor,
                  child: ListView(
                    controller: _scrollController,
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: widget.items.map((item) => InkWell(
                        onTap: () {
                          widget.onChanged(item);
                          _toggleDropdown();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                          child: Row(
                            children: [
                              if (item.icon != null)
                                Image.asset(item.icon!, width: 22, height: 22),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item.label,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ));
  }

  @override
  void dispose() {
    _scrollController.dispose(); // ✅ 记得释放 controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              if (widget.value != null)
                Image.asset(widget.value!.icon!, width: 22, height: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.value?.label ?? 'All',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ),
      ),
    );
}
