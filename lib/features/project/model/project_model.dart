

import 'package:ipsum_user/features/users/model/user_model.dart';

class ProjectMember {
  final String id;
  final UserModel user;
  final String role;
  final String joinedAt;   // ISO string
  final String? leftAt;    // ISO string or null
  final String createdAt;  // ISO string
  final String updatedAt;  // ISO string

  ProjectMember({
    required this.id,
    required this.user,
    required this.role,
    required this.joinedAt,
    required this.leftAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProjectMember.fromJson(Map<String, dynamic> json) {
    return ProjectMember(
      id: json['id'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      role: (json['role'] as String?) ?? '',
      joinedAt: (json['joined_at'] as String?) ?? '',
      leftAt: json['left_at'] as String?,
      createdAt: (json['created_at'] as String?) ?? '',
      updatedAt: (json['updated_at'] as String?) ?? '',
    );
  }
}

class ProjectModel {
  final String id;
  final String name;
  final String description;
  final String startDate;   // "2025-10-01T00:00:00Z"
  final String dueDate;     // "2025-12-31T00:00:00Z"
  final String status;      // e.g. "on_progress"
  final String priority;    // e.g. "low_priority"
  final bool notifyDue;
  final String createdAt;   // ISO string
  final String updatedAt;   // ISO string
  final List<ProjectMember> members;
  final String createdBy;
  final String? updatedBy;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.dueDate,
    required this.status,
    required this.priority,
    required this.notifyDue,
    required this.createdAt,
    required this.updatedAt,
    required this.members,
    required this.createdBy,
    required this.updatedBy,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    final membersJson = json['members'] as List<dynamic>? ?? [];

    return ProjectModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: (json['description'] as String?) ?? '',
      startDate: json['start_date'] as String,
      dueDate: json['due_date'] as String,
      status: json['status'] as String,
      priority: json['priority'] as String,
      notifyDue: (json['notify_due'] as bool?) ?? false,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      members: membersJson
          .map((e) => ProjectMember.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdBy: json['created_by'] as String,
      updatedBy: json['updated_by'] as String?,
    );
  }
}