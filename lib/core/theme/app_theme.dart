import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_constants.dart';

// ignore: avoid_classes_with_only_static_members
/// 应用主题配置
///
/// 提供明暗两套主题、统一的组件样式与便捷访问方法。
class AppTheme {
  const AppTheme._();
  // ========== Figma Design System Colors ==========

  // Primary Colors（主色）
  /// Azure - 主色（用于 CTA、焦点、激活状态、横幅、表格）
  static const Color primaryColor = Color(0xFF1480EB);

  /// 主色变体（深色）
  static const Color primaryVariant = Color(0xFF0A4075);

  /// Egg Blue - 次要主色
  static const Color primarySecondary = Color(0xFF4DCEDE);

  // Secondary Colors（次要色）
  /// Purple - 紫色次要色
  static const Color secondaryColor = Color(0xFF675CED);

  /// Pink - 粉色次要色
  static const Color secondaryPink = Color(0xFFFE2693);

  /// Orange - 橙色次要色
  static const Color secondaryOrange = Color(0xFFED770A);

  /// Ocean Green - 海洋绿次要色
  static const Color secondaryOceanGreen = Color(0xFF48D68F);

  /// Android Green - 安卓绿次要色
  static const Color secondaryAndroidGreen = Color(0xFFB7C62F);

  /// 次要色容器
  static const Color secondaryVariant = Color(0xFFA49EE7);

  // Neutral Colors（中性色）
  /// Black - 黑色
  static const Color black = Color(0xFF1C1C1E);

  /// Grey-1 - 深灰
  static const Color grey1 = Color(0xFF545454);

  /// Grey-2 - 中深灰
  static const Color grey2 = Color(0xFF959595);

  /// Grey-3 - 中灰
  static const Color grey3 = Color(0xFFC2C2C2);

  /// Grey-4 - 浅灰
  static const Color grey4 = Color(0xFFE5E5E5);

  /// Grey-5 - 极浅灰
  static const Color grey5 = Color(0xFFF4F4F5);

  /// White - 白色
  static const Color white = Color(0xFFFBFEFB);

  /// 表面颜色（卡片、底部导航等）
  static const Color surfaceColor = white;

  /// 背景颜色
  static const Color backgroundColor = grey5;

  // Alert & Status Colors（警告和状态色）
  /// Rose - 错误/警告颜色
  static const Color errorColor = Color(0xFFFF0745);

  /// Pigment Green - 成功颜色（实际为 #50AE55，使用正确的绿色）
  static const Color successColor = Color(0xFF50AE55);

  /// Amber - 警告颜色
  static const Color warningColor = Color(0xFFFFC107);

  // Link Colors（链接色）
  /// Link - 链接颜色
  static const Color linkColor = Color(0xFF007AFF);

  /// Visited Link - 已访问链接颜色
  static const Color visitedLinkColor = Color(0xFFA39DF4);

  /// 主色上的文字/图标颜色（白色）
  static const Color onPrimary = white;

  /// 次要色上的文字/图标颜色（黑色）
  static const Color onSecondary = black;

  /// 表面上的文字/图标颜色（黑色）
  static const Color onSurface = black;

  /// 背景上的文字/图标颜色（黑色）
  static const Color onBackground = black;

  /// 错误色上的文字/图标颜色（白色）
  static const Color onError = white;

  // Dark Theme Colors（深色主题颜色）
  /// 深色主题主色（使用浅色的 Azure）
  static const Color darkPrimaryColor = Color(0xFF4E9FF0);

  /// 深色主题主色容器（使用更亮的 Azure）
  static const Color darkPrimaryVariant = Color(0xFF89BFF5);

  /// 深色主题次要色（使用 Egg Blue）
  static const Color darkSecondaryColor = primarySecondary;

  /// 深色主题次要色容器
  static const Color darkSecondaryVariant = Color(0xFF79DAE6);

  /// 深色主题表面颜色
  static const Color darkSurfaceColor = Color(0xFF1C1C1E);

  /// 深色主题背景颜色
  static const Color darkBackgroundColor = Color(0xFF000000);

  /// 深色主题错误颜色（使用较柔和的红色）
  static const Color darkErrorColor = Color(0xFFFF9BB4);

  /// 深色主题主色上的文字/图标颜色
  static const Color darkOnPrimary = Color(0xFF000000);

  /// 深色主题次要色上的文字/图标颜色
  static const Color darkOnSecondary = Color(0xFF000000);

  /// 深色主题表面上的文字/图标颜色
  static const Color darkOnSurface = Color(0xFFFFFFFF);

  /// 深色主题背景上的文字/图标颜色
  static const Color darkOnBackground = Color(0xFFFFFFFF);

  /// 深色主题错误色上的文字/图标颜色
  static const Color darkOnError = Color(0xFF000000);

  // 浅色主题
  /// 浅色主题配置
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      primaryContainer: primaryVariant,
      secondaryContainer: secondaryVariant,
    ),
    appBarTheme: const AppBarTheme(
      elevation: AppConstants.appBarElevation,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: surfaceColor,
      foregroundColor: onSurface,
    ),
    cardTheme: CardThemeData(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        borderSide: const BorderSide(color: grey3),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        borderSide: const BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 8,
      backgroundColor: surfaceColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: grey2,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 4,
      backgroundColor: primaryColor,
      foregroundColor: onPrimary,
    ),
    dividerTheme: const DividerThemeData(thickness: 1, color: grey4),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: grey5,
      selectedColor: primaryColor,
      labelStyle: const TextStyle(color: onSurface),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
    ),
  );

  // 深色主题
  /// 深色主题配置
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: darkPrimaryColor,
      primaryContainer: darkPrimaryVariant,
      secondaryContainer: darkSecondaryVariant,
    ),
    appBarTheme: const AppBarTheme(
      elevation: AppConstants.appBarElevation,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: darkSurfaceColor,
      foregroundColor: darkOnSurface,
    ),
    cardTheme: CardThemeData(
      elevation: AppConstants.cardElevation,
      color: darkSurfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        borderSide: const BorderSide(color: grey2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        borderSide: const BorderSide(color: darkPrimaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        borderSide: const BorderSide(color: darkErrorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        borderSide: const BorderSide(color: darkErrorColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 8,
      backgroundColor: darkSurfaceColor,
      selectedItemColor: darkPrimaryColor,
      unselectedItemColor: grey3,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 4,
      backgroundColor: darkPrimaryColor,
      foregroundColor: darkOnPrimary,
    ),
    dividerTheme: const DividerThemeData(thickness: 1, color: grey2),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: grey1,
      selectedColor: darkPrimaryColor,
      labelStyle: const TextStyle(color: darkOnSurface),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
    ),
  );

  /// 获取当前主题的文本样式
  static TextTheme getTextTheme(BuildContext context) =>
      Theme.of(context).textTheme;

  /// 获取当前主题的颜色
  static ColorScheme getColorScheme(BuildContext context) =>
      Theme.of(context).colorScheme;

  /// 获取当前主题是否为深色
  static bool isDarkMode(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
}
