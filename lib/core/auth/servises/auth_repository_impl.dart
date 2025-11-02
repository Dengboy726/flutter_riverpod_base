import '../../../core/auth/models/auth_response.dart';
import '../../../core/auth/models/auth_tokens.dart';
import '../../../core/auth/models/user.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../../core/utils/logger.dart';
import '../../../pages/login/models/login_request.dart';
import '../../../pages/register/models/register_request.dart';
import 'auth_local_datasource.dart';
import 'auth_remote_datasource.dart';
import 'auth_repository.dart';

/// 认证仓库实现
/// 提供了认证相关的仓库实现
/// 使用了 AuthRemoteDataSource 实现远程数据源
/// 使用了 AuthLocalDataSource 实现本地数据源
/// 使用了 NetworkInfo 实现网络信息
/// 实现了 AuthRepository 接口
/// 提供了登录、注册、刷新令牌、登出、获取用户资料、更新用户资料、修改密码、忘记密码、重置密码、验证邮箱、重新发送验证邮件、获取缓存用户、获取缓存令牌、检查令牌有效性的方法
class AuthRepositoryImpl implements AuthRepository {
  /// 构造函数
  /// 参数:
  /// - [remoteDataSource] 远程数据源
  /// - [localDataSource] 本地数据源
  /// - [networkInfo] 网络信息
  /// 返回:
  /// - [AuthRepositoryImpl] 认证仓库实现
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  /// 远程数据源
  /// 本地数据源
  /// 网络信息
  final AuthRemoteDataSource remoteDataSource;

  /// 本地数据源
  /// 网络信息
  final AuthLocalDataSource localDataSource;

  /// 网络信息
  final NetworkInfo networkInfo;

  /// 登录
  /// 参数:
  /// - [request] 登录请求
  /// 返回:
  /// - [Future<AuthResponse>] 登录响应

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      if (networkInfo.isConnected) {
        final authResponse = await remoteDataSource.login(request);
        await localDataSource.cacheUser(authResponse.user);
        await localDataSource.cacheTokens(authResponse.tokens);
        return authResponse;
      } else {
        throw const NetworkException(message: '网络连接不可用');
      }
    } on Exception catch (e) {
      AppLogger.error('仓库层登录失败', e);
      rethrow;
    } catch (e) {
      AppLogger.error('仓库层登录失败', e);
      throw ServerException(
        message: '登录失败: $e',
        details: {'originalError': e.toString()},
      );
    }
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      if (networkInfo.isConnected) {
        final authResponse = await remoteDataSource.register(request);
        await localDataSource.cacheUser(authResponse.user);
        await localDataSource.cacheTokens(authResponse.tokens);
        return authResponse;
      } else {
        throw const NetworkException(message: '网络连接不可用');
      }
    } on Exception catch (e) {
      AppLogger.error('仓库层注册失败', e);
      rethrow;
    } catch (e) {
      AppLogger.error('仓库层注册失败', e);
      throw ServerException(
        message: '注册失败: $e',
        details: {'originalError': e.toString()},
      );
    }
  }

  @override
  Future<AuthTokens> refreshToken(String refreshToken) async {
    try {
      if (networkInfo.isConnected) {
        final tokens = await remoteDataSource.refreshToken(refreshToken);
        await localDataSource.cacheTokens(tokens);
        return tokens;
      } else {
        throw const NetworkException(message: '网络连接不可用');
      }
    } on Exception catch (e) {
      AppLogger.error('仓库层令牌刷新失败', e);
      rethrow;
    } catch (e) {
      AppLogger.error('仓库层令牌刷新失败', e);
      throw ServerException(
        message: '令牌刷新失败: $e',
        details: {'originalError': e.toString()},
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      if (networkInfo.isConnected) {
        await remoteDataSource.logout();
      }
      await localDataSource.clearAuthData();
    } on Exception catch (e) {
      AppLogger.error('仓库层登出失败', e);
      // 即使远程登出失败，也要清除本地数据
      await localDataSource.clearAuthData();
      rethrow;
    } catch (e) {
      AppLogger.error('仓库层登出失败', e);
      // 即使远程登出失败，也要清除本地数据
      await localDataSource.clearAuthData();
      throw ServerException(
        message: '登出失败: $e',
        details: {'originalError': e.toString()},
      );
    }
  }

  @override
  Future<User> getProfile() async {
    try {
      if (networkInfo.isConnected) {
        final user = await remoteDataSource.getProfile();
        await localDataSource.cacheUser(user);
        return user;
      } else {
        // 网络不可用时返回缓存数据
        final cachedUser = await localDataSource.getCachedUser();
        if (cachedUser != null) {
          return cachedUser;
        } else {
          throw const NetworkException(message: '网络连接不可用且无缓存数据');
        }
      }
    } on Exception catch (e) {
      AppLogger.error('仓库层获取用户资料失败', e);
      rethrow;
    } catch (e) {
      AppLogger.error('仓库层获取用户资料失败', e);
      throw ServerException(
        message: '获取用户资料失败: $e',
        details: {'originalError': e.toString()},
      );
    }
  }

  @override
  Future<User> updateProfile(User user) async {
    try {
      if (networkInfo.isConnected) {
        final updatedUser = await remoteDataSource.updateProfile(user);
        await localDataSource.cacheUser(updatedUser);
        return updatedUser;
      } else {
        throw const NetworkException(message: '网络连接不可用');
      }
    } on Exception catch (e) {
      AppLogger.error('仓库层更新用户资料失败', e);
      rethrow;
    } catch (e) {
      AppLogger.error('仓库层更新用户资料失败', e);
      throw ServerException(
        message: '更新用户资料失败: $e',
        details: {'originalError': e.toString()},
      );
    }
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      if (networkInfo.isConnected) {
        await remoteDataSource.changePassword(currentPassword, newPassword);
      } else {
        throw const NetworkException(message: '网络连接不可用');
      }
    } on Exception catch (e) {
      AppLogger.error('仓库层修改密码失败', e);
      rethrow;
    } catch (e) {
      AppLogger.error('仓库层修改密码失败', e);
      throw ServerException(
        message: '修改密码失败: $e',
        details: {'originalError': e.toString()},
      );
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      if (networkInfo.isConnected) {
        await remoteDataSource.forgotPassword(email);
      } else {
        throw const NetworkException(message: '网络连接不可用');
      }
    } on Exception catch (e) {
      AppLogger.error('仓库层忘记密码失败', e);
      rethrow;
    } catch (e) {
      AppLogger.error('仓库层忘记密码失败', e);
      throw ServerException(
        message: '忘记密码失败: $e',
        details: {'originalError': e.toString()},
      );
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      if (networkInfo.isConnected) {
        await remoteDataSource.resetPassword(token, newPassword);
      } else {
        throw const NetworkException(message: '网络连接不可用');
      }
    } on Exception catch (e) {
      AppLogger.error('仓库层重置密码失败', e);
      rethrow;
    } catch (e) {
      AppLogger.error('仓库层重置密码失败', e);
      throw ServerException(
        message: '重置密码失败: $e',
        details: {'originalError': e.toString()},
      );
    }
  }

  @override
  Future<void> verifyEmail(String token) async {
    try {
      if (networkInfo.isConnected) {
        await remoteDataSource.verifyEmail(token);
      } else {
        throw const NetworkException(message: '网络连接不可用');
      }
    } on Exception catch (e) {
      AppLogger.error('仓库层验证邮箱失败', e);
      rethrow;
    } catch (e) {
      AppLogger.error('仓库层验证邮箱失败', e);
      throw ServerException(
        message: '验证邮箱失败: $e',
        details: {'originalError': e.toString()},
      );
    }
  }

  @override
  Future<void> resendVerificationEmail() async {
    try {
      if (networkInfo.isConnected) {
        await remoteDataSource.resendVerificationEmail();
      } else {
        throw const NetworkException(message: '网络连接不可用');
      }
    } on Exception catch (e) {
      AppLogger.error('仓库层重新发送验证邮件失败', e);
      rethrow;
    } catch (e) {
      AppLogger.error('仓库层重新发送验证邮件失败', e);
      throw ServerException(
        message: '重新发送验证邮件失败: $e',
        details: {'originalError': e.toString()},
      );
    }
  }

  @override
  Future<User?> getCachedUser() async {
    try {
      return await localDataSource.getCachedUser();
    } on Exception catch (e) {
      AppLogger.error('仓库层获取缓存用户失败', e);
      rethrow;
    } catch (e) {
      AppLogger.error('仓库层获取缓存用户失败', e);
      throw ServerException(
        message: '获取缓存用户失败: $e',
        details: {'originalError': e.toString()},
      );
    }
  }

  @override
  Future<AuthTokens?> getCachedTokens() async {
    try {
      return await localDataSource.getCachedTokens();
    } on Exception catch (e) {
      AppLogger.error('仓库层获取缓存令牌失败', e);
      rethrow;
    } catch (e) {
      AppLogger.error('仓库层获取缓存令牌失败', e);
      throw ServerException(
        message: '获取缓存令牌失败: $e',
        details: {'originalError': e.toString()},
      );
    }
  }

  @override
  Future<bool> hasValidToken() async {
    try {
      return await localDataSource.hasValidToken();
    } on Exception catch (e) {
      AppLogger.error('仓库层检查令牌有效性失败', e);
      return false;
    }
  }
}
