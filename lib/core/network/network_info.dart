import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../utils/logger.dart';

/// 网络信息管理类
///
/// 负责监控和管理应用的网络连接状态。
/// 使用connectivity_plus包来检测网络连接类型和状态变化。
///
/// 主要功能:
/// - 实时监控网络连接状态
/// - 检测网络连接类型（WiFi、移动数据等）
/// - 提供网络状态变化通知
/// - 判断网络是否可用
///
/// 使用示例:
/// ```dart
/// final networkInfo = NetworkInfo.instance;
/// final isConnected = await networkInfo.isConnected;
/// final connectionType = networkInfo.connectionType;
/// ```
class NetworkInfo {
  /// 获取单例实例（工厂构造）
  factory NetworkInfo() => _instance;
  NetworkInfo._internal();
  static final NetworkInfo _instance = NetworkInfo._internal();

  /// 单例访问器
  static NetworkInfo get instance => _instance;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  final StreamController<NetworkStatus> _networkStatusController =
      StreamController<NetworkStatus>.broadcast();

  /// 网络状态变化流
  Stream<NetworkStatus> get networkStatusStream =>
      _networkStatusController.stream;

  /// 当前网络状态
  NetworkStatus _currentStatus = NetworkStatus.UNKNOWN;

  /// 获取当前网络状态
  NetworkStatus get currentStatus => _currentStatus;

  /// 初始化网络信息监听
  Future<void> initialize() async {
    try {
      // 获取初始网络状态
      final connectivityResults = await _connectivity.checkConnectivity();
      _currentStatus = _getNetworkStatus(connectivityResults);
      _networkStatusController.add(_currentStatus);

      // 监听网络状态变化
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        (List<ConnectivityResult> results) {
          final newStatus = _getNetworkStatus(results);
          if (newStatus != _currentStatus) {
            _currentStatus = newStatus;
            _networkStatusController.add(_currentStatus);
            AppLogger.info('网络状态变更为: $newStatus');
          }
        },
        onError: (Object error) {
          AppLogger.error('网络连接错误', error);
        },
      );

      AppLogger.info('网络信息初始化完成，状态: $_currentStatus');
    } on Exception catch (e) {
      AppLogger.error('网络信息初始化失败', e);
      _currentStatus = NetworkStatus.UNKNOWN;
    }
  }

  /// 将 connectivity_plus 的结果映射为内部网络状态
  NetworkStatus _getNetworkStatus(List<ConnectivityResult> results) {
    if (results.isEmpty) {
      return NetworkStatus.DISCONNECTED;
    }

    // 检查是否有任何连接
    final hasConnection = results.any(
      (result) => result != ConnectivityResult.none,
    );

    if (!hasConnection) {
      return NetworkStatus.DISCONNECTED;
    }

    // 优先选择更稳定的连接类型
    if (results.contains(ConnectivityResult.ethernet)) {
      return NetworkStatus.ETHERNET;
    } else if (results.contains(ConnectivityResult.wifi)) {
      return NetworkStatus.WIFI;
    } else if (results.contains(ConnectivityResult.mobile)) {
      return NetworkStatus.MOBILE;
    } else if (results.contains(ConnectivityResult.bluetooth)) {
      return NetworkStatus.BLUETOOTH;
    } else if (results.contains(ConnectivityResult.vpn)) {
      return NetworkStatus.VPN;
    } else if (results.contains(ConnectivityResult.other)) {
      return NetworkStatus.OTHER;
    }

    return NetworkStatus.UNKNOWN;
  }

  /// 检查是否有网络连接
  bool get isConnected => _currentStatus != NetworkStatus.DISCONNECTED;

  /// 检查是否为移动网络
  bool get isMobileNetwork => _currentStatus == NetworkStatus.MOBILE;

  /// 检查是否为WiFi网络
  bool get isWifiNetwork => _currentStatus == NetworkStatus.WIFI;

  /// 检查是否为以太网连接
  bool get isEthernetNetwork => _currentStatus == NetworkStatus.ETHERNET;

  /// 检查网络质量（基于连接类型）
  NetworkQuality get networkQuality {
    switch (_currentStatus) {
      case NetworkStatus.ETHERNET:
        return NetworkQuality.EXCELLENT;
      case NetworkStatus.WIFI:
        return NetworkQuality.GOOD;
      case NetworkStatus.MOBILE:
        return NetworkQuality.FAIR;
      case NetworkStatus.BLUETOOTH:
        return NetworkQuality.POOR;
      case NetworkStatus.VPN:
        return NetworkQuality.GOOD;
      case NetworkStatus.OTHER:
        return NetworkQuality.UNKNOWN;
      case NetworkStatus.DISCONNECTED:
        return NetworkQuality.NONE;
      case NetworkStatus.UNKNOWN:
        return NetworkQuality.UNKNOWN;
    }
  }

  /// 获取网络状态描述
  String get statusDescription {
    switch (_currentStatus) {
      case NetworkStatus.ETHERNET:
        return '以太网连接';
      case NetworkStatus.WIFI:
        return 'WiFi连接';
      case NetworkStatus.MOBILE:
        return '移动网络';
      case NetworkStatus.BLUETOOTH:
        return '蓝牙连接';
      case NetworkStatus.VPN:
        return 'VPN连接';
      case NetworkStatus.OTHER:
        return '其他连接';
      case NetworkStatus.DISCONNECTED:
        return '网络断开';
      case NetworkStatus.UNKNOWN:
        return '未知状态';
    }
  }

  /// 手动检查网络状态
  Future<NetworkStatus> checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final status = _getNetworkStatus(results);
      _currentStatus = status;
      _networkStatusController.add(status);
      return status;
    } on Exception catch (e) {
      AppLogger.error('检查网络连接失败: $e');
      return NetworkStatus.UNKNOWN;
    }
  }

  /// 释放资源
  void dispose() {
    _connectivitySubscription?.cancel();
    _networkStatusController.close();
  }
}

/// 网络状态枚举
/// 包含网络状态的所有可能值
enum NetworkStatus {
  /// 以太网连接
  ETHERNET,

  /// WiFi连接
  WIFI,

  /// 移动网络
  MOBILE,

  /// 蓝牙连接
  BLUETOOTH,

  /// VPN连接
  VPN,

  /// 其他连接
  OTHER,

  /// 网络断开
  DISCONNECTED,

  /// 未知状态
  UNKNOWN,
}

/// 网络质量枚举
/// 包含网络质量的所有可能值
enum NetworkQuality {
  /// 优秀
  EXCELLENT,

  /// 良好
  GOOD,

  /// 一般
  FAIR,

  /// 较差
  POOR,

  /// 无网络
  NONE,

  /// 未知
  UNKNOWN,
}
