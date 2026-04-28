// lib/features/project/model/task_model.dart


import 'package:ipsum_user/features/users/model/user_model.dart';

class TaskModel {
  final String id;
  final String project;          // project id
  final String name;
  final String description;

  /// just the ids from "assigned_to"
  final List<String> assignedToIds;

  /// full user details from "assigned_to_data"
  final List<UserModel> assignedToData;

  final String startDate;        // "2025-11-11"
  final String endDate;          // "2025-11-22"
  final String priority;         // "high_priority" | "medium_priority" | "low_priority"
  final String status;           // "on_progress", etc.
  final bool notifyDue;
  final String verificationStatus;
  final String? verifiedBy;      // can be null

  TaskModel({
    required this.id,
    required this.project,
    required this.name,
    required this.description,
    required this.assignedToIds,
    required this.assignedToData,
    required this.startDate,
    required this.endDate,
    required this.priority,
    required this.status,
    required this.notifyDue,
    required this.verificationStatus,
    required this.verifiedBy,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      project: json['project'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      assignedToIds: (json['assigned_to'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          <String>[],
      assignedToData: (json['assigned_to_data'] as List<dynamic>?)
              ?.map(
                (e) => UserModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          <UserModel>[],
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      priority: json['priority'] as String,
      status: json['status'] as String,
      notifyDue: json['notify_due'] as bool? ?? false,
      verificationStatus: json['verification_status'] as String? ?? '',
      verifiedBy: json['verified_by'] as String?,
    );
  }
}