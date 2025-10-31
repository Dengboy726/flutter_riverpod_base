import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../utils/logger.dart';

/// 本地存储管理类
///
/// 提供统一的本地存储接口，基于 SharedPreferences 实现。
/// 使用单例模式确保全局只有一个存储实例。
class LocalStorage {
  /// 私有构造函数
  LocalStorage._internal();

  /// 单例实例
  static LocalStorage? _instance;

  /// SharedPreferences 实例
  static SharedPreferences? _prefs;

  /// 获取本地存储单例实例
  ///
  /// 返回:
  /// - [LocalStorage] 单例实例
  static LocalStorage get instance {
    _instance ??= LocalStorage._internal();
    return _instance!;
  }

  /// 初始化本地存储
  ///
  /// 初始化 SharedPreferences 存储，必须在应用启动时调用。
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    AppLogger.info('本地存储初始化完成');
  }

  /// 设置字符串值
  ///
  /// 参数:
  /// - [key] 存储键
  /// - [value] 字符串值
  ///
  /// 返回:
  /// - [Future<bool>] 是否设置成功
  Future<bool> setString(String key, String value) async {
    try {
      return await _prefs?.setString(key, value) ?? false;
    } on Exception catch (e) {
      AppLogger.error('设置字符串失败: $key', e);
      return false;
    }
  }

  /// 获取字符串值
  ///
  /// 参数:
  /// - [key] 存储键
  ///
  /// 返回:
  /// - [String?] 字符串值，如果不存在则返回 null
  String? getString(String key) {
    try {
      return _prefs?.getString(key);
    } on Exception catch (e) {
      AppLogger.error('获取字符串失败: $key', e);
      return null;
    }
  }

  /// 设置整数值
  ///
  /// 参数:
  /// - [key] 存储键
  /// - [value] 整数值
  ///
  /// 返回:
  /// - [Future<bool>] 是否设置成功
  Future<bool> setInt(String key, int value) async {
    try {
      return await _prefs?.setInt(key, value) ?? false;
    } on Exception catch (e) {
      AppLogger.error('设置整数失败: $key', e);
      return false;
    }
  }

  /// 获取整数值
  ///
  /// 参数:
  /// - [key] 存储键
  ///
  /// 返回:
  /// - [int?] 整数值，如果不存在则返回 null
  int? getInt(String key) {
    try {
      return _prefs?.getInt(key);
    } on Exception catch (e) {
      AppLogger.error('获取整数失败: $key', e);
      return null;
    }
  }

  /// 设置布尔值
  ///
  /// 参数:
  /// - [key] 存储键
  /// - [value] 布尔值
  ///
  /// 返回:
  /// - [Future<bool>] 是否设置成功
  Future<bool> setBool({required String key, required bool value}) async {
    try {
      return await _prefs?.setBool(key, value) ?? false;
    } on Exception catch (e) {
      AppLogger.error('设置布尔值失败: $key', e);
      return false;
    }
  }

  /// 获取布尔值
  ///
  /// 参数:
  /// - [key] 存储键
  ///
  /// 返回:
  /// - [bool?] 布尔值，如果不存在则返回 null
  bool? getBool(String key) {
    try {
      return _prefs?.getBool(key);
    } on Exception catch (e) {
      AppLogger.error('获取布尔值失败: $key', e);
      return null;
    }
  }

  /// 设置双精度浮点值
  ///
  /// 参数:
  /// - [key] 存储键
  /// - [value] 双精度浮点值
  ///
  /// 返回:
  /// - [Future<bool>] 是否设置成功
  Future<bool> setDouble(String key, double value) async {
    try {
      return await _prefs?.setDouble(key, value) ?? false;
    } on Exception catch (e) {
      AppLogger.error('设置浮点数失败: $key', e);
      return false;
    }
  }

  /// 获取双精度浮点值
  ///
  /// 参数:
  /// - [key] 存储键
  ///
  /// 返回:
  /// - [double?] 双精度浮点值，如果不存在则返回 null
  double? getDouble(String key) {
    try {
      return _prefs?.getDouble(key);
    } on Exception catch (e) {
      AppLogger.error('获取浮点数失败: $key', e);
      return null;
    }
  }

  /// 设置字符串列表
  ///
  /// 参数:
  /// - [key] 存储键
  /// - [value] 字符串列表
  ///
  /// 返回:
  /// - [Future<bool>] 是否设置成功
  Future<bool> setStringList(String key, List<String> value) async {
    try {
      return await _prefs?.setStringList(key, value) ?? false;
    } on Exception catch (e) {
      AppLogger.error('设置字符串列表失败: $key', e);
      return false;
    }
  }

  /// 获取字符串列表
  ///
  /// 参数:
  /// - [key] 存储键
  ///
  /// 返回:
  /// - [List<String>?] 字符串列表，如果不存在则返回 null
  List<String>? getStringList(String key) {
    try {
      return _prefs?.getStringList(key);
    } on Exception catch (e) {
      AppLogger.error('获取字符串列表失败: $key', e);
      return null;
    }
  }

  /// JSON 对象存储
  ///
  /// 参数:
  /// - [key] 存储键
  /// - [value] JSON 对象
  ///
  /// 返回:
  /// - [Future<bool>] 是否设置成功
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = jsonEncode(value);
      return await setString(key, jsonString);
    } on Exception catch (e) {
      AppLogger.error('设置JSON失败: $key', e);
      return false;
    }
  }

  /// 获取JSON对象
  ///
  /// 参数:
  /// - [key] 存储键
  ///
  /// 返回:
  /// - [Map<String, dynamic>?] JSON对象，如果不存在则返回 null
  Map<String, dynamic>? getJson(String key) {
    try {
      final jsonString = getString(key);
      if (jsonString != null) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } on Exception catch (e) {
      AppLogger.error('获取JSON失败: $key', e);
      return null;
    }
  }

  /// 删除指定键的值
  ///
  /// 参数:
  /// - [key] 存储键
  ///
  /// 返回:
  /// - [Future<bool>] 是否删除成功
  Future<bool> remove(String key) async {
    try {
      return await _prefs?.remove(key) ?? false;
    } on Exception catch (e) {
      AppLogger.error('删除失败: $key', e);
      return false;
    }
  }

  /// 清除所有数据
  ///
  /// 返回:
  /// - [Future<bool>] 是否清除成功
  Future<bool> clear() async {
    try {
      return await _prefs?.clear() ?? false;
    } on Exception catch (e) {
      AppLogger.error('清除所有数据失败', e);
      return false;
    }
  }

  /// 检查键是否存在
  ///
  /// 参数:
  /// - [key] 存储键
  ///
  /// 返回:
  /// - [bool] 是否存在
  bool containsKey(String key) {
    try {
      return _prefs?.containsKey(key) ?? false;
    } on Exception catch (e) {
      AppLogger.error('检查键失败: $key', e);
      return false;
    }
  }

  /// 获取所有键
  ///
  /// 返回:
  /// - [Set<String>] 键列表
  Set<String> getKeys() {
    try {
      return _prefs?.getKeys() ?? <String>{};
    } on Exception catch (e) {
      AppLogger.error('获取键列表失败', e);
      return <String>{};
    }
  }
}
