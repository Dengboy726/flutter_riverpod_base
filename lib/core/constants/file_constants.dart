/// 文件相关常量类
///
/// 定义应用中所有文件相关的常量，包括文件大小限制、允许的文件类型等。
class FileConstants {
  FileConstants._();

  // 文件上传配置
  /// 最大上传文件大小（字节）
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB

  /// 允许的图片类型扩展名
  static const List<String> allowedImageTypes = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
  ];

  /// 允许的文档类型扩展名
  static const List<String> allowedDocumentTypes = [
    'pdf',
    'doc',
    'docx',
    'txt',
  ];
}
