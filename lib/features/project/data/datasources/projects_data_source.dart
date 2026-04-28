// lib/features/project/data/datasources/projects_data_source.dart
import 'package:dio/dio.dart';
import 'package:ipsum_user/core/local/app_prefs.dart';
import 'package:ipsum_user/features/project/model/project_model.dart';
import 'package:ipsum_user/features/task_detail/model/task_model.dart';

class ProjectsDataSource {
  final Dio client;
  final AppPrefs appPrefs;

  ProjectsDataSource({
    required this.client,
    required this.appPrefs,
  });
  static const _projectsRootUrl =
      'https://backend.project-management-tool.shamshailksa.com/projects/';
  static const _projectsUrl =
      'https://backend.project-management-tool.shamshailksa.com/projects/projects/';
  static const _refreshUrl =
      'https://backend.project-management-tool.shamshailksa.com/auth/api/token/refresh/';
Future<void> updateTaskStatus({
  required String projectId,
  required String taskId,
  required String status,
}) async {
  final accessToken = appPrefs.accessToken;
  if (accessToken == null || accessToken.isEmpty) {
    throw Exception('No access token. Please login again.');
  }

  // /projects/<project_id>/tasks/<id>/
  final url = '$_projectsRootUrl$projectId/tasks/$taskId/';

  try {
    final response = await client.patch(
      url,
      data: {
        'status': status,
      },
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    if (response.statusCode != 200 && response.statusCode != 202) {
      throw Exception('Failed to update task: ${response.statusCode}');
    }
  } on DioError catch (e) {
    if (e.response?.statusCode == 401) {
      final refreshed = await _refreshToken();
      if (!refreshed) {
        throw Exception('Session expired. Please login again.');
      }

      final newAccess = appPrefs.accessToken;
      if (newAccess == null || newAccess.isEmpty) {
        throw Exception('No new access token after refresh.');
      }

      final retry = await client.patch(
        url,
        data: {
          'status': status,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $newAccess',
          },
        ),
      );

      if (retry.statusCode != 200 && retry.statusCode != 202) {
        throw Exception(
            'Failed to update task after refresh: ${retry.statusCode}');
      }
    } else {
      rethrow;
    }
  }
}

Future<void> addMemberToProject({
  required String projectId,
  required String userId,
}) async {
  final accessToken = appPrefs.accessToken;
  if (accessToken == null || accessToken.isEmpty) {
    throw Exception('No access token. Please login again.');
  }

  final url = '$_projectsRootUrl$projectId/add-member/';
  try {
    final response = await client.post(
      url,
      data: {'user_id': userId},
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to add member: ${response.statusCode}');
    }
  } on DioError catch (e) {
    if (e.response?.statusCode == 401) {
      final refreshed = await _refreshToken();
      if (!refreshed) {
        throw Exception('Session expired. Please login again.');
      }

      final newToken = appPrefs.accessToken;
      if (newToken == null || newToken.isEmpty) {
        throw Exception('No new access token after refresh.');
      }

      final retryResponse = await client.post(
        url,
        data: {'user_id': userId},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $newToken',
          },
        ),
      );

      if (retryResponse.statusCode != 201 &&
          retryResponse.statusCode != 200) {
        throw Exception(
            'Failed to add member after refresh: ${retryResponse.statusCode}');
      }
    } else {
      rethrow;
    }
  }
}
  Future<List<ProjectModel>> getProjects() async {
    print("calling get projects api");
    final accessToken = appPrefs.accessToken;

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('No access token. Please login again.');
    }

    try {
      final response = await client.get(
        _projectsUrl,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
print("responseee $response");
      // 200 OK
      if (response.statusCode == 200) {
        return _parseProjects(response.data);
      }

      // any other non-200
      throw Exception('Failed to load projects: ${response.statusCode}');
    } on DioException catch (e) {
      // If unauthorized, try refresh flow
      if (e.response?.statusCode == 401) {
        final refreshed = await _refreshToken();
        if (!refreshed) {
          // refresh failed → you can choose to logout user here
          throw Exception('Session expired. Please login again.');
        }

        // Retry with new access token
        final newAccess = appPrefs.accessToken;
        if (newAccess == null || newAccess.isEmpty) {
          throw Exception('No new access token after refresh.');
        }

        final retryResponse = await client.get(
          _projectsUrl,
          options: Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $newAccess',
            },
          ),
        );

        if (retryResponse.statusCode == 200) {
          return _parseProjects(retryResponse.data);
        } else {
          throw Exception(
              'Failed to load projects after refresh: ${retryResponse.statusCode}');
        }
      }

      // rethrow for non-401 errors
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  /// Parse "data" array from the response
  List<ProjectModel> _parseProjects(dynamic data) {
    if (data is Map<String, dynamic>) {
      final list = data['data'] as List<dynamic>? ?? [];
      return list
          .map((item) => ProjectModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Unexpected projects response format');
    }
  }

  // 🔹 CREATE PROJECT
  Future<ProjectModel> createProject({
    required String name,
    required String description,
    required String startDate, // yyyy-MM-dd
    required String dueDate, // yyyy-MM-dd
    required bool notifyDue,
  }) async {
    final accessToken = appPrefs.accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('No access token. Please login again.');
    }

    try {
      final response = await client.post(
        _projectsUrl,
        data: {
          "name": name,
          "description": description,
          "start_date": startDate,
          "due_date": dueDate,
          "notify_due": notifyDue,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );
print("responseee $response");
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data['data'];
        return ProjectModel.fromJson(data as Map<String, dynamic>);
      }

      throw Exception('Failed to create project: ${response.statusCode}');
    } on DioError catch (e) {
      // 401 → try refresh, then retry
      if (e.response?.statusCode == 401) {
        final refreshed = await _refreshToken();
        if (!refreshed) {
          throw Exception('Session expired. Please login again.');
        }

        final newAccess = appPrefs.accessToken;
        if (newAccess == null || newAccess.isEmpty) {
          throw Exception('No new access token after refresh.');
        }

        final retryResponse = await client.post(
          _projectsUrl,
          data: {
            "name": name,
            "description": description,
            "start_date": startDate,
            "due_date": dueDate,
            "notify_due": notifyDue,
          },
          options: Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $newAccess',
              'Content-Type': 'application/json',
            },
          ),
        );

        if (retryResponse.statusCode == 201 ||
            retryResponse.statusCode == 200) {
          final data = retryResponse.data['data'];
          return ProjectModel.fromJson(data as Map<String, dynamic>);
        } else {
          throw Exception(
              'Failed to create project after refresh: ${retryResponse.statusCode}');
        }
      }

      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TaskModel>> getTasksForProject(String projectId) async {
    final accessToken = appPrefs.accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('No access token. Please login again.');
    }

    final url = '$_projectsRootUrl$projectId/tasks/';
    // if your backend really uses "project-idtasks/" without slash,
    // change it to '$_projectsRootUrl$projectIdtasks/'

    try {
      final response = await client.get(
        url,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        return _parseTasks(response.data);
      }

      throw Exception('Failed to load tasks: ${response.statusCode}');
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        final refreshed = await _refreshToken();
        if (!refreshed) {
          throw Exception('Session expired. Please login again.');
        }

        final newAccess = appPrefs.accessToken;
        if (newAccess == null || newAccess.isEmpty) {
          throw Exception('No new access token after refresh.');
        }

        final retryResponse = await client.get(
          url,
          options: Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $newAccess',
            },
          ),
        );

        if (retryResponse.statusCode == 200) {
          return _parseTasks(retryResponse.data);
        } else {
          throw Exception(
              'Failed to load tasks after refresh: ${retryResponse.statusCode}');
        }
      }

      rethrow;
    } catch (e) {
      rethrow;
    }
  }
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
    } on DioException catch (e) {
      // refresh on 401
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

 // 🔹 new: raw dashboard json
  Future<Map<String, dynamic>> getDashboardJson({
    required bool isCoordinator,
  }) async {
    final path = isCoordinator
        ? '/projects/dashboard/mobile/coordinator/'
        : '/projects/dashboard/mobile/';
    final response = await _authorizedGet(path);
    final data = response.data as Map<String, dynamic>;
    return data;
  }


  Future<TaskModel> createTask({
    required String projectId,
    required String name,
    required String description,
    required List<String> assignedTo,
    required String startDate, // "yyyy-MM-dd"
    required String endDate, // "yyyy-MM-dd"
    required String
        priority, // "low_priority" | "medium_priority" | "high_priority"
    required bool notifyDue,
  }) async {
    final accessToken = appPrefs.accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('No access token. Please login again.');
    }

    final url = '$_projectsRootUrl$projectId/tasks/';

    Map<String, dynamic> body = {
      "name": name,
      "description": description,
      "assigned_to": assignedTo,
      "start_date": startDate,
      "end_date": endDate,
      "priority": priority,
      "notify_due": notifyDue,
    };

    try {
      final response = await client.post(
        url,
        data: body,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data['data'];
        return TaskModel.fromJson(data as Map<String, dynamic>);
      }

      throw Exception('Failed to create task: ${response.statusCode}');
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        final refreshed = await _refreshToken();
        if (!refreshed) {
          throw Exception('Session expired. Please login again.');
        }

        final newAccess = appPrefs.accessToken;
        if (newAccess == null || newAccess.isEmpty) {
          throw Exception('No new access token after refresh.');
        }

        final retryResponse = await client.post(
          url,
          data: body,
          options: Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $newAccess',
              'Content-Type': 'application/json',
            },
          ),
        );

        if (retryResponse.statusCode == 201 ||
            retryResponse.statusCode == 200) {
          final data = retryResponse.data['data'];
          return TaskModel.fromJson(data as Map<String, dynamic>);
        } else {
          throw Exception(
            'Failed to create task after refresh: ${retryResponse.statusCode}',
          );
        }
      }

      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  List<TaskModel> _parseTasks(dynamic data) {
    if (data is Map<String, dynamic>) {
      final list = data['data'] as List<dynamic>? ?? [];
      return list
          .map((item) => TaskModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Unexpected tasks response format');
    }
  }

  // 🔹 your existing _refreshToken() is reused
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
}
