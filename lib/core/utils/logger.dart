import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/app_constants.dart';

/// 应用日志记录器
///
/// 提供统一的日志记录功能，支持不同级别的日志输出。
/// 集成了文件日志记录和内存日志管理功能。
///
/// 主要功能:
/// - 多级别日志记录（debug、info、warning、error）
/// - 文件日志持久化存储
/// - 日志文件大小和数量管理
/// - 网络请求和响应日志记录
/// - 异常堆栈跟踪记录
///
/// 使用示例:
/// ```dart
/// AppLogger.info('用户登录成功');
/// AppLogger.error('网络请求失败', exception);
/// AppLogger.logRequest('GET', '/api/users', headers);
/// ```
class AppLogger {
  const AppLogger._();
  static Logger? _logger;
  static File? _logFile;

  /// 初始化日志系统
  ///
  /// 创建日志文件、配置 Logger 输出（控制台 + 文件），失败时回退到默认配置。
  static Future<void> init() async {
    try {
      // 创建日志文件
      await _createLogFile();

      // 配置 Logger
      _logger = Logger(
        filter: AppConstants.enableLogging
            ? DevelopmentFilter()
            : ProductionFilter(),
        // ignore: deprecated_member_use
        printer: PrettyPrinter(printTime: true),
        output: _MultiOutput([
          ConsoleOutput(),
          if (_logFile != null) _FileOutput(_logFile!),
        ]),
      );

      _logger!.i('日志记录器初始化成功');
    } on Exception catch (e) {
      // 如果初始化失败，使用默认配置
      _logger = Logger();
      _logger!.e('日志记录器初始化失败: $e');
    }
  }

  /// 创建当日日志文件（位于应用文档目录下 logs/）
  static Future<void> _createLogFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logDir = Directory('${directory.path}/logs');

      if (!await logDir.exists()) {
        await logDir.create(recursive: true);
      }

      final timestamp = DateTime.now().toIso8601String().split('T')[0];
      _logFile = File('${logDir.path}/app_$timestamp.log');
    } on Exception {
      // 如果创建日志文件失败，继续使用控制台输出
      _logFile = null;
    }
  }

  /// 记录调试级别日志
  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    _logger?.d(message, error: error, stackTrace: stackTrace);
  }

  /// 记录信息级别日志
  static void info(String message, [Object? error, StackTrace? stackTrace]) {
    _logger?.i(message, error: error, stackTrace: stackTrace);
  }

  /// 记录警告级别日志
  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _logger?.w(message, error: error, stackTrace: stackTrace);
  }

  /// 记录错误级别日志
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger?.e(message, error: error, stackTrace: stackTrace);
  }

  /// 记录致命级别日志
  static void fatal(String message, [Object? error, StackTrace? stackTrace]) {
    _logger?.f(message, error: error, stackTrace: stackTrace);
  }

  /// 记录网络请求日志
  static void logRequest(
    String method,
    String url,
    Map<String, Object?>? headers,
    Object? data,
  ) {
    final logMessage =
        '''
=== 网络请求 ===
请求方法: $method
请求地址: $url
请求头: $headers
请求数据: $data
================''';
    info(logMessage);
  }

  /// 记录网络响应日志
  static void logResponse(
    String method,
    String url,
    int statusCode,
    Map<String, Object?>? headers,
    Object? data,
  ) {
    final logMessage =
        '''
=== 网络响应 ===
请求方法: $method
请求地址: $url
响应状态: $statusCode
响应头: $headers
响应数据: $data
================''';
    info(logMessage);
  }

  /// 记录网络错误日志
  static void logError(String method, String url, Object? err) {
    final logMessage =
        '''
=== 网络错误 ===
请求方法: $method
请求地址: $url
错误信息: $err
================''';

    error(logMessage);
  }

  /// 记录用户行为日志
  static void logUserAction(String action, Map<String, Object?>? data) {
    final logMessage =
        '''
=== 用户行为 ===
操作: $action
数据: $data
时间: ${DateTime.now().toIso8601String()}
================''';
    info(logMessage);
  }

  /// 记录性能指标日志
  static void logPerformance(
    String operation,
    Duration duration,
    Map<String, Object?>? metadata,
  ) {
    final logMessage =
        '''
=== 性能监控 ===
操作: $operation
耗时: ${duration.inMilliseconds}毫秒
元数据: $metadata
时间: ${DateTime.now().toIso8601String()}
================''';
    info(logMessage);
  }

  /// 清理过量/过大的旧日志文件
  static Future<void> cleanOldLogs() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logDir = Directory('${directory.path}/logs');

      if (!await logDir.exists()) {
        final files = await logDir.list().toList();
        final logFiles = files.whereType<File>().toList();

        // 异步获取各文件的最近修改时间以避免使用 sync IO
        final fileWithTimes = await Future.wait(
          logFiles.map((f) async {
            final modified = await f.lastModified();
            return (file: f, modified: modified);
          }),
        );

        // 按修改时间降序排序
        fileWithTimes.sort((a, b) => b.modified.compareTo(a.modified));
        final sortedLogFiles = fileWithTimes.map((e) => e.file).toList();

        // 删除超过最大文件数量的日志文件
        if (sortedLogFiles.length > AppConstants.maxLogFiles) {
          for (
            var i = AppConstants.maxLogFiles;
            i < sortedLogFiles.length;
            i++
          ) {
            await sortedLogFiles[i].delete();
          }
        }

        // 删除过大的日志文件
        for (final file in sortedLogFiles) {
          if (await file.length() > AppConstants.maxLogFileSize) {
            await file.delete();
          }
        }
      }
    } on Exception catch (e) {
      error('清理旧日志文件失败: $e');
    }
  }

  /// 获取当前日志文件路径
  static String? getLogFilePath() => _logFile?.path;
}

// 自定义输出类，支持同时输出到控制台和文件
class _MultiOutput extends LogOutput {
  _MultiOutput(this.outputs);
  final List<LogOutput> outputs;

  @override
  void output(OutputEvent event) {
    for (final output in outputs) {
      output.output(event);
    }
  }
}

// 文件输出类
class _FileOutput extends LogOutput {
  _FileOutput(this.file);
  final File file;

  @override
  void output(OutputEvent event) {
    try {
      final logEntry =
          '''
[${event.level.name}] ${DateTime.now().toIso8601String()}
${event.lines.join('\n')}
${'=' * 50}

''';
      // 写文件为同步 IO，记录量较小且在日志通道中可接受；必要时可替换为异步汇聚落盘。
      file.writeAsStringSync(logEntry, mode: FileMode.append);
    } on Exception catch (_) {
      // 如果写入文件失败，忽略错误
    }
  }
}
