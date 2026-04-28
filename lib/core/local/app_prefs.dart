// lib/core/local/app_prefs.dart
import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  
  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';
  static const _kUserId = 'user_id';
  static const _kUsername = 'username';
  static const _kEmpId = 'emp_id';
  static const _kRole = 'role';

  final SharedPreferences prefs;

  AppPrefs(this.prefs);

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String username,
    required String empId,
    required String role,
  }) async {
    await prefs.setString(_kAccessToken, accessToken);
    await prefs.setString(_kRefreshToken, refreshToken);
    await prefs.setString(_kUserId, userId);
    await prefs.setString(_kUsername, username);
    await prefs.setString(_kEmpId, empId);
    await prefs.setString(_kRole, role);
  }

  // 🔹 NEW: update only tokens (for refresh flow)
  Future<void> updateTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await prefs.setString(_kAccessToken, accessToken);
    await prefs.setString(_kRefreshToken, refreshToken);
  }

  String? get accessToken => prefs.getString(_kAccessToken);
  String? get refreshToken => prefs.getString(_kRefreshToken);
  String? get userId => prefs.getString(_kUserId);
  String? get username => prefs.getString(_kUsername);
  String? get empId => prefs.getString(_kEmpId);
  String? get role => prefs.getString(_kRole);

  Future<void> clearSession() async {
    await prefs.remove(_kAccessToken);
    await prefs.remove(_kRefreshToken);
    await prefs.remove(_kUserId);
    await prefs.remove(_kUsername);
    await prefs.remove(_kEmpId);
    await prefs.remove(_kRole);
  }

  bool get isLoggedIn => accessToken != null && accessToken!.isNotEmpty;
} 