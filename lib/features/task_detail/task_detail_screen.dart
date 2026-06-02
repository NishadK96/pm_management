// lib/features/task_detail/task_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipsum_user/core/local/app_prefs.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';
import 'package:ipsum_user/core/widgets/title_widget.dart';
import 'package:ipsum_user/features/project/data/repositories/projects_repository.dart';
import 'package:ipsum_user/features/task_detail/create_new_task_button.dart';
import 'package:ipsum_user/features/task_detail/single_task_detail_screen.dart';
import 'package:ipsum_user/features/project/model/project_model.dart';
import 'package:ipsum_user/features/task_detail/bloc/task_bloc.dart';
import 'package:ipsum_user/features/task_detail/model/task_model.dart';
import 'package:ipsum_user/features/users/data/repositories/users_repository.dart';
import 'package:ipsum_user/injection_container.dart';

class TaskDetailScreen extends StatefulWidget {
  final ProjectModel? data;

  const TaskDetailScreen({
    super.key,
    this.data,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  List<TaskModel>? taskList;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    final projectId = widget.data?.id;
    if (projectId != null && projectId.isNotEmpty) {
      context.read<TaskBloc>().add(
            FetchTasksForProject(projectId: projectId),
          );
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

  String _priorityLabel(String priority) {
    switch (priority) {
      case 'high_priority':
        return 'High';
      case 'medium_priority':
        return 'Medium';
      case 'low_priority':
        return 'Low';
      default:
        return priority;
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

  @override
  Widget build(BuildContext context) {
    final appPrefs = sl<AppPrefs>();
    final role = appPrefs.role?.toLowerCase().trim();

    final isCoordinator = role == 'coordinator' || role == 'co-ordinator';
    final isEmployee = role == 'employee';
    final isChairman = role == 'chairman';
    final isDirector = role == 'director';

    final canCreateTask = isChairman || isDirector;
    final canUpdateStatus = isCoordinator || isEmployee;

    final projectsRepository = sl<ProjectsRepository>();
    final usersRepository = sl<UsersRepository>();

    final project = widget.data;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        title: TitleWidget(label: project?.name ?? 'Project Detail'),
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskLoading) {
            setState(() => isLoading = true);
          } else {
            setState(() => isLoading = false);
          }

          if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }

          if (state is TaskLoaded) {
            setState(() {
              taskList = state.tasks;
            });
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              final id = project?.id;
              if (id != null && id.isNotEmpty) {
                context.read<TaskBloc>().add(
                      FetchTasksForProject(projectId: id),
                    );
              }
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProjectHeader(project, role ?? '-'),
                  const SizedBox(height: 14),
                  _buildProjectInfo(project),
                  const SizedBox(height: 14),
                  _buildMembersSection(project),
                  const SizedBox(height: 18),

                  if (canCreateTask && project?.id != null) ...[
                    CreateNewTaskButton(
                      projectId: project!.id,
                      projectsRepository: projectsRepository,
                      usersRepository: usersRepository,
                      projectMembers: project.members,
                      onTaskCreated: () {
                        final id = project.id;
                        if (id.isNotEmpty) {
                          context.read<TaskBloc>().add(
                                FetchTasksForProject(projectId: id),
                              );
                        }
                      },
                    ),
                    const SizedBox(height: 18),
                  ],

                  _buildTaskSectionHeader(taskList?.length ?? 0),
                  const SizedBox(height: 10),

                  if (isLoading && (taskList == null || taskList!.isEmpty))
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (taskList != null && taskList!.isNotEmpty)
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: taskList!.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final task = taskList![index];

                        return _buildTaskCard(
                          task: task,
                          canUpdateStatus: canUpdateStatus,
                          canEditTask: canCreateTask,
                        );
                      },
                    )
                  else
                    _buildEmptyTasksCard(canCreateTask),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProjectHeader(ProjectModel? project, String role) {
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
          Text(
            project?.name ?? 'Untitled Project',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            project?.description?.isNotEmpty == true
                ? project!.description!
                : 'No description available',
            style: GoogleFonts.poppins(
              fontSize: 13,
              height: 1.5,
              color: Colors.white.withOpacity(0.92),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              role.toUpperCase(),
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectInfo(ProjectModel? project) {
    return _standardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Project Timeline'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _infoBox(
                  title: 'Start Date',
                  value: _formatDate(project?.startDate),
                  icon: Icons.calendar_today_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _infoBox(
                  title: 'Due Date',
                  value: _formatDate(project?.dueDate),
                  icon: Icons.event_available_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMembersSection(ProjectModel? project) {
    final members = project?.members ?? [];

    return _standardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Project Members'),
          const SizedBox(height: 12),
          if (members.isEmpty)
            Text(
              'No members added',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey,
              ),
            )
          else
            SizedBox(
              height: 76,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: members.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (ctx, index) {
                  final member = members[index];
                  final user = member.user;
                  final name = (user.fullName ?? user.username).trim();
                  final initials = name
                      .split(' ')
                      .where((p) => p.isNotEmpty)
                      .map((p) => p[0])
                      .take(2)
                      .join()
                      .toUpperCase();

                  return SizedBox(
                    width: 72,
                    child: Column(
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
                        const SizedBox(height: 6),
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF151522),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTaskSectionHeader(int count) {
    return Row(
      children: [
        Text(
          'Tasks',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF151522),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard({
    required TaskModel task,
    required bool canUpdateStatus,
    required bool canEditTask,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SingleTaskDetailScreen(
              task: task,
              canUpdateStatus: canUpdateStatus,
              canEditTask: canEditTask,
            ),
          ),
        );
      },
      child: _standardCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF151522),
                    ),
                  ),
                ),
                _chip(
                  label: _statusLabel(task.status),
                  color: _statusColor(task.status),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              task.description.isNotEmpty
                  ? task.description
                  : 'No description available',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 12,
                height: 1.5,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _smallInfo(
                  icon: Icons.flag_outlined,
                  text: _priorityLabel(task.priority),
                  color: _priorityColor(task.priority),
                ),
                const SizedBox(width: 14),
                _smallInfo(
                  icon: Icons.calendar_today_outlined,
                  text: _formatDate(task.endDate),
                  color: Colors.blueGrey,
                ),
                const Spacer(),
                _assignedAvatars(task),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _assignedAvatars(TaskModel task) {
    if (task.assignedToData.isEmpty) {
      return Text(
        'Unassigned',
        style: GoogleFonts.poppins(
          fontSize: 11,
          color: Colors.grey,
        ),
      );
    }

    return Row(
      children: [
        ...task.assignedToData.take(2).map((u) {
          final name = (u.fullName ?? u.username).trim();
          final initials = name
              .split(' ')
              .where((p) => p.isNotEmpty)
              .map((p) => p[0])
              .take(2)
              .join()
              .toUpperCase();

          return Padding(
            padding: const EdgeInsets.only(left: 4),
            child: CircleAvatar(
              radius: 13,
              backgroundColor: AppColors.primary.withOpacity(0.12),
              child: Text(
                initials,
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        }),
        if (task.assignedToData.length > 2)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              '+${task.assignedToData.length - 2}',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF151522),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyTasksCard(bool canCreateTask) {
    return _standardCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.task_alt_outlined,
                size: 42,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 10),
              Text(
                'No tasks found',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF151522),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                canCreateTask
                    ? 'Create a new task to get started.'
                    : 'No tasks are assigned in this project yet.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
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

  Widget _smallInfo({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _chip({
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}