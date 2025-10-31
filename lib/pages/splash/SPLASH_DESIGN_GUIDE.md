# 启动页设计稿还原指南

本文档用于指导如何根据 Figma 设计稿精确还原启动页面。

**设计稿链接**: https://www.figma.com/design/1FcwsslmpdOy5ouD0hA1fP/DumbChat-2025?node-id=503-7283

## 📋 需要调整的内容清单

### 1. 背景

#### 需要从设计稿获取的值：
- [ ] **背景色**：使用 Figma 拾色器获取精确的 Hex 值（如 `#FFFFFF`）
- [ ] **是否有渐变**：如果有，获取渐变的颜色、方向、停止点
- [ ] **是否有图片背景**：如果有，获取图片路径
- [ ] **是否延伸到状态栏下方**：决定是否需要 SafeArea

#### 在代码中的位置：
```dart
// lib/pages/splash/views/splash_page.dart
Scaffold(
  backgroundColor: const Color(0xFFFFFFFF), // 替换为设计稿中的精确颜色值
  body: SafeArea( // 根据设计稿决定是否需要
    child: _buildContent(),
  ),
)
```

### 2. Logo/图标区域

#### 需要从设计稿获取的值：

**Logo 类型：**
- [ ] **Logo 类型**：图片、图标还是自定义图形？
- [ ] **如果是图片**：图片路径是什么？
- [ ] **如果是图标**：使用哪个图标？
- [ ] **如果是自定义图形**：如何绘制？

**Logo 样式：**
- [ ] **尺寸**：宽度和高度（像素值）
- [ ] **位置**：居中、顶部对齐还是其他位置？
- [ ] **圆角**：如果有圆角，圆角半径是多少？
- [ ] **背景色**：如果有背景，背景色是什么？
- [ ] **阴影**：如果有阴影，阴影的颜色、模糊半径、偏移量是多少？
- [ ] **边框**：如果有边框，边框颜色和宽度是多少？

#### 在代码中的位置：
```dart
// lib/pages/splash/views/splash_page.dart -> _buildLogo()
Container(
  width: 120.w, // 替换为设计稿中的精确值
  height: 120.w, // 替换为设计稿中的精确值
  decoration: BoxDecoration(
    color: const Color(0xFF2196F3), // 替换为设计稿中的精确值
    borderRadius: BorderRadius.circular(24.r), // 替换为设计稿中的精确值
    // 如果设计稿中有阴影，请添加：
    // boxShadow: [...],
  ),
  child: Icon(...), // 根据设计稿调整
)
```

### 3. 标题

#### 需要从设计稿获取的值：
- [ ] **标题文本**：设计稿中的标题是什么？
- [ ] **字体大小**：标题的字体大小（像素值）
- [ ] **字体粗细**：FontWeight 值（如 normal, w500, w600, bold 等）
- [ ] **字体颜色**：标题的颜色（Hex 值）
- [ ] **字间距**：如果有标注，字间距是多少？
- [ ] **文本对齐**：左对齐、居中还是右对齐？
- [ ] **位置**：标题在 Logo 下方多少距离？

#### 在代码中的位置：
```dart
// lib/pages/splash/views/splash_page.dart -> _buildTitle()
Text(
  'DumbChat', // 替换为设计稿中的实际标题
  style: TextStyle(
    fontSize: 32.sp, // 替换为设计稿中的精确值
    fontWeight: FontWeight.bold, // 替换为设计稿中的精确值
    color: const Color(0xFF000000), // 替换为设计稿中的精确值
    letterSpacing: 0.5, // 如果有，使用设计稿中的精确值
  ),
  textAlign: TextAlign.center, // 根据设计稿调整
)
```

### 4. 副标题（如果设计稿中有）

#### 需要从设计稿获取的值：
- [ ] **副标题文本**：设计稿中的副标题是什么？
- [ ] **字体大小**：副标题的字体大小（像素值）
- [ ] **字体粗细**：FontWeight 值
- [ ] **字体颜色**：副标题的颜色（Hex 值）
- [ ] **文本对齐**：左对齐、居中还是右对齐？
- [ ] **位置**：副标题在标题下方多少距离？

#### 在代码中的位置：
```dart
// lib/pages/splash/views/splash_page.dart -> _buildSubtitle()
Text(
  '副标题文本', // 替换为设计稿中的实际文本
  style: TextStyle(
    fontSize: 16.sp, // 替换为设计稿中的精确值
    fontWeight: FontWeight.normal, // 替换为设计稿中的精确值
    color: const Color(0xFF666666), // 替换为设计稿中的精确值
  ),
  textAlign: TextAlign.center, // 根据设计稿调整
)
```

### 5. 加载指示器（如果设计稿中有）

#### 需要从设计稿获取的值：
- [ ] **加载指示器类型**：圆形、线性、点状还是其他？
- [ ] **加载指示器颜色**：使用设计稿中的精确颜色值
- [ ] **加载指示器尺寸**：大小（像素值）
- [ ] **线宽**：如果是指圆形加载器，线宽是多少？
- [ ] **加载文本**：如果有文本，文本内容是什么？
- [ ] **位置**：加载指示器在标题/副标题下方多少距离？

#### 在代码中的位置：
```dart
// lib/pages/splash/views/splash_page.dart -> _buildLoadingIndicator()
CircularProgressIndicator(
  valueColor: AlwaysStoppedAnimation<Color>(
    const Color(0xFF2196F3), // 替换为设计稿中的精确值
  ),
  strokeWidth: 3.0, // 替换为设计稿中的精确值
)
```

### 6. 布局结构

#### 需要从设计稿获取的值：
- [ ] **整体布局**：居中布局还是顶部对齐布局？
- [ ] **元素间距**：Logo 和标题之间的间距、标题和副标题之间的间距等
- [ ] **顶部间距**：如果是顶部对齐，顶部距离多少？

#### 在代码中的位置：
```dart
// lib/pages/splash/views/splash_page.dart -> _buildContent()
// 居中布局
return Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [...],
  ),
);

// 顶部对齐布局
return Column(
  children: [
    SizedBox(height: 100.h), // 替换为设计稿中的精确值
    ...,
  ],
);
```

### 7. 动画效果（如果设计稿中有）

#### 需要从设计稿获取的值：
- [ ] **是否有动画**：设计稿中是否要求动画效果？
- [ ] **动画类型**：淡入、缩放、移动、旋转等
- [ ] **动画时长**：动画持续时间（毫秒）
- [ ] **动画曲线**：easeInOut、easeOut、elasticOut 等
- [ ] **动画延迟**：动画开始前的延迟时间（毫秒）

#### 在代码中的位置：
```dart
// lib/pages/splash/views/splash_page.dart -> _setupAnimations()
_animationController = AnimationController(
  duration: const Duration(milliseconds: 2000), // 替换为设计稿中的精确值
  vsync: this,
);

// 根据设计稿实现动画效果
FadeTransition(...), // 淡入
ScaleTransition(...), // 缩放
SlideTransition(...), // 移动
```

### 8. 其他元素（如果设计稿中有）

#### 需要从设计稿获取的值：
- [ ] **版本号**：如果有，版本号的位置、样式
- [ ] **版权信息**：如果有，版权信息的位置、样式
- [ ] **其他装饰元素**：仅使用设计稿中出现的元素

## 🎨 如何使用 Figma 获取精确值

### 获取颜色值：
1. 在 Figma 中选择元素
2. 在右侧面板找到 "Fill" 或 "Background"
3. 点击颜色选择器，在 Hex 输入框中可以看到颜色值（如 `#FFFFFF`）
4. 在 Flutter 中使用：`Color(0xFFFFFFFF)`（将 `#FFFFFF` 替换为 `0xFFFFFFFF`）

### 获取尺寸值：
1. 在 Figma 中选择元素
2. 查看右侧面板中的宽度（W）和高度（H）
3. 对于间距，选择两个元素，查看它们之间的距离
4. 在 Flutter 中使用：`16.w`（宽度适配）或 `16.h`（高度适配）

### 获取字体信息：
1. 在 Figma 中选择文本元素
2. 查看右侧面板中的字体信息：
   - Font Family（字体族）
   - Font Size（字体大小）
   - Font Weight（字体粗细，如 400, 500, 600, 700）
   - Letter Spacing（字间距）
3. 在 Flutter 中使用：
   - `fontSize: 32.sp`（使用 ScreenUtil 适配）
   - `fontWeight: FontWeight.w600`（600 -> w600, 700 -> bold）

### 获取圆角值：
1. 在 Figma 中选择元素
2. 查看右侧面板中的 "Corner Radius" 或点击元素上的圆角标记
3. 在 Flutter 中使用：`BorderRadius.circular(24.0)`

### 获取阴影参数：
1. 在 Figma 中选择元素
2. 查看右侧面板中的 "Effects" -> "Drop Shadow"
3. 获取以下参数：
   - Color（颜色）
   - Blur（模糊半径）
   - X, Y（偏移量）
   - Spread（扩散范围）
4. 在 Flutter 中使用：`BoxShadow(...)`

### 获取动画信息：
1. 查看设计稿中的交互原型（如果有）
2. 或者查看设计稿的注释说明
3. 如果设计稿中没有动画说明，**不要添加动画**

## ✅ 完成检查清单

在完成所有调整后，请对照以下清单检查：

- [ ] 背景色与设计稿完全一致
- [ ] Logo/图标的样式、尺寸、位置与设计稿完全一致
- [ ] 标题的文本、字体、颜色、位置与设计稿完全一致
- [ ] 副标题（如果有）的文本、字体、颜色、位置与设计稿完全一致
- [ ] 加载指示器（如果有）的类型、颜色、尺寸与设计稿完全一致
- [ ] 所有间距值与设计稿完全一致
- [ ] 布局结构与设计稿完全一致
- [ ] 动画效果（如果有）与设计稿完全一致
- [ ] 没有添加设计稿中未包含的元素（如额外的装饰、动画等）

## 📝 注意事项

1. **严格按照设计稿**：不要添加设计稿中没有的元素
2. **使用精确值**：所有尺寸、颜色、字体大小都必须使用设计稿中的精确值
3. **动画限制**：仅实现设计稿中明确要求的动画，不要添加额外的动画效果
4. **如有疑问**：如果设计稿不清晰或缺失信息，请先与设计师确认，不要自行决定
5. **记录问题**：在代码注释中标注设计稿的缺失信息或与设计师的讨论结果

## 🚫 常见错误

### ❌ 错误示例 1：添加设计稿中没有的阴影
```dart
// ❌ 错误：设计稿中没有阴影，不要添加
decoration: BoxDecoration(
  boxShadow: [
    BoxShadow(...), // 设计稿中没有这个
  ],
)
```

### ❌ 错误示例 2：使用估算的颜色值
```dart
// ❌ 错误：使用相近但不准确的颜色
color: Colors.blue, // 设计稿中可能不是标准 blue

// ✅ 正确：使用设计稿中的精确值
color: const Color(0xFF2196F3), // 从设计稿中获取的精确值
```

### ❌ 错误示例 3：添加设计稿中没有的动画
```dart
// ❌ 错误：设计稿中没有要求动画，不要添加
AnimatedBuilder(
  animation: _controller,
  builder: (context, child) => ..., // 如果设计稿中没有动画
)
```

### ❌ 错误示例 4：修改设计稿中的间距
```dart
// ❌ 错误：随意修改设计稿中的间距
SizedBox(height: 30.h), // 设计稿中是 32，不要随意改动

// ✅ 正确：使用设计稿中的精确值
SizedBox(height: 32.h), // 与设计稿完全一致
```

---

**最后更新**：2024年  
**维护者**：开发团队
