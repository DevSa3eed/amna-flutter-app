import 'package:shared_preferences/shared_preferences.dart';

class cacheHelper {
  static SharedPreferences? sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> SaveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await sharedPreferences!.setString(key, value);
    if (value is bool) return await sharedPreferences!.setBool(key, value);
    if (value is int) return await sharedPreferences!.setInt(key, value);
    return await sharedPreferences!.setDouble(key, value);
  }

  static getData(String key) {
    return sharedPreferences!.get(key);
  }

  static Future<bool> removeData(String key) async {
    return await sharedPreferences!.remove(key);
  }

  static const String LANGUAGE_CODE = 'languageCode';

  Future<void> setLanguage(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(LANGUAGE_CODE, code);
  }

  Future<String> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(LANGUAGE_CODE) ?? 'en';
  }
}
