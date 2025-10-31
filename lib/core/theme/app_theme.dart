import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_constants.dart';

// ignore: avoid_classes_with_only_static_members
/// 应用主题配置
///
/// 提供明暗两套主题、统一的组件样式与便捷访问方法。
class AppTheme {
  const AppTheme._();
  // 颜色定义
  /// 主色
  static const Color primaryColor = Color(0xFF2196F3);

  /// 主色容器
  static const Color primaryVariant = Color(0xFF1976D2);

  /// 次要色
  static const Color secondaryColor = Color(0xFF03DAC6);

  /// 次要色容器
  static const Color secondaryVariant = Color(0xFF018786);

  /// 表面颜色（卡片、底部导航等）
  static const Color surfaceColor = Color(0xFFFFFFFF);

  /// 背景颜色
  static const Color backgroundColor = Color(0xFFF5F5F5);

  /// 错误颜色
  static const Color errorColor = Color(0xFFB00020);

  /// 主色上的文字/图标颜色
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// 次要色上的文字/图标颜色
  static const Color onSecondary = Color(0xFF000000);

  /// 表面上的文字/图标颜色
  static const Color onSurface = Color(0xFF000000);

  /// 背景上的文字/图标颜色
  static const Color onBackground = Color(0xFF000000);

  /// 错误色上的文字/图标颜色
  static const Color onError = Color(0xFFFFFFFF);

  // 深色主题颜色
  /// 深色主题主色
  static const Color darkPrimaryColor = Color(0xFF90CAF9);

  /// 深色主题主色容器
  static const Color darkPrimaryVariant = Color(0xFF1976D2);

  /// 深色主题次要色
  static const Color darkSecondaryColor = Color(0xFF03DAC6);

  /// 深色主题次要色容器
  static const Color darkSecondaryVariant = Color(0xFF03DAC6);

  /// 深色主题表面颜色
  static const Color darkSurfaceColor = Color(0xFF121212);

  /// 深色主题背景颜色
  static const Color darkBackgroundColor = Color(0xFF000000);

  /// 深色主题错误颜色
  static const Color darkErrorColor = Color(0xFFCF6679);

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
        borderSide: const BorderSide(color: Colors.grey),
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
      unselectedItemColor: Colors.grey,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 4,
      backgroundColor: primaryColor,
      foregroundColor: onPrimary,
    ),
    dividerTheme: const DividerThemeData(thickness: 1, color: Colors.grey),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey[200],
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
        borderSide: const BorderSide(color: Colors.grey),
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
      unselectedItemColor: Colors.grey,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 4,
      backgroundColor: darkPrimaryColor,
      foregroundColor: darkOnPrimary,
    ),
    dividerTheme: const DividerThemeData(thickness: 1, color: Colors.grey),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey[800],
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
