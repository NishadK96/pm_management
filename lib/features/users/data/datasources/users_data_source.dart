import 'package:dio/dio.dart';
import 'package:ipsum_user/features/users/model/user_document_model.dart';
import 'package:ipsum_user/features/users/model/user_model.dart';
import 'package:ipsum_user/features/users/model/user_profile_model.dart';

import '../../../../core/local/app_prefs.dart';

class UsersDataSource {
  final Dio client;
  final AppPrefs appPrefs;

  UsersDataSource({
    required this.client,
    required this.appPrefs,
  });
 static const _refreshUrl =
      'https://backend.project-management-tool.shamshailksa.com/auth/api/token/refresh/';

  static const String _baseUrl =
      'https://backend.project-management-tool.shamshailksa.com';

  Future<Response> _authorizedGet(String path) async {
    final url = '$_baseUrl$path';
    final token = appPrefs.accessToken;

    try {
      final response = await client.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      return response;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await _refreshToken();
        final newToken = appPrefs.accessToken;
        final retry = await client.get(
          url,
          options: Options(
            headers: {
              'Authorization': 'Bearer $newToken',
              'Accept': 'application/json',
            },
          ),
        );
        return retry;
      }
      rethrow;
    }
  }

  Future<bool> _refreshToken() async {
    final refreshToken = appPrefs.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    try {
      final response = await client.post(
        _refreshUrl,
        data: {"refresh": refreshToken},
        options: Options(
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final body = response.data as Map<String, dynamic>;
        final newAccess = body['access'] as String?;
        final newRefresh = body['refresh'] as String?;

        if (newAccess == null || newRefresh == null) return false;

        await appPrefs.updateTokens(
          accessToken: newAccess,
          refreshToken: newRefresh,
        );
        return true;
      }
      return false;
    } on DioError {
      return false;
    } catch (_) {
      return false;
    }
  }

  // already existing:
  Future<List<UserModel>> getAllUsers() async {
    final resp = await _authorizedGet('/user/all-users/');
    print("responseee ${resp.data}");
    final list = resp.data['data'] as List<dynamic>;
    return list.map((e) => UserModel.fromJson(e)).toList();
  }


  Future<List<UserDocumentModel>> getUserDocuments(String userId) async {
    final url = '$_baseUrl/user/$userId/documents/';
    try {
      final response = await client.get(
        url,
        options: Options(
          headers: {
            'Accept': 'application/json',
            // ❗️ NO Authorization header – API is not authorized
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final list = data['data'] as List<dynamic>? ?? [];
        return list
            .map((e) =>
                UserDocumentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Failed to load documents: ${response.statusCode}');
    } on DioError catch (e) {
      throw Exception('Failed to load documents: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }
 Future<UserDocumentModel> updateUserDocument({
    required String userId,
    required String documentId,
    required String filePath,        // 👈 local file path
    required String fileName,
    required String documentNumber,
    required String issueDate,
    required String expiryDate,
  }) async {
    final url =
        'https://backend.project-management-tool.shamshailksa.com/user/$userId/documents/$documentId/';

    final formData = FormData.fromMap({
      "document": await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      ),
      "file_name": fileName,
      "document_number": documentNumber,
      "issue_date": issueDate,
      "expiry_date": expiryDate,
    });

    final response = await client.put(
      url,
      data: formData,
      options: Options(
        headers: {
          'Accept': 'application/json',
          // 🔴 This API is NOT authorized, so no Authorization header
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data['data'] as Map<String, dynamic>;
      return UserDocumentModel.fromJson(data);
    }

    throw Exception('Failed to update document: ${response.statusCode}');
  }

  // 🔹 NEW: get user profile
  Future<UserProfileModel> getUserProfile(String userId) async {
    final resp = await _authorizedGet('/user/user-profile/$userId/');
    final data = resp.data['data'] as Map<String, dynamic>;
    return UserProfileModel.fromJson(data);
  }
}