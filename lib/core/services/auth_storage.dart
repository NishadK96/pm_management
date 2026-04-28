import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';
  static const _kUserId = 'user_id';
  static const _kUsername = 'username';
  static const _kEmpId = 'emp_id';
  static const _kRole = 'role';

  // Call this after login success
  static Future<void> saveLoginData({
    required String access,
    required String refresh,
    required String userId,
    required String username,
    required String empId,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAccessToken, access);
    await prefs.setString(_kRefreshToken, refresh);
    await prefs.setString(_kUserId, userId);
    await prefs.setString(_kUsername, username);
    await prefs.setString(_kEmpId, empId);
    await prefs.setString(_kRole, role);
  }

  // Read later anywhere in the app
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kAccessToken);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kAccessToken);
    await prefs.remove(_kRefreshToken);
    await prefs.remove(_kUserId);
    await prefs.remove(_kUsername);
    await prefs.remove(_kEmpId);
    await prefs.remove(_kRole);
  }
}