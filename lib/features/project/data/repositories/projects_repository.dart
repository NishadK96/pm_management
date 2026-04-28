// lib/features/project/data/repositories/projects_repository.dart
import 'package:ipsum_user/features/dashboard/data/models/dashboard_data.dart';
import 'package:ipsum_user/features/project/data/datasources/projects_data_source.dart';
import 'package:ipsum_user/features/project/model/project_model.dart';
import 'package:ipsum_user/features/task_detail/model/task_model.dart';

class ProjectsRepository {
  final ProjectsDataSource dataSource;

  ProjectsRepository({required this.dataSource});

  Future<List<ProjectModel>> getProjects() {
    return dataSource.getProjects();
  }

  Future<ProjectModel> createProject({
    required String name,
    required String description,
    required String startDate,
    required String dueDate,
    required bool notifyDue,
  }) {
    return dataSource.createProject(
      name: name,
      description: description,
      startDate: startDate,
      dueDate: dueDate,
      notifyDue: notifyDue,
    );
  }

  // 🔹 new: tasks under a project
  Future<List<TaskModel>> getTasksForProject(String projectId) {
    return dataSource.getTasksForProject(projectId);
  }

  Future<TaskModel> createTask({
    required String projectId,
    required String name,
    required String description,
    required List<String> assignedTo,
    required String startDate,
    required String endDate,
    required String priority,
    required bool notifyDue,
  }) {
    return dataSource.createTask(
      projectId: projectId,
      name: name,
      description: description,
      assignedTo: assignedTo,
      startDate: startDate,
      endDate: endDate,
      priority: priority,
      notifyDue: notifyDue,
    );
  }
Future<DashboardData> getDashboardData({required bool isCoordinator}) async {
    final json = await dataSource.getDashboardJson(isCoordinator: isCoordinator);
    final data = json['data'] as Map<String, dynamic>;

    if (isCoordinator) {
      return DashboardData.fromCoordinatorJson(data);
    } else {
      return DashboardData.fromChairmanJson(data);
    }
  }
 Future<void> addMemberToProject({
    required String projectId,
    required String userId,
  }) {
    return dataSource.addMemberToProject(projectId: projectId, userId: userId);
  }
  Future<void> updateTaskStatus({
    required String projectId,
    required String taskId,
    required String status,
  }) {
    return dataSource.updateTaskStatus(
      projectId: projectId,
      taskId: taskId,
      status: status,
    );
  }
}