import '../models/register_request.dart';
import '../../../core/auth/models/auth_response.dart';
import '../../../core/auth/servises/auth_repository.dart';

/// 注册用例
/// 用于注册认证
/// 实现了 AuthRepository 接口
/// 提供了注册方法
class RegisterUseCase {
  /// 构造函数
  /// 参数:
  /// - [repository] 认证仓库
  /// 返回:
  /// - [RegisterUseCase] 注册用例
  RegisterUseCase(this.repository);

  /// 认证仓库
  /// 返回:
  /// - [RegisterUseCase] 注册用例
  final AuthRepository repository;

  /// 注册
  /// 参数:
  /// - [request] 注册请求
  /// 返回:
  /// - [Future<AuthResponse>] 注册响应
  Future<AuthResponse> call(RegisterRequest request) async =>
      repository.register(request);
}
