import '../models/login_request.dart';
import '../../../core/auth/models/auth_response.dart';
import '../../../core/auth/servises/auth_repository.dart';

/// 登录用例
/// 用于登录认证
/// 实现了 AuthRepository 接口
/// 提供了登录方法
class LoginUseCase {
  /// 构造函数
  /// 参数:
  /// - [repository] 认证仓库
  /// 返回:
  /// - [LoginUseCase] 登录用例
  LoginUseCase(this.repository);

  /// 认证仓库
  final AuthRepository repository;

  /// 登录
  /// 参数:
  /// - [request] 登录请求
  /// 返回:
  /// - [Future<AuthResponse>] 登录响应
  Future<AuthResponse> call(LoginRequest request) async =>
      repository.login(request);
}
