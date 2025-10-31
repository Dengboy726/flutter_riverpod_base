import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// 用户模型
///
/// 包含用户信息，用于认证和用户管理。
/// 使用 Freezed 确保对象不可变性和比较的正确性。
@freezed
class User with _$User {
  /// 创建 User 实例
  ///
  /// 参数:
  /// - [id] 用户ID
  /// - [email] 邮箱
  /// - [username] 用户名
  /// - [firstName] 名（可选）
  /// - [lastName] 姓（可选）
  /// - [avatar] 头像URL（可选）
  /// - [phone] 手机号（可选）
  /// - [createdAt] 创建时间（可选）
  /// - [updatedAt] 更新时间（可选）
  /// - [isEmailVerified] 是否验证邮箱，默认为 false
  /// - [isActive] 是否激活，默认为 true
  /// - [metadata] 元数据（可选）
  const factory User({
    required String id,
    required String email,
    required String username,
    String? firstName,
    String? lastName,
    String? avatar,
    String? phone,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(false) bool isEmailVerified,
    @Default(true) bool isActive,
    Map<String, dynamic>? metadata,
  }) = _User;

  /// 从 JSON 解析 User
  ///
  /// 参数:
  /// - [json] JSON 数据
  /// 返回:
  /// - [User] User 实例
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

/// User 扩展方法
extension UserExtension on User {
  /// 获取全名
  ///
  /// 如果有 firstName 和 lastName，返回完整姓名；
  /// 如果只有 firstName 或 lastName，返回对应的值；
  /// 否则返回用户名。
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    } else {
      return username;
    }
  }

  /// 获取显示名称
  ///
  /// 优先使用全名，如果全名为空则使用用户名。
  String get displayName => fullName.isNotEmpty ? fullName : username;
}
