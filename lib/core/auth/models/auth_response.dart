import 'package:freezed_annotation/freezed_annotation.dart';

import 'auth_tokens.dart';
import 'user.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

/// 认证响应模型
///
/// 包含用户信息和令牌信息，用于登录和注册的响应。
/// 使用 Freezed 确保对象不可变性和比较的正确性。
@freezed
class AuthResponse with _$AuthResponse {
  /// 创建 AuthResponse 实例
  ///
  /// 参数:
  /// - [user] 用户信息
  /// - [tokens] 令牌信息
  /// - [message] 消息（可选）
  const factory AuthResponse({
    required User user,
    required AuthTokens tokens,
    String? message,
  }) = _AuthResponse;

  /// 从 JSON 解析 AuthResponse
  ///
  /// 参数:
  /// - [json] JSON 数据
  /// 返回:
  /// - [AuthResponse] AuthResponse 实例
  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}
