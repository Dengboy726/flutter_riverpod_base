import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/app_constants.dart';
import '../utils/logger.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';

/// Dio HTTP客户端
///
/// 基于Dio封装的HTTP客户端，提供统一的网络请求接口。
/// 集成了认证拦截器、日志拦截器、错误拦截器和重试拦截器。
///
/// 主要功能:
/// - 统一的HTTP请求接口
/// - 自动添加认证头
/// - 请求和响应日志记录
/// - 错误处理和转换
/// - 自动重试机制
/// - 请求超时配置
///
/// 使用示例:
/// ```dart
/// final dioClient = DioClient.instance;
/// final response = await dioClient.get('/api/users');
/// ```
class DioClient {
  /// 获取DioClient单例实例
  ///
  /// 如果实例不存在，则创建一个新的实例。
  /// 这确保了整个应用中只有一个DioClient实例。
  ///
  /// 返回:
  /// - [DioClient] 单例实例

  /// 工厂构造：获取全局 DioClient 单例实例
  ///
  /// 若实例尚未创建，将通过私有构造进行初始化。
  factory DioClient() {
    _instance ??= DioClient._internal();
    return _instance!;
  }

  /// 私有构造函数
  ///
  /// 初始化Dio实例并配置拦截器
  DioClient._internal() {
    _dio = _createDio();
  }

  /// 单例实例
  static DioClient? _instance;

  /// Dio实例
  late Dio _dio;

  /// 兼容旧用法：请改用 `DioClient()` 工厂构造
  // ignore: prefer_constructors_over_static_methods
  @Deprecated('Use DioClient() factory instead')
  static DioClient get instance => DioClient();

  /// 获取底层 Dio 客户端实例
  ///
  /// 已注入拦截器、超时与基础配置，建议统一通过此实例发起请求。
  Dio get dio => _dio;

  Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: '${AppConstants.baseUrl}${AppConstants.apiVersion}',
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        sendTimeout: AppConstants.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) => status != null && status < 600,
      ),
    );

    // 添加拦截器
    _addInterceptors(dio);

    return dio;
  }

  void _addInterceptors(Dio dio) {
    // 日志拦截器
    if (kDebugMode || AppConstants.enableLogging) {
      dio.interceptors.add(LoggingInterceptor());
    }

    // 认证拦截器
    dio.interceptors.add(AuthInterceptor());

    // 重试拦截器
    dio.interceptors.add(RetryInterceptor());

    // 错误处理拦截器
    dio.interceptors.add(ErrorInterceptor());

    // 网络状态拦截器
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 检查网络连接 - 临时注释掉
          // if (!NetworkInfo.instance.isConnected) {
          //   handler.reject(
          //     DioException(
          //       requestOptions: options,
          //       error: NetworkException(
          //         message: '网络连接不可用',
          //         code: 'NO_CONNECTION',
          //       ),
          //     ),
          //   );
          //   return;
          // }
          handler.next(options);
        },
      ),
    );
  }

  /// GET 请求
  ///
  /// 获取资源。
  /// 通常用于获取资源。
  ///
  /// 参数:
  /// - [path] 资源路径
  /// - [queryParameters] 查询参数
  /// - [options] 请求选项
  /// - [cancelToken] 取消令牌
  ///
  /// 返回:
  /// - [Response<T>] 响应
  ///
  /// 示例:
  /// ```dart
  /// final response = await dioClient.get('/api/users');
  /// ```
  ///
  /// 注意事项:
  /// - 获取操作通常是幂等的，不会影响其他资源
  /// - 请求选项用于配置请求头、超时等
  /// - 取消令牌用于取消请求
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      AppLogger.logError('GET', path, e);
      rethrow;
    }
  }

  /// POST 请求
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      AppLogger.logError('POST', path, e);
      rethrow;
    }
  }

  /// PUT 请求
  ///
  /// 更新资源。
  /// 通常用于更新资源。
  ///
  /// 参数:
  /// - [path] 资源路径
  /// - [data] 更新数据
  /// - [queryParameters] 查询参数
  /// - [options] 请求选项
  /// - [cancelToken] 取消令牌
  ///
  /// 返回:
  /// - [Response<T>] 响应
  ///
  /// 示例:
  /// ```dart
  /// final response = await dioClient.put('/api/users/1', data: {
  ///   'name': 'John Doe',
  ///   'email': 'john.doe@example.com',
  /// });
  /// ```
  ///
  /// 注意事项:
  /// - 更新操作通常是幂等的，不会影响其他资源
  /// - 请求选项用于配置请求头、超时等
  /// - 取消令牌用于取消请求
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      AppLogger.logError('PUT', path, e);
      rethrow;
    }
  }

  /// DELETE 请求
  ///
  /// 删除资源。
  /// 通常用于删除资源。
  ///
  /// 参数:
  /// - [path] 资源路径
  /// - [data] 删除数据
  /// - [queryParameters] 查询参数
  /// - [options] 请求选项
  /// - [cancelToken] 取消令牌
  ///
  /// 返回:
  /// - [Response<T>] 响应
  ///
  /// 示例:
  /// ```dart
  /// final response = await dioClient.delete('/api/users/1');
  /// ```
  ///
  /// 注意事项:
  /// - 删除操作通常是幂等的，不会影响其他资源
  /// - 请求选项用于配置请求头、超时等
  /// - 取消令牌用于取消请求
  ///
  /// 示例:
  /// ```dart
  /// final response = await dioClient.delete('/api/users/1');
  /// ```
  ///
  /// 注意事项:
  /// - 删除操作通常是幂等的，不会影响其他资源
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      AppLogger.logError('DELETE', path, e);
      rethrow;
    }
  }

  /// PATCH 请求
  ///
  /// 部分更新资源。
  /// 通常用于更新资源的部分数据。
  ///
  /// 参数:
  /// - [path] 资源路径
  /// - [data] 更新数据
  /// - [queryParameters] 查询参数
  /// - [options] 请求选项
  /// - [cancelToken] 取消令牌
  ///
  /// 返回:
  /// - [Response<T>] 响应
  ///
  /// 示例:
  /// ```dart
  /// final response = await dioClient.patch('/api/users/1', data: {
  ///   'name': 'John Doe',
  ///   'email': 'john.doe@example.com',
  /// });
  /// ```
  ///
  /// 注意事项:
  /// - 部分更新只更新指定的字段，不会影响其他字段
  /// - 请求选项用于配置请求头、超时等
  /// - 取消令牌用于取消请求
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      AppLogger.logError('PATCH', path, e);
      rethrow;
    }
  }

  /// 文件上传
  ///
  /// 上传文件到指定路径。
  /// 通常用于上传文件到服务器。
  ///
  /// 参数:
  /// - [path] 文件路径
  /// - [file] 文件
  /// - [fileName] 文件名
  /// - [fieldName] 字段名
  /// - [data] 数据
  /// - [onSendProgress] 上传进度回调
  /// - [options] 请求选项
  /// - [cancelToken] 取消令牌
  ///
  /// 返回:
  /// - [Response<T>] 上传响应
  ///
  /// 示例:
  /// ```dart
  /// final file = File('path/to/file.pdf');
  /// final response = await dioClient.uploadFile('/api/upload', file);
  /// ```
  ///
  /// 注意事项:
  /// - 文件路径必须为本地文件路径
  /// - 文件名必须为文件的实际名称
  /// - 字段名必须为服务器端接收文件的字段名
  /// - 数据必须为上传文件的额外数据
  /// - 上传进度回调用于显示上传进度
  /// - 请求选项用于配置请求头、超时等
  Future<Response<T>> uploadFile<T>(
    String path,
    File file, {
    String? fileName,
    String? fieldName,
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final formData = FormData.fromMap({
        if (data != null) ...data,
        fieldName ?? 'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName ?? file.path.split('/').last,
        ),
      });

      final response = await _dio.post<T>(
        path,
        data: formData,
        options: options,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      AppLogger.logError('UPLOAD', path, e);
      rethrow;
    }
  }

  /// 文件下载
  ///
  /// 下载文件到指定路径。
  /// 通常用于下载文件到本地存储。
  ///
  /// 参数:
  /// - [path] 文件路径
  /// - [savePath] 保存路径
  /// - [queryParameters] 查询参数
  /// - [onReceiveProgress] 下载进度回调
  /// - [options] 请求选项
  /// - [cancelToken] 取消令牌
  ///
  /// 返回:
  /// - [Response<T>] 下载响应
  Future<Response<T>> downloadFile<T>(
    String path,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.download(
        path,
        savePath,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
        options: options,
        cancelToken: cancelToken,
      );
      return response as Response<T>;
    } on DioException catch (e) {
      AppLogger.logError('DOWNLOAD', path, e);
      rethrow;
    }
  }

  /// 取消所有未完成的请求
  ///
  /// 立即关闭所有未完成的请求，释放资源。
  void cancelAllRequests() {
    _dio.close(force: true);
  }

  ///
  /// 更新底层Dio客户端的基础URL。
  /// 通常用于动态更新API端点或测试环境切换。
  ///
  /// 参数:
  /// - [baseUrl] 新的基础URL
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  /// 更新请求头
  ///
  /// 更新底层Dio客户端的请求头。
  /// 通常用于动态更新API端点或测试环境切换。
  ///
  /// 参数:
  /// - [headers] 新的请求头
  void updateHeaders(Map<String, dynamic> headers) {
    _dio.options.headers.addAll(headers);
  }

  /// 移除请求头
  ///
  /// 移除底层Dio客户端的请求头。
  /// 通常用于动态更新API端点或测试环境切换。
  ///
  /// 参数:
  /// - [key] 要移除的请求头键
  void removeHeader(String key) {
    _dio.options.headers.remove(key);
  }
}
