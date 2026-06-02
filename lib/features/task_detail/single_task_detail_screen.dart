// lib/features/task_detail/single_task_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';
import 'package:ipsum_user/core/widgets/title_widget.dart';
import 'package:ipsum_user/features/project/data/repositories/projects_repository.dart';
import 'package:ipsum_user/features/task_detail/model/task_model.dart';
import 'package:ipsum_user/features/users/model/user_model.dart';
import 'package:ipsum_user/injection_container.dart';

class SingleTaskDetailScreen extends StatefulWidget {
  final TaskModel task;
  final bool canUpdateStatus;
  final bool canEditTask;

  const SingleTaskDetailScreen({
    super.key,
    required this.task,
    this.canUpdateStatus = false,
    this.canEditTask = false,
  });

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

  String _priorityLabel(String priority) {
    switch (priority) {
      case 'high_priority':
        return 'High Priority';
      case 'medium_priority':
        return 'Medium Priority';
      case 'low_priority':
        return 'Low Priority';
      default:
        return priority;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'on_progress':
        return 'On Progress';
      case 'completed':
        return 'Completed';
      case 'pending':
        return 'Pending';
      default:
        return status;
    }
  }

  Color _priorityColor(String priority) {
    switch (priority) {
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

  Color _statusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'on_progress':
        return AppColors.primary;
      case 'pending':
        return Colors.orangeAccent;
      default:
        return Colors.blueGrey;
    }
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  String _formatDate(String? value) {
    final date = _parseDate(value);
    if (date == null) return '-';

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day-$month-$year';
  }

  Future<void> _updateStatusOnServer() async {
    if (_isUpdating) return;

    if (!widget.canUpdateStatus) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You do not have permission to update this task')),
      );
      return;
    }

    final projectId = widget.task.project;
    final taskId = widget.task.id;

    if (projectId == null || projectId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project id not found for this task')),
      );
      return;
    }

    setState(() => _isUpdating = true);

    try {
      final repo = sl<ProjectsRepository>();

      await repo.updateTaskStatus(
        projectId: projectId,
        taskId: taskId,
        status: _currentStatus,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task status updated successfully')),
      );

      setState(() {});
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        title: TitleWidget(label: task.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTaskHeader(task),
            const SizedBox(height: 14),
            _buildTimelineCard(task),
            const SizedBox(height: 14),
            _buildInfoCard(task),
            const SizedBox(height: 14),
            _buildAssignedUsersCard(task),
            const SizedBox(height: 14),
            if (widget.canUpdateStatus) _buildUpdateStatusCard(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskHeader(TaskModel task) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.82),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _chip(
            label: _statusLabel(_currentStatus),
            color: Colors.white,
            textColor: AppColors.primary,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 12),
          Text(
            task.name,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            task.description.isNotEmpty
                ? task.description
                : 'No description available',
            style: GoogleFonts.poppins(
              fontSize: 13,
              height: 1.5,
              color: Colors.white.withOpacity(0.92),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(TaskModel task) {
    return _standardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Timeline'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _infoBox(
                  title: 'Start Date',
                  value: _formatDate(task.startDate),
                  icon: Icons.calendar_today_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _infoBox(
                  title: 'End Date',
                  value: _formatDate(task.endDate),
                  icon: Icons.event_available_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(TaskModel task) {
    return _standardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Task Information'),
          const SizedBox(height: 14),
          _infoRow(
            icon: Icons.flag_outlined,
            title: 'Priority',
            value: _priorityLabel(task.priority),
            color: _priorityColor(task.priority),
          ),
          const SizedBox(height: 12),
          _infoRow(
            icon: Icons.timelapse_outlined,
            title: 'Status',
            value: _statusLabel(_currentStatus),
            color: _statusColor(_currentStatus),
          ),
          const SizedBox(height: 12),
          _infoRow(
            icon: task.notifyDue
                ? Icons.notifications_active_outlined
                : Icons.notifications_off_outlined,
            title: 'Due Date Reminder',
            value: task.notifyDue ? 'Enabled' : 'Disabled',
            color: task.notifyDue ? Colors.green : Colors.redAccent,
          ),
          const SizedBox(height: 12),
          _infoRow(
            icon: Icons.verified_outlined,
            title: 'Verification',
            value: task.verificationStatus,
            color: Colors.blueGrey,
          ),
        ],
      ),
    );
  }

  Widget _buildAssignedUsersCard(TaskModel task) {
    return _standardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Assigned Users'),
          const SizedBox(height: 12),
          if (task.assignedToData.isEmpty)
            Text(
              'No users assigned',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey,
              ),
            )
          else
            Column(
              children: task.assignedToData
                  .map((user) => _buildAssignedUserTile(user))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildUpdateStatusCard() {
    return _standardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Update Status'),
          const SizedBox(height: 6),
          Text(
            'Change the current progress status of this task.',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE4E6EB)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _currentStatus,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                items: const [
                  'pending',
                  'on_progress',
                  'completed',
                ].map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(
                      _statusLabel(status),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: _isUpdating
                    ? null
                    : (value) {
                        if (value == null) return;
                        setState(() {
                          _currentStatus = value;
                        });
                      },
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _isUpdating ? null : _updateStatusOnServer,
              child: _isUpdating
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Update Status',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignedUserTile(UserModel user) {
    final displayName = (user.fullName ?? user.username).trim();
    final initials = displayName
        .split(' ')
        .where((p) => p.isNotEmpty)
        .map((p) => p[0])
        .take(2)
        .join()
        .toUpperCase();

    final role = user.roleName ?? '';
    final email = user.email ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primary.withOpacity(0.12),
            child: Text(
              initials,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF151522),
                  ),
                ),
                if (role.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    role,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
                if (email.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

  Widget _standardCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF151522),
      ),
    );
  }

  Widget _infoBox({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF151522),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          height: 34,
          width: 34,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _chip({
    required String label,
    required Color color,
    Color? textColor,
    Color? backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor ?? color,
        ),
      ),
    );
  }
}