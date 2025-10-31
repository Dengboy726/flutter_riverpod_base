import '../../../core/auth/models/auth_tokens.dart';
import 'auth_repository.dart';

/// 刷新令牌用例
/// 用于刷新令牌认证
/// 实现了 AuthRepository 接口
/// 提供了刷新令牌方法
class RefreshTokenUseCase {
  /// 构造函数
  /// 参数:
  /// - [repository] 认证仓库
  /// 返回:
  /// - [RefreshTokenUseCase] 刷新令牌用例
  RefreshTokenUseCase(this.repository);

  /// 认证仓库
  /// 返回:
  /// - [RefreshTokenUseCase] 刷新令牌用例
  final AuthRepository repository;

  /// 刷新令牌
  /// 参数:
  /// - [refreshToken] 刷新令牌
  /// 返回:
  /// - [Future<AuthTokens>] 刷新令牌响应
  Future<AuthTokens> call(String refreshToken) async =>
      repository.refreshToken(refreshToken);
}
