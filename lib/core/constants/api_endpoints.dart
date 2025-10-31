/// API 端点常量类
/// 
/// 定义应用中所有 API 端点的常量，便于统一管理和维护。
class ApiEndpoints {
  /// 认证相关端点
  
  /// 用户登录端点
  static const String login = '/auth/login';
  
  /// 用户注册端点
  static const String register = '/auth/register';
  
  /// 刷新令牌端点
  static const String refreshToken = '/auth/refresh';
  
  /// 用户登出端点
  static const String logout = '/auth/logout';
  
  /// 忘记密码端点
  static const String forgotPassword = '/auth/forgot-password';
  
  /// 重置密码端点
  static const String resetPassword = '/auth/reset-password';
  
  /// 验证邮箱端点
  static const String verifyEmail = '/auth/verify-email';
  
  /// 重新发送验证邮件端点
  static const String resendVerification = '/auth/resend-verification';
  
  /// 用户相关端点
  
  /// 获取用户资料端点
  static const String profile = '/user/profile';
  
  /// 更新用户资料端点
  static const String updateProfile = '/user/profile';
  
  /// 修改密码端点
  static const String changePassword = '/user/change-password';
  
  /// 上传头像端点
  static const String uploadAvatar = '/user/avatar';
  
  /// 删除账户端点
  static const String deleteAccount = '/user/delete';
  
  /// 通用数据端点
  
  /// 健康检查端点
  static const String healthCheck = '/health';
  
  /// 应用配置端点
  static const String appConfig = '/config';
  
  /// 系统信息端点
  static const String systemInfo = '/system/info';
  
  /// 文件上传端点
  
  /// 上传文件端点
  static const String uploadFile = '/upload/file';
  
  /// 上传图片端点
  static const String uploadImage = '/upload/image';
  
  /// 删除文件端点
  static const String deleteFile = '/upload/delete';
  
  /// 通知相关端点
  
  /// 获取通知列表端点
  static const String notifications = '/notifications';
  
  /// 标记通知为已读端点
  static const String markNotificationRead = '/notifications/read';
  
  /// 删除通知端点
  static const String deleteNotification = '/notifications/delete';
  
  /// 设置相关端点
  
  /// 获取用户设置端点
  static const String userSettings = '/settings';
  
  /// 更新用户设置端点
  static const String updateSettings = '/settings/update';
  
  /// 导出数据端点
  static const String exportData = '/settings/export';
  
  /// 导入数据端点
  static const String importData = '/settings/import';
}
