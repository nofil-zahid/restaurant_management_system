// ignore_for_file: avoid_print

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  late SharedPreferences _sharedPreferences;

  // Private constructor
  SharedPref._privateConstructor();

  // Static instance variable
  static final SharedPref _instance = SharedPref._privateConstructor();

  // Factory constructor to provide access to the singleton instance
  factory SharedPref() => _instance;

  // Initialize SharedPreferences
  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // Set a string value_
  Future<void> setValue(String key, String value) async {
    print("----------------------------------------------------");
    print("await _sharedPreferences.setString($key, $value);");
    print("----------------------------------------------------");
    await _sharedPreferences.setString(key, value);
  }

  // Get a string value
  String? getValue(String key) {
    print("----------------------------------------------------");
    print("await _sharedPreferences.getString($key);");
    print("----------------------------------------------------");
    return _sharedPreferences.getString(key);
  }

  // Remove a value
  Future<void> removeValue(String key) async {
    print("----------------------------------------------------");
    print("await _sharedPreferences.remove($key);");
    print("----------------------------------------------------");
    await _sharedPreferences.remove(key);
  }
}