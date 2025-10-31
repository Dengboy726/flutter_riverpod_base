# 设计稿还原规则

本文档定义了在还原设计稿时必须遵守的规则，确保实现与设计稿完全一致，不添加任何无关内容。

## 核心原则

### 1. 严格对照设计稿
- ✅ **必须**：严格按照设计稿进行还原，包括但不限于：
  - 尺寸、间距、边距
  - 颜色、字体、字号
  - 圆角、阴影、边框
  - 布局结构、组件排列
  - 动画效果、交互状态

- ❌ **禁止**：添加设计稿中未包含的内容：
  - 额外的装饰元素（如未设计的图标、分割线）
  - 设计稿中未标注的阴影或渐变
  - 自定义的动画效果（除非设计稿明确要求）
  - 额外的交互反馈（如设计稿未要求的点击效果）

### 2. 尺寸与间距规则

#### 使用设计稿标注的精确值
```dart
// ✅ 正确：使用设计稿中的精确值
Container(
  margin: const EdgeInsets.only(left: 16, top: 12, right: 16), // 来自设计稿
  padding: const EdgeInsets.all(20), // 来自设计稿
)

// ❌ 错误：随意修改或估算值
Container(
  margin: const EdgeInsets.all(15), // 设计稿中是16，不要随意改动
  padding: const EdgeInsets.symmetric(horizontal: 18), // 设计稿中没有这个值
)
```

#### 使用项目常量
```dart
// ✅ 正确：使用项目定义的常量，但确保常量值来自设计稿
Container(
  margin: EdgeInsets.all(UIConstants.spacingMedium), // 值必须与设计稿一致
)

// ❌ 错误：使用未在设计稿中出现的常量值
Container(
  margin: EdgeInsets.all(UIConstants.spacingLarge), // 如果设计稿中没有large间距
)
```

### 3. 颜色规则

#### 严格按照设计稿的颜色值
```dart
// ✅ 正确：使用设计稿中的精确颜色值
Container(
  color: Color(0xFF2196F3), // 设计稿中的主色
)

// 或者使用主题中定义的颜色（值必须与设计稿一致）
Container(
  color: AppTheme.primaryColor, // 确保AppTheme中的值与设计稿一致
)

// ❌ 错误：使用相近但不准确的颜色
Container(
  color: Colors.blue, // 设计稿中可能不是标准blue
  color: Color(0xFF2195F2), // 虽然接近但不准确
)
```

### 4. 字体与文字规则

#### 字体样式必须与设计稿一致
```dart
// ✅ 正确：严格按照设计稿的字体设置
Text(
  '标题',
  style: TextStyle(
    fontSize: 18, // 设计稿中标注的18px
    fontWeight: FontWeight.w600, // 设计稿中标注的600
    color: Color(0xFF333333), // 设计稿中的颜色
    letterSpacing: 0.5, // 设计稿中的字间距
  ),
)

// ❌ 错误：使用设计稿中未标注的字体属性
Text(
  '标题',
  style: TextStyle(
    fontSize: 16, // 设计稿中是18，不要修改
    fontWeight: FontWeight.bold, // 设计稿中是600，不要用bold代替
    decoration: TextDecoration.underline, // 设计稿中没有下划线
  ),
)
```

### 5. 组件使用规则

#### 不使用设计稿中未出现的组件
```dart
// ✅ 正确：使用设计稿中明确出现的组件
Container(
  child: Text('内容'),
)

// ❌ 错误：添加设计稿中没有的装饰组件
Container(
  decoration: BoxDecoration(
    boxShadow: [
      // 设计稿中没有阴影，不要添加
      BoxShadow(...),
    ],
  ),
  child: Text('内容'),
)
```

#### 不添加额外的交互效果
```dart
// ✅ 正确：按照设计稿的交互设计
GestureDetector(
  onTap: () {
    // 设计稿中要求的交互
  },
  child: Container(...),
)

// ❌ 错误：添加设计稿中没有的交互效果
GestureDetector(
  onTap: () {
    // 设计稿中要求的交互
  },
  onLongPress: () {
    // 设计稿中没有长按交互，不要添加
  },
  child: Container(...),
)
```

### 6. 布局规则

#### 严格按照设计稿的布局结构
```dart
// ✅ 正确：按照设计稿的布局
Column(
  children: [
    Text('标题'),
    SizedBox(height: 12), // 设计稿中的间距
    Text('内容'),
  ],
)

// ❌ 错误：添加设计稿中没有的元素
Column(
  children: [
    Text('标题'),
    Divider(), // 设计稿中没有分割线，不要添加
    SizedBox(height: 12),
    Text('内容'),
  ],
)
```

### 7. 动画规则

#### 只实现设计稿中要求的动画
```dart
// ✅ 正确：实现设计稿中明确要求的动画
AnimatedContainer(
  duration: Duration(milliseconds: 300), // 设计稿中指定的动画时长
  // ...
)

// ❌ 错误：添加设计稿中没有的动画
AnimatedContainer(
  duration: Duration(milliseconds: 500), // 设计稿中是300，不要改动
  curve: Curves.bounceOut, // 设计稿中没有这个曲线，不要添加
  // ...
)
```

## 实施检查清单

在提交代码前，请对照以下清单检查：

- [ ] 所有尺寸、间距值是否与设计稿完全一致？
- [ ] 所有颜色值是否与设计稿完全一致？
- [ ] 字体大小、粗细、颜色是否与设计稿完全一致？
- [ ] 是否添加了设计稿中未出现的元素（图标、分割线、阴影等）？
- [ ] 是否添加了设计稿中未要求的交互效果？
- [ ] 是否添加了设计稿中未标注的动画？
- [ ] 布局结构是否与设计稿完全一致？
- [ ] 是否使用了自己估算的值而不是设计稿中的精确值？

## 特殊情况处理

### 如果设计稿不清晰或缺失信息
1. **先询问设计师**，不要自行决定
2. **记录问题**，在代码注释中标注设计稿的缺失信息
3. **等待确认**后再实现，不要使用"看起来合理"的值

### 如果设计稿存在明显错误
1. **与设计师确认**是否为设计意图
2. **不要自行修正**设计稿，即使是明显的错误
3. **记录讨论结果**，在代码注释中说明

## 代码审查标准

### 审查者需要检查：
1. 实现的UI是否与设计稿100%一致？
2. 是否有任何设计稿中未包含的元素？
3. 所有数值是否来自设计稿，而不是估算？
4. 是否遵循了项目的设计系统规范？

### 如果发现不一致：
1. **立即指出**，要求修改
2. **不允许**以"看起来差不多"为由通过
3. **要求提供**设计稿依据或与设计师确认的记录

## 工具建议

### 推荐使用的工具
- **Figma Dev Mode**：可以直接复制代码和标注
- **Pixel Perfect 插件**：帮助精确对齐
- **设计稿标注工具**：确保获取精确的尺寸和颜色值
- **Flutter Inspector**：检查实际渲染效果

### 颜色提取
```dart
// 使用设计稿中的精确颜色值
// 格式：#RRGGBB 转换为 Color(0xAARRGGBB)
// 例如：设计稿 #2196F3 → Color(0xFF2196F3)
```

### 尺寸转换
```dart
// 设计稿通常使用 px，Flutter 使用 dp
// 对于 1:1 的设计稿，通常直接使用相同数值
// 例如：设计稿 16px → 16.0
// 使用 flutter_screenutil 时需要根据设计稿尺寸进行适配
```

## 总结

**核心思想**：设计稿就是标准，代码必须严格按照设计稿实现，不允许添加任何设计稿中未包含的内容。如有疑问，必须先与设计师确认，不能自行决定。

---

**最后更新**：2024年
**维护者**：开发团队
