import 'package:dio/dio.dart';

import '../models/login_request.dart';
import '../models/register_request.dart';
import '../../../core/auth/models/auth_response.dart';
import '../../../core/auth/models/auth_tokens.dart';
import '../../../core/auth/models/user.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/errors/status_codes.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/logger.dart';

/// 远程数据源接口
/// 提供了认证相关的远程数据源实现
/// 使用了 DioClient 实现网络请求
/// 使用了 LocalStorage 实现本地存储
/// 实现了 AuthRemoteDataSource 接口
/// 提供了登录、注册、刷新令牌、登出、获取用户资料、更新用户资料、修改密码、忘记密码、重置密码、验证邮箱、重新发送验证邮件的方法
abstract class AuthRemoteDataSource {
  /// 登录
  /// 参数:
  /// - [request] 登录请求
  /// 返回:
  /// - [Future<AuthResponse>] 登录响应
  Future<AuthResponse> login(LoginRequest request);

  /// 注册
  /// 参数:
  /// - [request] 注册请求
  /// 返回:
  /// - [Future<AuthResponse>] 注册响应
  Future<AuthResponse> register(RegisterRequest request);

  /// 刷新令牌
  /// 参数:
  /// - [refreshToken] 刷新令牌
  /// 返回:
  /// - [Future<AuthTokens>] 刷新令牌响应
  Future<AuthTokens> refreshToken(String refreshToken);

  /// 登出
  /// 返回:
  /// - [Future<void>] 登出响应
  Future<void> logout();

  /// 获取用户资料
  Future<User> getProfile();

  /// 更新用户资料
  /// 参数:
  /// - [user] 用户
  /// 返回:
  /// - [Future<User>] 更新用户资料响应
  Future<User> updateProfile(User user);

  /// 修改密码
  /// 参数:
  /// - [currentPassword] 当前密码
  /// - [newPassword] 新密码
  /// 返回:
  /// - [Future<void>] 修改密码响应
  Future<void> changePassword(String currentPassword, String newPassword);

  /// 忘记密码
  /// 参数:
  /// - [email] 邮箱
  /// 返回:
  /// - [Future<void>] 忘记密码响应
  Future<void> forgotPassword(String email);

  /// 重置密码
  /// 参数:
  /// - [token] 令牌
  /// - [newPassword] 新密码
  /// 返回:
  /// - [Future<void>] 重置密码响应
  Future<void> resetPassword(String token, String newPassword);

  /// 验证邮箱
  /// 参数:
  /// - [token] 令牌
  /// 返回:
  /// - [Future<void>] 验证邮箱响应
  Future<void> verifyEmail(String token);

  /// 重新发送验证邮件
  /// 返回:
  /// - [Future<void>] 重新发送验证邮件响应
  Future<void> resendVerificationEmail();
}

/// 远程数据源实现
/// 提供了认证相关的远程数据源实现
/// 使用了 DioClient 实现网络请求
/// 使用了 LocalStorage 实现本地存储
/// 实现了 AuthRemoteDataSource 接口
/// 提供了登录、注册、刷新令牌、登出、获取用户资料、更新用户资料、修改密码、忘记密码、重置密码、验证邮箱、重新发送验证邮件的方法
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// 构造函数
  /// 参数:
  /// - [dioClient] DioClient 实例
  /// - [localStorage] LocalStorage 实例
  /// 返回:
  /// - [AuthRemoteDataSourceImpl] 远程数据源实现
  AuthRemoteDataSourceImpl({
    required this.dioClient,
    required this.localStorage,
  });

  /// DioClient 实例
  /// LocalStorage 实例
  final DioClient dioClient;

  /// LocalStorage 实例
  final LocalStorage localStorage;

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      AppLogger.info('尝试登录，邮箱: ${request.email}');

      final response = await dioClient.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data!);

        // 保存认证信息
        await _saveAuthData(authResponse);

        AppLogger.info('登录成功，用户: ${authResponse.user.username}');
        return authResponse;
      } else {
        throw ServerException(
          message: '登录失败',
          code: StatusCode.fromValue(response.statusCode ?? 400),
        );
      }
    } on DioException catch (e) {
      AppLogger.error('登录失败', e);
      throw e.toAppException();
    } catch (e) {
      AppLogger.error('登录失败', e);
      throw ServerException(message: '登录失败: $e');
    }
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      AppLogger.info('尝试注册，邮箱: ${request.email}');

      final response = await dioClient.post<Map<String, dynamic>>(
        ApiEndpoints.register,
        data: request.toJson(),
      );

      if (response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(response.data!);

        // 保存认证信息
        await _saveAuthData(authResponse);

        AppLogger.info('注册成功，用户: ${authResponse.user.username}');
        return authResponse;
      } else {
        throw ServerException(
          message: '注册失败',
          code: StatusCode.fromValue(response.statusCode ?? 400),
        );
      }
    } on DioException catch (e) {
      AppLogger.error('注册失败', e);
      throw e.toAppException();
    } catch (e) {
      AppLogger.error('注册失败', e);
      throw ServerException(message: '注册失败: $e');
    }
  }

  @override
  Future<AuthTokens> refreshToken(String refreshToken) async {
    try {
      AppLogger.info('刷新令牌中');

      final response = await dioClient.post<Map<String, dynamic>>(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final tokens = AuthTokens.fromJson(response.data!);

        // 更新本地存储的token
        await localStorage.setString('auth_token', tokens.accessToken);
        await localStorage.setString('refresh_token', tokens.refreshToken);

        AppLogger.info('令牌刷新成功');
        return tokens;
      } else {
        throw ServerException(
          message: 'Token刷新失败',
          code: StatusCode.fromValue(response.statusCode ?? 400),
        );
      }
    } on DioException catch (e) {
      AppLogger.error('令牌刷新失败', e);
      throw e.toAppException();
    } catch (e) {
      AppLogger.error('令牌刷新失败', e);
      throw ServerException(message: 'Token刷新失败: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      AppLogger.info('用户登出中');

      await dioClient.post<void>(ApiEndpoints.logout);

      // 清除本地认证数据
      await _clearAuthData();

      AppLogger.info('登出成功');
    } on DioException catch (e) {
      AppLogger.error('登出失败', e);
      // 即使服务器请求失败，也要清除本地数据
      await _clearAuthData();
      throw e.toAppException();
    } catch (e) {
      AppLogger.error('登出失败', e);
      // 即使服务器请求失败，也要清除本地数据
      await _clearAuthData();
      throw ServerException(message: '退出登录失败: $e');
    }
  }

  @override
  Future<User> getProfile() async {
    try {
      AppLogger.info('获取用户资料');

      final response = await dioClient.get<Map<String, dynamic>>(
        ApiEndpoints.profile,
      );

      if (response.statusCode == 200) {
        final user = User.fromJson(response.data!);
        AppLogger.info('用户资料获取成功');
        return user;
      } else {
        throw ServerException(
          message: '获取用户信息失败',
          code: StatusCode.fromValue(response.statusCode ?? 400),
        );
      }
    } on DioException catch (e) {
      AppLogger.error('获取用户资料失败', e);
      throw e.toAppException();
    } catch (e) {
      AppLogger.error('获取用户资料失败', e);
      throw ServerException(message: '获取用户信息失败: $e');
    }
  }

  @override
  Future<User> updateProfile(User user) async {
    try {
      AppLogger.info('更新用户资料');

      final response = await dioClient.put<Map<String, dynamic>>(
        ApiEndpoints.updateProfile,
        data: user.toJson(),
      );

      if (response.statusCode == 200) {
        final updatedUser = User.fromJson(response.data!);
        AppLogger.info('用户资料更新成功');
        return updatedUser;
      } else {
        throw ServerException(
          message: '更新用户信息失败',
          code: StatusCode.fromValue(response.statusCode ?? 400),
        );
      }
    } on DioException catch (e) {
      AppLogger.error('更新用户资料失败', e);
      throw e.toAppException();
    } catch (e) {
      AppLogger.error('更新用户资料失败', e);
      throw ServerException(message: '更新用户信息失败: $e');
    }
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      AppLogger.info('修改密码');

      final response = await dioClient.post<void>(
        ApiEndpoints.changePassword,
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );

      if (response.statusCode == 200) {
        AppLogger.info('密码修改成功');
      } else {
        throw ServerException(
          message: '修改密码失败',
          code: StatusCode.fromValue(response.statusCode ?? 400),
        );
      }
    } on DioException catch (e) {
      AppLogger.error('修改密码失败', e);
      throw e.toAppException();
    } catch (e) {
      AppLogger.error('修改密码失败', e);
      throw ServerException(message: '修改密码失败: $e');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      AppLogger.info('发送忘记密码邮件');

      final response = await dioClient.post<void>(
        ApiEndpoints.forgotPassword,
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        AppLogger.info('忘记密码邮件发送成功');
      } else {
        throw ServerException(
          message: '发送重置密码邮件失败',
          code: StatusCode.fromValue(response.statusCode ?? 400),
        );
      }
    } on DioException catch (e) {
      AppLogger.error('发送忘记密码邮件失败', e);
      throw e.toAppException();
    } catch (e) {
      AppLogger.error('发送忘记密码邮件失败', e);
      throw ServerException(message: '发送重置密码邮件失败: $e');
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      AppLogger.info('重置密码');

      final response = await dioClient.post<void>(
        ApiEndpoints.resetPassword,
        data: {'token': token, 'newPassword': newPassword},
      );

      if (response.statusCode == 200) {
        AppLogger.info('密码重置成功');
      } else {
        throw ServerException(
          message: '重置密码失败',
          code: StatusCode.fromValue(response.statusCode ?? 400),
        );
      }
    } on DioException catch (e) {
      AppLogger.error('重置密码失败', e);
      throw e.toAppException();
    } catch (e) {
      AppLogger.error('重置密码失败', e);
      throw ServerException(message: '重置密码失败: $e');
    }
  }

  @override
  Future<void> verifyEmail(String token) async {
    try {
      AppLogger.info('验证邮箱');

      final response = await dioClient.post<void>(
        ApiEndpoints.verifyEmail,
        data: {'token': token},
      );

      if (response.statusCode == 200) {
        AppLogger.info('邮箱验证成功');
      } else {
        throw ServerException(
          message: '邮箱验证失败',
          code: StatusCode.fromValue(response.statusCode ?? 400),
        );
      }
    } on DioException catch (e) {
      AppLogger.error('验证邮箱失败', e);
      throw e.toAppException();
    } catch (e) {
      AppLogger.error('验证邮箱失败', e);
      throw ServerException(message: '邮箱验证失败: $e');
    }
  }

  @override
  Future<void> resendVerificationEmail() async {
    try {
      AppLogger.info('重新发送验证邮件');

      final response = await dioClient.post<void>(
        ApiEndpoints.resendVerification,
      );

      if (response.statusCode == 200) {
        AppLogger.info('验证邮件重新发送成功');
      } else {
        throw ServerException(
          message: '重新发送验证邮件失败',
          code: StatusCode.fromValue(response.statusCode ?? 400),
        );
      }
    } on DioException catch (e) {
      AppLogger.error('重新发送验证邮件失败', e);
      throw e.toAppException();
    } catch (e) {
      AppLogger.error('重新发送验证邮件失败', e);
      throw ServerException(message: '重新发送验证邮件失败: $e');
    }
  }

  // 保存认证数据到本地存储
  Future<void> _saveAuthData(AuthResponse authResponse) async {
    await localStorage.setString('auth_token', authResponse.tokens.accessToken);
    await localStorage.setString(
      'refresh_token',
      authResponse.tokens.refreshToken,
    );
    await localStorage.setJson('user_data', authResponse.user.toJson());
  }

  // 清除本地认证数据
  Future<void> _clearAuthData() async {
    await localStorage.remove('auth_token');
    await localStorage.remove('refresh_token');
    await localStorage.remove('user_data');
  }
}
