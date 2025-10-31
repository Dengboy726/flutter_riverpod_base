import 'package:dio/dio.dart';

import '../../auth/models/auth_tokens.dart';
import '../../storage/local_storage.dart';
import '../../constants/app_constants.dart';
import '../../errors/status_codes.dart';
import '../../utils/logger.dart';

/// 认证拦截器
///
/// 为请求自动添加认证头；当服务端返回未授权时尝试使用刷新令牌刷新访问令牌，
/// 刷新成功后会自动重试原始请求，刷新失败则清除本地认证数据。
///
/// 使用示例:
/// ```dart
/// final dio = Dio()..interceptors.add(AuthInterceptor());
/// ```
class AuthInterceptor extends Interceptor {
  /// 创建认证拦截器
  final LocalStorage _localStorage = LocalStorage.instance;

  @override
  /// 请求发送前拦截
  ///
  /// 为当前请求添加 `Authorization` 头（如有可用的访问令牌）。
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 添加认证头
    _addAuthHeader(options);
    super.onRequest(options, handler);
  }

  @override
  /// 错误拦截
  ///
  /// 当捕获到 401 未授权错误时，尝试刷新令牌并重试原请求；
  /// 刷新失败则清理本地令牌并继续向下抛出错误。
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // 处理401错误，尝试刷新token
    if (err.response?.statusCode == StatusCode.UNAUTHORIZED.value) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        // 重新发送请求
        final newOptions = err.requestOptions;
        _addAuthHeader(newOptions);

        try {
          final response = await Dio().fetch<Response<dynamic>>(newOptions);
          handler.resolve(response);
          return;
        } on Exception catch (_) {
          // 刷新失败，清除本地token
          await _clearAuthData();
          AppLogger.warning('令牌刷新失败，清除认证数据');
        }
      } else {
        // 刷新失败，清除本地token
        await _clearAuthData();
        AppLogger.warning('令牌刷新失败，清除认证数据');
      }
    }

    super.onError(err, handler);
  }

  /// 为请求添加认证头
  void _addAuthHeader(RequestOptions options) {
    final tokensJson = _localStorage.getJson(AppConstants.tokensKey);
    if (tokensJson != null) {
      try {
        final tokens = AuthTokens.fromJson(tokensJson);
        if (tokens.accessToken.isNotEmpty) {
          options.headers['Authorization'] =
              '${tokens.tokenType} ${tokens.accessToken}';
        }
      } on Exception catch (e) {
        AppLogger.warning('解析令牌失败，无法添加认证头', e);
      }
    }
  }

  /// 尝试使用刷新令牌换取新的访问令牌
  ///
  /// 返回:true 刷新成功 false 刷新失败
  Future<bool> _refreshToken() async {
    try {
      final tokensJson = _localStorage.getJson(AppConstants.tokensKey);
      if (tokensJson == null) {
        return false;
      }

      final tokens = AuthTokens.fromJson(tokensJson);
      if (tokens.refreshToken.isEmpty) {
        return false;
      }

      // 检查刷新令牌是否已过期
      if (tokens.isRefreshTokenExpired) {
        AppLogger.warning('刷新令牌已过期，无法刷新');
        return false;
      }

      final dio = Dio();
      final response = await dio.post<Map<String, dynamic>>(
        '${AppConstants.baseUrl}${AppConstants.apiVersion}${AppConstants.refreshToken}',
        data: {'refresh_token': tokens.refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final newAccessToken = data['access_token'] as String?;
          final newRefreshToken = data['refresh_token'] as String?;
          final expiresIn = data['expires_in'] as int?;
          final refreshExpiresIn = data['refresh_expires_in'] as int?;

          if (newAccessToken != null) {
            // 计算访问令牌的过期时间
            final expiresAt = expiresIn != null
                ? DateTime.now().add(Duration(seconds: expiresIn))
                : DateTime.now().add(const Duration(hours: 1));

            // 计算刷新令牌的过期时间（如果提供了）
            final refreshTokenExpiresAt = refreshExpiresIn != null
                ? DateTime.now().add(Duration(seconds: refreshExpiresIn))
                : tokens.refreshTokenExpiresAt; // 如果没有提供，保持原有的过期时间

            // 创建新的令牌对象
            final newTokens = AuthTokens(
              accessToken: newAccessToken,
              refreshToken: newRefreshToken ?? tokens.refreshToken,
              expiresAt: expiresAt,
              refreshTokenExpiresAt: refreshTokenExpiresAt,
              tokenType: tokens.tokenType,
            );

            // 保存到本地存储
            await _localStorage.setJson(
              AppConstants.tokensKey,
              newTokens.toJson(),
            );

            AppLogger.info('令牌刷新成功');
            return true;
          }
        }
      }
    } on Exception catch (e) {
      AppLogger.error('刷新令牌失败', e);
    }

    return false;
  }

  /// 清除本地持久化的认证相关数据
  Future<void> _clearAuthData() async {
    await _localStorage.remove(AppConstants.tokensKey);
    await _localStorage.remove(AppConstants.userKey);
  }
}
