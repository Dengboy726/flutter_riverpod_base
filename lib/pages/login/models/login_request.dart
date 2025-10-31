import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request.freezed.dart';
part 'login_request.g.dart';

/// 登录请求模型
///
/// 包含登录所需的邮箱、密码和记住我选项。
/// 使用 Freezed 确保对象不可变性和比较的正确性。
@freezed
class LoginRequest with _$LoginRequest {
  /// 创建登录请求实例
  ///
  /// 参数:
  /// - [email] 用户邮箱
  /// - [password] 用户密码
  /// - [rememberMe] 是否记住我，默认为 false
  const factory LoginRequest({
    required String email,
    required String password,
    @Default(false) bool rememberMe,
  }) = _LoginRequest;

  /// 从 JSON 解析 LoginRequest
  ///
  /// 参数:
  /// - [json] JSON 数据
  /// 返回:
  /// - [LoginRequest] LoginRequest 实例
  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}
