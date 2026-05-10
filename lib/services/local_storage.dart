import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorage {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // String operations
  static Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  // Boolean operations
  static Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // Integer operations
  static Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // List operations
  static Future<bool> setList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  static List<String>? getList(String key) {
    return _prefs.getStringList(key);
  }

  // Json operations
  static Future<bool> setJson(String key, Map<String, dynamic> value) async {
    return await _prefs.setString(key, jsonEncode(value));
  }

  static Map<String, dynamic>? getJson(String key) {
    final data = _prefs.getString(key);
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }

  // Delete operations
  static Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  static Future<bool> clear() async {
    return await _prefs.clear();
  }

  // Check key exists
  static bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  // Get all keys
  static Set<String> getKeys() {
    return _prefs.getKeys();
  }
}
