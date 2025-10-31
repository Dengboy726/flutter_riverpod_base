import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../constants/app_constants.dart';
import '../../storage/local_storage.dart';
import '../models/auth_tokens.dart';
import '../models/user.dart';



/// 认证状态类
///
/// 管理用户认证相关的所有状态信息，包括登录状态、用户信息、令牌等。
/// 使用 Freezed 确保状态不可变性和比较的正确性。
@freezed
class AuthState with _$AuthState {
  /// 创建认证状态实例
  ///
  /// 参数:
  /// - [isAuthenticated] 是否已认证，默认为 false
  /// - [isInitialized] 是否已初始化，默认为 false
  /// - [isLoading] 是否正在加载，默认为 false
  /// - [user] 用户信息，可选
  /// - [tokens] 认证令牌，可选
  /// - [error] 错误类型，可选
  /// - [errorMessage] 错误消息，可选
  const factory AuthState({
    @Default(false) bool isAuthenticated,
    @Default(false) bool isInitialized,
    @Default(false) bool isLoading,
    User? user,
    AuthTokens? tokens,
    String? error,
    String? errorMessage,
  }) = _AuthState;
}

/// 认证状态通知器
///
/// 管理用户认证相关的所有业务逻辑，包括登录、注册、登出等操作。
/// 使用 StateNotifier 进行状态管理，确保状态变化能够被监听。
class AuthNotifier extends StateNotifier<AuthState> {
  /// 创建认证通知器实例
  AuthNotifier() : super(const AuthState());

  /// 用户登录
  ///
  /// 参数:
  /// - [email] 用户邮箱
  /// - [password] 用户密码
  ///
  /// 异常:
  /// - [Exception] 当登录失败时抛出
  Future<void> login(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true);

      // 模拟登录逻辑
      await Future<void>.delayed(const Duration(seconds: 1));

      // 模拟成功登录
      final user = User(
        id: '1',
        email: email,
        username: 'test_user',
        firstName: 'Test',
        lastName: 'User',
        isEmailVerified: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final tokens = AuthTokens(
        accessToken: 'mock_access_token',
        refreshToken: 'mock_refresh_token',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
        refreshTokenExpiresAt: DateTime.now().add(
          const Duration(days: 7),
        ), // 刷新令牌 7 天过期
      );

      state = state.copyWith(
        isAuthenticated: true,
        isInitialized: true,
        isLoading: false,
        user: user,
        tokens: tokens,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        errorMessage: e.toString(),
        isInitialized: true,
      );
    }
  }

  /// 用户注册
  ///
  /// 参数:
  /// - [username] 用户名
  /// - [email] 用户邮箱
  /// - [password] 用户密码
  ///
  /// 异常:
  /// - [Exception] 当注册失败时抛出
  Future<void> register(String username, String email, String password) async {
    try {
      state = state.copyWith(isLoading: true);

      // 模拟注册逻辑
      await Future<void>.delayed(const Duration(seconds: 1));

      // 模拟成功注册
      final user = User(
        id: '2',
        email: email,
        username: username,
        firstName: 'New',
        lastName: 'User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final tokens = AuthTokens(
        accessToken: 'mock_access_token',
        refreshToken: 'mock_refresh_token',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
        refreshTokenExpiresAt: DateTime.now().add(
          const Duration(days: 7),
        ), // 刷新令牌 7 天过期
      );

      state = state.copyWith(
        isAuthenticated: true,
        isInitialized: true,
        isLoading: false,
        user: user,
        tokens: tokens,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        errorMessage: e.toString(),
        isInitialized: true,
      );
    }
  }

  /// 用户登出
  ///
  /// 清除用户认证状态和本地存储的令牌信息。
  Future<void> logout() async {
    state = const AuthState(isInitialized: true);
  }

  /// 刷新认证令牌
  ///
  /// 使用刷新令牌获取新的访问令牌，延长用户会话时间。
  ///
  /// 异常:
  /// - [Exception] 当刷新失败时抛出
  Future<void> refreshToken() async {
    try {
      if (state.tokens?.refreshToken == null) {
        await logout();
        return;
      }

      // 模拟刷新令牌逻辑
      await Future<void>.delayed(const Duration(milliseconds: 500));

      final newTokens = AuthTokens(
        accessToken: 'new_mock_access_token',
        refreshToken: 'new_mock_refresh_token',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
        refreshTokenExpiresAt:
            state.tokens?.refreshTokenExpiresAt ??
            DateTime.now().add(
              const Duration(days: 7),
            ), // 保持原有的刷新令牌过期时间或设置为 7 天
      );

      // 保存新的 token 到本地存储
      await LocalStorage.instance.setJson(
        AppConstants.tokensKey,
        newTokens.toJson(),
      );

      state = state.copyWith(isAuthenticated: true, tokens: newTokens);
    } on Exception catch (_) {
      // 刷新失败，登出用户
      await logout();
    }
  }

  /// 初始化认证状态
  ///
  /// 检查本地存储的认证信息并恢复用户会话。
  /// 如果本地存储有有效的 token，则恢复用户会话；否则设置为未认证状态。
  Future<void> initialize() async {
    try {
      state = state.copyWith(isLoading: true);

      // 检查本地存储的 token
      final tokensJson = LocalStorage.instance.getJson(AppConstants.tokensKey);

      if (tokensJson != null) {
        // 解析 token
        final authTokens = AuthTokens.fromJson(tokensJson);

        // 检查刷新令牌是否已过期
        if (authTokens.isRefreshTokenExpired) {
          // 刷新令牌已过期，无法刷新，需要重新登录
          state = state.copyWith(
            isInitialized: true,
            isAuthenticated: false,
            isLoading: false,
          );
          return;
        }

        // 检查访问令牌是否过期
        if (authTokens.isExpired) {
          // Token 已过期，尝试刷新
          // 先设置 tokens 到 state，然后才能调用 refreshToken()
          state = state.copyWith(tokens: authTokens);

          // 尝试刷新 token
          if (authTokens.refreshToken.isNotEmpty) {
            await refreshToken();
            // refreshToken() 会更新状态，如果失败会调用 logout()
            if (state.isAuthenticated) {
              // 刷新成功，恢复用户信息（如果存在）
              final userJson = LocalStorage.instance.getJson(
                AppConstants.userKey,
              );
              if (userJson != null) {
                state = state.copyWith(
                  isInitialized: true,
                  isLoading: false,
                  user: User.fromJson(userJson),
                );
              } else {
                state = state.copyWith(isInitialized: true, isLoading: false);
              }
            } else {
              // 刷新失败，logout() 已经设置了状态，只需确保 isLoading 被重置
              state = state.copyWith(isLoading: false);
            }
          } else {
            // 没有 refresh token，清除状态
            await logout();
            state = state.copyWith(isLoading: false);
          }
          return;
        }

        // Token 有效，恢复会话
        // 同时获取用户信息（如果存在）
        final userJson = LocalStorage.instance.getJson(AppConstants.userKey);

        state = state.copyWith(
          isInitialized: true,
          isAuthenticated: true,
          isLoading: false,
          tokens: authTokens,
          user: userJson != null ? User.fromJson(userJson) : null,
        );
        return;
      }

      // 没有 token 或刷新失败，设置为未认证状态
      state = state.copyWith(
        isInitialized: true,
        isAuthenticated: false,
        isLoading: false,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        isInitialized: true,
        isAuthenticated: false,
        isLoading: false,
        error: e.toString(),
        errorMessage: e.toString(),
      );
    }
  }

  /// 清除错误状态
  ///
  /// 清除当前状态中的错误信息。
  void clearError() {
    state = state.copyWith();
  }
}

/// 认证状态提供者
///
/// 提供全局的认证状态管理，可以在整个应用中访问和监听认证状态变化。
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

/// 认证状态流提供者
///
/// 提供认证状态的流式访问，用于监听状态变化。
final authStateStreamProvider = StreamProvider<AuthState>(
  (ref) => ref.watch(authNotifierProvider.notifier).stream,
);
