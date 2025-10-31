import 'auth_repository.dart';

/// 登出用例
/// 用于登出认证
/// 实现了 AuthRepository 接口
/// 提供了登出方法
class LogoutUseCase {
  /// 构造函数
  /// 参数:
  /// - [repository] 认证仓库
  /// 返回:
  /// - [LogoutUseCase] 登出用例
  LogoutUseCase(this.repository);

  /// 认证仓库
  /// 返回:
  /// - [LogoutUseCase] 登出用例
  final AuthRepository repository;

  /// 登出
  /// 返回:
  /// - [Future<void>] 登出响应

  Future<void> call() async => repository.logout();
}
