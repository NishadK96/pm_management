import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ipsum_user/features/login/model/user_model.dart';

class Authentication {
  static final Authentication _singleton = Authentication._internal();
  factory Authentication() {
    return _singleton;
  }
  Authentication._internal();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final String _keyAuthenticatedUser = "keyAuthenticated";
  final String _keyUserDataList = "userListData";
  final String _keyAuthenticatedToken = "keyAuthenticatedToken";
  UserModel _authenticatedUser =  UserModel();
  List<UserModel> _userNameData = [];
  List<UserModel>? _authenticatedTokenData;
  UserModel get authenticatedUser => _authenticatedUser;
  List<UserModel> get userNameData => _userNameData;
  List<UserModel>? get authenticatedTokenData => _authenticatedTokenData;
  bool get isAuthenticated => _authenticatedUser.access != null;
  String get token => _authenticatedUser.access ?? "";
  Future<void> init() async {
    try {
      String? authenticatedUserJsonString = await _secureStorage.read(key: _keyAuthenticatedUser);
      String? authenticationSavedListData = await _secureStorage.read(key: _keyUserDataList);
      if (authenticatedUserJsonString != null) {
        _authenticatedUser = UserModel.fromJson(jsonDecode(authenticatedUserJsonString));
        if (authenticationSavedListData != null && authenticationSavedListData.isNotEmpty) {
          _userNameData = List<UserModel>.from(jsonDecode(authenticationSavedListData).map((x) => UserModel.fromJson(x)));
        }
      }
      String? authenticatedTokenJsonString = await _secureStorage.read(key: _keyAuthenticatedToken);
      if (authenticatedTokenJsonString != null) {
        _authenticatedTokenData = List<UserModel>.from(jsonDecode(authenticatedTokenJsonString).map((x) => UserModel.fromJson(x)));
      }
    } catch (e) {
      debugPrint("Authentication:init:Exception:$e");
    }
  }
  Future<void> saveAuthenticatedUser({required UserModel authenticatedUser}) async {
    print("...........${authenticatedUser.access}");
    try {
      _authenticatedUser = authenticatedUser;
      if (authenticatedUser.access!.isNotEmpty) {
        print("..............");
        await _secureStorage.write(key: _keyAuthenticatedUser, value: jsonEncode(_authenticatedUser.toJson()));

        _userNameData.add(authenticatedUser);

        await _secureStorage.write(key: _keyUserDataList, value: jsonEncode(_userNameData));
      }
    } catch (e) {
      debugPrint("Authentication:saveAuthenticatedUser:Exception:$e");
    }
  }
  Future<void> saveAuthenticatedToken({required List<UserModel> authenticatedTokenData}) async {
    try {
      _authenticatedTokenData = authenticatedTokenData;
      if (authenticatedTokenData.isNotEmpty && authenticatedTokenData[0].access!.isNotEmpty) {
        await _secureStorage.write(key: _keyAuthenticatedToken, value: jsonEncode(authenticatedTokenData));
      }
    } catch (e) {
      debugPrint("Authentication:saveAuthenticatedToken:Exception:$e");
    }
  }
  Future<void> clearAuthenticatedUser() async {
    try {
      _authenticatedUser =  UserModel();
      await _secureStorage.delete(key: _keyAuthenticatedUser);
      await _secureStorage.delete(key: _keyUserDataList);
    } catch (e) {
      debugPrint("Authentication:clearAuthenticatedUser:Exception:$e");
    }
  }
  Future<void> clearAuthenticatedTokens() async {
    try {
      _authenticatedTokenData = null;
      await _secureStorage.delete(key: _keyAuthenticatedToken);
    } catch (e) {
      debugPrint("Authentication:clearAuthenticatedTokens:Exception:$e");
    }
  }
}
final Authentication authentication = Authentication();
 