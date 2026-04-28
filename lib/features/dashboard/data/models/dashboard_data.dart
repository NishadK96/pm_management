// lib/features/dashboard/data/models/dashboard_data.dart

import 'package:ipsum_user/features/project/model/project_model.dart';
import 'package:ipsum_user/features/task_detail/model/task_model.dart';

class DashboardData {
  final bool isCoordinator;

  // Chairman fields
  final int totalTasks;
  final int ongoingTasks;
  final int completedTasks;
  final int overDueTasks;
  final int approvalsPending;
  final ProjectModel? highlightedProject;
  final double projectCompletionPercentage;

  // Coordinator fields
  final TaskModel? highlightedTask;
  final int countdownDays;
  final int countdownHours;
  final int countdownMinutes;
  final int countdownSeconds;

  DashboardData({
    required this.isCoordinator,
    this.totalTasks = 0,
    this.ongoingTasks = 0,
    this.completedTasks = 0,
    this.overDueTasks = 0,
    this.approvalsPending = 0,
    this.highlightedProject,
    this.projectCompletionPercentage = 0.0,
    this.highlightedTask,
    this.countdownDays = 0,
    this.countdownHours = 0,
    this.countdownMinutes = 0,
    this.countdownSeconds = 0,
  });

  factory DashboardData.fromChairmanJson(Map<String, dynamic> json) {
    final highlightedJson = json['highlighted_project'] as Map<String, dynamic>?;
    return DashboardData(
      isCoordinator: false,
      totalTasks: (json['total_tasks'] ?? 0) as int,
      ongoingTasks: (json['ongoing_tasks'] ?? 0) as int,
      completedTasks: (json['completed_tasks'] ?? 0) as int,
      overDueTasks: (json['over_due_tasks'] ?? 0) as int,
      approvalsPending: (json['approvals_pending'] ?? 0) as int,
      highlightedProject:
          highlightedJson != null ? ProjectModel.fromJson(highlightedJson) : null,
      projectCompletionPercentage:
          (json['project_completion_percentage'] ?? 0.0).toDouble(),
    );
  }

  factory DashboardData.fromCoordinatorJson(Map<String, dynamic> json) {
    final highlightedTaskJson = json['highlighted_task'] as Map<String, dynamic>?;
    final countdownJson =
        json['task_end_Date_count_down'] as Map<String, dynamic>?;

    return DashboardData(
      isCoordinator: true,
      ongoingTasks: (json['ongoing_tasks'] ?? 0) as int,
      completedTasks: (json['completed_tasks'] ?? 0) as int,
      overDueTasks: (json['overdue_tasks'] ?? 0) as int,
      highlightedTask:
          highlightedTaskJson != null ? TaskModel.fromJson(highlightedTaskJson) : null,
      countdownDays: countdownJson?['days'] ?? 0,
      countdownHours: countdownJson?['hours'] ?? 0,
      countdownMinutes: countdownJson?['minutes'] ?? 0,
      countdownSeconds: countdownJson?['seconds'] ?? 0,
    );
  }
}