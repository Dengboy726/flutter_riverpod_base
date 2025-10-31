import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/local_storage.dart';
import '../constants/app_constants.dart';

/// 主题模式提供者
///
/// 提供全局的主题模式状态（跟随系统/浅色/深色），并支持持久化存储与切换。
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

/// 主题模式状态通知器
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  /// 创建主题模式通知器并从本地存储加载初始模式
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  final LocalStorage _localStorage = LocalStorage.instance;

  /// 从本地存储加载主题模式
  void _loadThemeMode() {
    final themeString = _localStorage.getString(AppConstants.themeKey);
    if (themeString != null) {
      switch (themeString) {
        case 'light':
          state = ThemeMode.light;

        case 'dark':
          state = ThemeMode.dark;

        case 'system':
        default:
          state = ThemeMode.system;
      }
    }
  }

  /// 设置主题模式并持久化
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    String themeString;
    switch (mode) {
      case ThemeMode.light:
        themeString = 'light';
      case ThemeMode.dark:
        themeString = 'dark';
      case ThemeMode.system:
        themeString = 'system';
    }
    await _localStorage.setString(AppConstants.themeKey, themeString);
  }

  /// 顺序切换主题模式（浅色 -> 深色 -> 跟随系统 -> 浅色）
  void toggleTheme() {
    switch (state) {
      case ThemeMode.light:
        setThemeMode(ThemeMode.dark);

      case ThemeMode.dark:
        setThemeMode(ThemeMode.system);

      case ThemeMode.system:
        setThemeMode(ThemeMode.light);
    }
  }
}

/// 语言提供者
///
/// 提供全局语言状态（简体中文/英文），并支持持久化存储与切换。
final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>(
  (ref) => LanguageNotifier(),
);

/// 语言状态通知器
class LanguageNotifier extends StateNotifier<Locale> {
  /// 创建语言状态通知器并从本地存储加载初始语言
  LanguageNotifier() : super(const Locale('zh', 'CN')) {
    _loadLanguage();
  }

  final LocalStorage _localStorage = LocalStorage.instance;

  /// 从本地存储加载语言设置
  void _loadLanguage() {
    final languageCode = _localStorage.getString(AppConstants.languageKey);
    if (languageCode != null) {
      switch (languageCode) {
        case 'en':
          state = const Locale('en', 'US');

        case 'zh':
        default:
          state = const Locale('zh', 'CN');
      }
    }
  }

  /// 设置语言并持久化
  Future<void> setLanguage(Locale locale) async {
    state = locale;
    await _localStorage.setString(
      AppConstants.languageKey,
      locale.languageCode,
    );
  }
}

/// 应用状态提供者
///
/// 提供应用级别的初始化/联网状态与错误消息。
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>(
  (ref) => AppStateNotifier(),
);

/// 应用状态类
class AppState {
  /// 创建应用状态实例
  const AppState({
    this.isInitialized = false,
    this.isOnline = true,
    this.errorMessage,
  });

  /// 应用是否已完成初始化
  final bool isInitialized;

  /// 是否在线
  final bool isOnline;

  /// 全局错误消息（可选）
  final String? errorMessage;

  /// 复制并更新部分字段
  AppState copyWith({
    bool? isInitialized,
    bool? isOnline,
    String? errorMessage,
  }) => AppState(
    isInitialized: isInitialized ?? this.isInitialized,
    isOnline: isOnline ?? this.isOnline,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}

/// 应用状态通知器
class AppStateNotifier extends StateNotifier<AppState> {
  /// 创建应用状态通知器并完成初始化
  AppStateNotifier() : super(const AppState()) {
    _initialize();
  }

  /// 完成启动初始化流程
  void _initialize() {
    state = state.copyWith(isInitialized: true);
  }

  /// 更新在线状态
  void setOnlineStatus({required bool isOnline}) {
    state = state.copyWith(isOnline: isOnline);
  }

  /// 设置全局错误消息
  void setError(String? errorMessage) {
    state = state.copyWith(errorMessage: errorMessage);
  }

  /// 清除全局错误消息
  void clearError() {
    state = state.copyWith();
  }
}
