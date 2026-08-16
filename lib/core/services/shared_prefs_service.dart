import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_keys.dart';

class SharedPrefsService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- Auth Tokens ---
  static Future<void> saveTokens({required String access, required String refresh}) async {
    await _prefs.setString(StorageKeys.accessToken, access);
    await _prefs.setString(StorageKeys.refreshToken, refresh);
  }

  static String? getAccessToken() {
    return _prefs.getString(StorageKeys.accessToken);
  }

  static String? getRefreshToken() {
    return _prefs.getString(StorageKeys.refreshToken);
  }

  static Future<void> clearAuth() async {
    await _prefs.remove(StorageKeys.accessToken);
    await _prefs.remove(StorageKeys.refreshToken);
    await _prefs.remove(StorageKeys.userId);
    await _prefs.remove(StorageKeys.userEmail);
  }

  // --- User Data ---
  static Future<void> saveUser({String? id, String? email}) async {
    if (id != null) await _prefs.setString(StorageKeys.userId, id);
    if (email != null) await _prefs.setString(StorageKeys.userEmail, email);
  }

  static String? getUserId() {
    return _prefs.getString(StorageKeys.userId);
  }

  static String? getUserEmail() {
    return _prefs.getString(StorageKeys.userEmail);
  }
}
