import '../../../core/auth/models/auth_tokens.dart';
import '../../../core/auth/models/user.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/utils/logger.dart';

/// 本地数据源接口
abstract class AuthLocalDataSource {
  /// 获取缓存用户
  /// 返回:
  /// - [Future<User?>] 缓存用户，如果不存在则返回 null
  Future<User?> getCachedUser();

  /// 获取缓存令牌
  /// 返回:
  /// - [Future<AuthTokens?>] 缓存令牌，如果不存在则返回 null
  Future<AuthTokens?> getCachedTokens();

  /// 缓存用户
  /// 参数:
  /// - [user] 用户
  /// 返回:
  /// - [Future<void>] 缓存用户
  Future<void> cacheUser(User user);

  /// 缓存令牌
  /// 参数:
  /// - [tokens] 令牌
  /// 返回:
  /// - [Future<void>] 缓存令牌
  Future<void> cacheTokens(AuthTokens tokens);

  /// 清除认证数据
  /// 返回:
  /// - [Future<void>] 清除认证数据
  Future<void> clearAuthData();

  /// 检查令牌有效性
  /// 返回:
  /// - [Future<bool>] 令牌有效则返回 true，否则返回 false
  Future<bool> hasValidToken();
}

/// 本地数据源实现
/// 提供认证相关的本地数据源实现
/// 使用 LocalStorage 实现本地存储
/// 实现了 AuthLocalDataSource 接口
/// 提供了获取缓存用户、获取缓存令牌、缓存用户、缓存令牌、清除认证数据、检查令牌有效性的方法
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  /// 构造函数
  /// 参数:
  /// - [localStorage] 本地存储实例
  /// 返回:
  /// - [AuthLocalDataSourceImpl] 本地数据源实现
  AuthLocalDataSourceImpl({required this.localStorage});

  /// 本地存储实例
  final LocalStorage localStorage;

  @override
  Future<User?> getCachedUser() async {
    try {
      final userData = localStorage.getJson(AppConstants.userKey);
      if (userData != null) {
        return User.fromJson(userData);
      }
      return null;
    } catch (e) {
      AppLogger.error('获取缓存用户失败', e);
      throw CacheException(message: '获取缓存用户信息失败: $e');
    }
  }

  @override
  Future<AuthTokens?> getCachedTokens() async {
    try {
      // 尝试从统一存储键获取（推荐方式）
      final tokensJson = localStorage.getJson(AppConstants.tokensKey);
      if (tokensJson != null) {
        return AuthTokens.fromJson(tokensJson);
      }

      // 兼容旧方式：分别获取 accessToken 和 refreshToken（已废弃）
      final accessToken = localStorage.getString('auth_token');
      final refreshToken = localStorage.getString('refresh_token');

      if (accessToken != null && refreshToken != null) {
        // 从token中解析过期时间（这里简化处理，实际应该从JWT中解析）
        final expiresAt = DateTime.now().add(const Duration(hours: 24));

        return AuthTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
          expiresAt: expiresAt,
          refreshTokenExpiresAt: DateTime.now().add(
            const Duration(days: 7),
          ), // 刷新令牌 7 天过期
        );
      }
      return null;
    } catch (e) {
      AppLogger.error('获取缓存令牌失败', e);
      throw CacheException(message: '获取缓存token失败: $e');
    }
  }

  @override
  Future<void> cacheUser(User user) async {
    try {
      await localStorage.setJson(AppConstants.userKey, user.toJson());
      AppLogger.info('用户缓存成功');
    } catch (e) {
      AppLogger.error('缓存用户失败', e);
      throw CacheException(message: '缓存用户信息失败: $e');
    }
  }

  @override
  Future<void> cacheTokens(AuthTokens tokens) async {
    try {
      // 使用统一存储键（推荐方式）
      await localStorage.setJson(AppConstants.tokensKey, tokens.toJson());
      AppLogger.info('令牌缓存成功');
    } catch (e) {
      AppLogger.error('缓存令牌失败', e);
      throw CacheException(message: '缓存token失败: $e');
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await localStorage.remove(AppConstants.userKey);
      await localStorage.remove(AppConstants.tokensKey); // 统一存储键
      // 兼容旧存储方式（可选，如果不清理也不会造成问题）
      await localStorage.remove('auth_token');
      await localStorage.remove('refresh_token');
      AppLogger.info('认证数据清除成功');
    } catch (e) {
      AppLogger.error('清除认证数据失败', e);
      throw CacheException(message: '清除认证数据失败: $e');
    }
  }

  @override
  Future<bool> hasValidToken() async {
    try {
      final tokens = await getCachedTokens();
      if (tokens != null && !tokens.isExpired) {
        return true;
      }
      return false;
    } on Exception catch (e) {
      AppLogger.error('检查令牌有效性失败', e);
      return false;
    }
  }
}
