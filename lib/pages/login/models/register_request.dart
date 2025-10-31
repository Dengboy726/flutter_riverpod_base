import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_request.freezed.dart';
part 'register_request.g.dart';

/// 注册请求模型
///
/// 包含注册所需的邮箱、密码、确认密码、用户名等信息。
/// 使用 Freezed 确保对象不可变性和比较的正确性。
@freezed
class RegisterRequest with _$RegisterRequest {
  /// 创建注册请求实例
  ///
  /// 参数:
  /// - [email] 用户邮箱
  /// - [password] 用户密码
  /// - [confirmPassword] 确认密码
  /// - [username] 用户名
  /// - [firstName] 名（可选）
  /// - [lastName] 姓（可选）
  /// - [phone] 手机号（可选）
  const factory RegisterRequest({
    required String email,
    required String password,
    required String confirmPassword,
    required String username,
    String? firstName,
    String? lastName,
    String? phone,
  }) = _RegisterRequest;

  /// 从 JSON 解析 RegisterRequest
  ///
  /// 参数:
  /// - [json] JSON 数据
  /// 返回:
  /// - [RegisterRequest] RegisterRequest 实例
  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}
