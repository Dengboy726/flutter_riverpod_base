import '../models/login_request.dart';
import '../models/register_request.dart';
import '../../../core/auth/models/auth_response.dart';
import '../../../core/auth/models/auth_tokens.dart';
import '../../../core/auth/models/user.dart';

/// 认证仓库接口
///
/// 定义了认证相关的所有操作接口，包括登录、注册、刷新令牌、登出、获取用户资料、更新用户资料、修改密码、忘记密码、重置密码、验证邮箱、重新发送验证邮件等。
/// 这些接口是认证功能的核心，用于实现认证相关的业务逻辑。
///
/// 主要功能:
/// - 登录
/// - 注册
/// - 刷新令牌
abstract class AuthRepository {
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
  /// 返回:
  /// - [Future<User>] 用户资料
  Future<User> getProfile();

  /// 更新用户资料
  /// 参数:
  /// - [user] 用户资料
  /// 返回:
  /// - [Future<User>] 更新用户资料响应
  Future<User> updateProfile(User user);

  /// 修改密码
  /// 参数:
  /// - [currentPassword] 当前密码
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

  /// 获取缓存用户
  /// 返回:
  /// - [Future<User?>] 缓存用户
  Future<User?> getCachedUser();

  /// 获取缓存令牌
  /// 返回:
  /// - [Future<AuthTokens?>] 缓存令牌
  Future<AuthTokens?> getCachedTokens();

  /// 验证令牌是否有效
  /// 返回:
  /// - [Future<bool>] 验证令牌是否有效
  Future<bool> hasValidToken();
}
