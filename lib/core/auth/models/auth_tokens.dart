import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_tokens.freezed.dart';
part 'auth_tokens.g.dart';

/// 认证令牌实体类
///
/// 包含访问令牌、刷新令牌、过期时间和令牌类型。
/// 使用 Freezed 确保对象不可变性和比较的正确性。
@freezed
class AuthTokens with _$AuthTokens {
  /// 创建 AuthTokens 实例
  ///
  /// 参数:
  /// - [accessToken] 访问令牌
  /// - [refreshToken] 刷新令牌
  /// - [expiresAt] 访问令牌过期时间
  /// - [refreshTokenExpiresAt] 刷新令牌过期时间（可选）
  /// - [tokenType] 令牌类型，默认为 'Bearer'
  const factory AuthTokens({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
    DateTime? refreshTokenExpiresAt,
    @Default('Bearer') String tokenType,
  }) = _AuthTokens;

  /// 从 JSON 解析 AuthTokens
  ///
  /// 参数:
  /// - [json] JSON 数据
  /// 返回:
  /// - [AuthTokens] AuthTokens 实例
  factory AuthTokens.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensFromJson(json);
}

/// AuthTokens 扩展方法
extension AuthTokensExtension on AuthTokens {
  /// 判断访问令牌是否已过期
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// 判断刷新令牌是否已过期
  ///
  /// 如果没有设置过期时间，认为未过期。
  bool get isRefreshTokenExpired {
    if (refreshTokenExpiresAt == null) {
      return false;
    }
    return DateTime.now().isAfter(refreshTokenExpiresAt!);
  }

  /// 判断访问令牌是否即将过期
  ///
  /// 5分钟内过期视为即将过期。
  bool get isExpiringSoon {
    final now = DateTime.now();
    final timeUntilExpiry = expiresAt.difference(now);
    return timeUntilExpiry.inMinutes < 5;
  }

  /// 判断刷新令牌是否即将过期
  ///
  /// 1天内过期视为即将过期。
  bool get isRefreshTokenExpiringSoon {
    if (refreshTokenExpiresAt == null) {
      return false;
    }
    final now = DateTime.now();
    final timeUntilExpiry = refreshTokenExpiresAt!.difference(now);
    return timeUntilExpiry.inDays < 1;
  }

  /// 计算访问令牌剩余时间
  Duration get timeUntilExpiry => expiresAt.difference(DateTime.now());

  /// 计算刷新令牌剩余时间
  ///
  /// 如果没有设置过期时间，返回 null。
  Duration? get refreshTokenTimeUntilExpiry {
    if (refreshTokenExpiresAt == null) {
      return null;
    }
    return refreshTokenExpiresAt!.difference(DateTime.now());
  }
}
