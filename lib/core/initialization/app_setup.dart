import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../utils/logger.dart';
import '../storage/local_storage.dart';

/// 初始化应用依赖
///
/// 负责初始化本地存储、网络信息、HTTP客户端等核心服务。
/// 这些服务必须在应用启动时初始化，确保后续功能正常工作。
///
/// 注意：认证状态初始化需要在 ProviderScope 创建后通过 MyApp 初始化。
///
/// 初始化顺序：
/// 1. 本地存储（SharedPreferences）
/// 2. 网络信息（连接状态监听）
/// 3. HTTP客户端（Dio实例，包含拦截器）
/// 4. 日志清理（清理旧日志文件）
Future<void> setupDependencies() async {
  try {
    // 1. 初始化本地存储
    await LocalStorage.initialize();

    // 2. 初始化网络信息
    await NetworkInfo.instance.initialize();

    // 3. 初始化 HTTP 客户端（确保单例创建）
    // DioClient 是延迟初始化的，这里确保它在启动时创建
    DioClient();

    // 4. 清理旧日志文件（后台执行，不阻塞启动）
    await AppLogger.cleanOldLogs().catchError((Object error) {
      AppLogger.warning('清理旧日志文件失败: $error');
    });

    AppLogger.info('依赖初始化成功');
  } on Exception catch (e) {
    AppLogger.error('依赖初始化失败', e);
    rethrow;
  }
}

/// 清理应用依赖
///
/// 清理已初始化的服务资源。
Future<void> resetDependencies() async {
  // 如果需要，可以在这里添加清理逻辑
  AppLogger.info('依赖重置成功');
}
