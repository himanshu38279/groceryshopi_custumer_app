
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPrefs._();

  static SharedPreferences _preferences;

  static const String accessTokenString = 'accessToken';
  static const String displayShowcaseString = 'displayShowcase';
  static const String fcmTokenString = 'fcmToken';
  static const String recentSearchesString = 'recentSearches';
  static const String ratingString = 'askForRating';

  static Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setBool(String key, bool value) async =>
      await _preferences.setBool(key, value);

  static Future<bool> setString(String key, String value) async =>
      await _preferences.setString(key, value);

  static Future<bool> setStringList(String key, List<String> list) =>
      _preferences.setStringList(key, list);

  static Future<bool> remove(String key) async =>
      await _preferences.remove(key);

  static String getString(String key) => _preferences.getString(key);

  static List<String> getStringList(String key) =>
      _preferences.getStringList(key);

  static bool getBool(String key) => _preferences.getBool(key);
}
