import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/constants/icon_constants.dart';
import 'package:ipsum_user/core/local/app_prefs.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';

import 'package:ipsum_user/core/widgets/long_button.dart';
import 'package:ipsum_user/core/widgets/title_widget.dart';
import 'package:ipsum_user/features/create_project/widgets/date_time_row.dart';

import 'package:ipsum_user/features/project/data/repositories/projects_repository.dart';
import 'package:ipsum_user/features/task_detail/task_detail_card.dart';
import 'package:ipsum_user/features/task_detail/model/task_model.dart';
import 'package:ipsum_user/features/users/model/user_model.dart';

import 'package:ipsum_user/injection_container.dart';

class SingleTaskDetailScreen extends StatefulWidget {
  final TaskModel task;

  const SingleTaskDetailScreen({super.key, required this.task});

  @override
  State<SingleTaskDetailScreen> createState() => _SingleTaskDetailScreenState();
}

class _SingleTaskDetailScreenState extends State<SingleTaskDetailScreen> {
  late String _currentStatus;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.task.status;
  }

  String _priorityLabel(String p) {
    switch (p) {
      case 'high_priority':
        return 'High';
      case 'medium_priority':
        return 'Medium';
      case 'low_priority':
        return 'Low';
      default:
        return p;
    }
  }

  Color _priorityColor(String p) {
    switch (p) {
      case 'high_priority':
        return Colors.redAccent;
      case 'medium_priority':
        return Colors.orangeAccent;
      case 'low_priority':
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }

  String _statusLabel(String s) {
    switch (s) {
      case 'on_progress':
        return 'On Progress';
      case 'completed':
        return 'Completed';
      case 'pending':
        return 'Pending';
      default:
        return s;
    }
  }

  Future<void> _updateStatusOnServer() async {
    if (_isUpdating) return;

    final appPrefs = sl<AppPrefs>();
    final role = appPrefs.role;
    final isCoordinator = role?.toLowerCase() == 'coordinator' ||
        role?.toLowerCase() == 'co-ordinator';

    if (!isCoordinator) {
      // just in case someone reaches here without permission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Only coordinators can update tasks')),
      );
      return;
    }

    // project id from task model
    final projectId = widget.task.project; // adjust if your field name differs
    final taskId = widget.task.id;

    if (projectId == null || projectId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No project id found for this task')),
      );
      return;
    }

    final repo = sl<ProjectsRepository>();

    setState(() => _isUpdating = true);
    try {
      await repo.updateTaskStatus(
        projectId: projectId,
        taskId: taskId,
        status: _currentStatus,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task status updated')),
      );
      // If you want to also mutate widget.task.status locally you can:
     try {
  await repo.updateTaskStatus(
    projectId: projectId,
    taskId: taskId,
    status: _currentStatus,
  );

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Task status updated')),
  );

  // ❌ remove this
  // widget.task.status = _currentStatus;
} catch (e) {
  
}
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appPrefs = sl<AppPrefs>();
    final role = appPrefs.role;
    final isCoordinator = role?.toLowerCase() == 'coordinator' ||
        role?.toLowerCase() == 'co-ordinator';

    // parse dates as DateTime if you want to reuse DateTimeRow
    final DateTime startDate =
        DateTime.tryParse(widget.task.startDate) ?? DateTime.now();
    final DateTime endDate =
        DateTime.tryParse(widget.task.endDate) ?? DateTime.now();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TitleWidget(label: widget.task.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ✅ Title + description
            TaskDetailCard(
              title: 'Task Title',
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: TextFormField(
                  initialValue: widget.task.description,
                  maxLines: 4,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.task.description.isEmpty
                        ? 'No description'
                        : null,
                    hintStyle: GoogleFonts.poppins(fontSize: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ✅ Dates
            TaskDetailCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.string(IconConst().dateTimeIcon),
                      const SizedBox(width: 10),
                      Text(
                        'Date and Time',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF151522),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  DateTimeRow(label: 'Start Date', dateTime: startDate),
                  DateTimeRow(label: 'End Date', dateTime: endDate),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ✅ Priority + Status + Notify
            TaskDetailCard(
              title: 'Task Info',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Priority: ',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _priorityColor(widget.task.priority)
                              .withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _priorityLabel(widget.task.priority),
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _priorityColor(widget.task.priority),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Status: ',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _statusLabel(_currentStatus),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Notify on due date: ',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(
                        widget.task.notifyDue
                            ? Icons.check_circle
                            : Icons.cancel,
                        size: 16,
                        color: widget.task.notifyDue
                            ? Colors.green
                            : Colors.redAccent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Verification: ',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        widget.task.verificationStatus,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ✅ Assigned To (from assigned_to_data)
            TaskDetailCard(
              title: 'Assigned To',
              child: widget.task.assignedToData.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'No users assigned',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textGrey,
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...widget.task.assignedToData
                            .map(_buildAssignedUserTile),
                      ],
                    ),
            ),
            const SizedBox(height: 12),

            // 🔹 Coordinator-only: status update controls
            if (isCoordinator) ...[
              TaskDetailCard(
                title: 'Update Status',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Change task status',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFE0E0E0),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _currentStatus,
                                items: const [
                                  'on_progress',
                                  'completed',
                                  'pending',
                                ].map((s) {
                                  return DropdownMenuItem<String>(
                                    value: s,
                                    child: Text(
                                      _statusLabel(s),
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value == null) return;
                                  setState(() {
                                    _currentStatus = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed:
                                _isUpdating ? null : _updateStatusOnServer,
                            child: _isUpdating
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                              Colors.white),
                                    ),
                                  )
                                : const Text('Update'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

         LongButton(
  label: "Back",
  onTap: () async {
    Navigator.pop(context);
  },
),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignedUserTile(UserModel u) {
    final displayName = (u.fullName ?? u.username).trim();
    final initials = displayName
        .split(' ')
        .where((p) => p.isNotEmpty)
        .map((p) => p[0])
        .take(2)
        .join()
        .toUpperCase();

    final role = u.roleName;
    final email = u.email ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary,
            child: Text(
              initials,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role??"",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textGrey,
                  ),
                ),
                if (email.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    email,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}