// lib/features/dashboard/widget/project_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';
import 'package:ipsum_user/features/project/bloc/project_bloc.dart';
import 'package:ipsum_user/features/project/model/project_model.dart';
import 'package:ipsum_user/features/task_detail/task_detail_screen.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({super.key});

  @override
  State<ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  String _priorityFilter = 'all';

  @override
  void initState() {
    super.initState();
    context.read<ProjectBloc>().add(const FetchProjects());
  }

  List<ProjectModel> _filterProjects(List<ProjectModel> projects) {
    if (_priorityFilter == 'all') return projects;

    return projects.where((project) {
      final priority = (project.priority ?? '').toLowerCase();

      if (_priorityFilter == 'high') return priority == 'high_priority';
      if (_priorityFilter == 'medium') return priority == 'medium_priority';
      if (_priorityFilter == 'low') return priority == 'low_priority';

      return true;
    }).toList();
  }

  String _priorityLabel(String? priority) {
    switch ((priority ?? '').toLowerCase()) {
      case 'high_priority':
        return 'High';
      case 'medium_priority':
        return 'Medium';
      case 'low_priority':
        return 'Low';
      default:
        return 'Normal';
    }
  }

  Color _priorityColor(String? priority) {
    switch ((priority ?? '').toLowerCase()) {
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

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return '-';

    final date = DateTime.tryParse(value);
    if (date == null) return value;

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day-$month-$year';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        if (state is ProjectLoading) {
          return _sectionWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(count: null),
                const SizedBox(height: 20),
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 20),
              ],
            ),
          );
        }

        if (state is ProjectError) {
          return _sectionWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(count: null),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    state.message,
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is ProjectLoaded) {
          final allProjects = state.projects;
          final filteredProjects = _filterProjects(allProjects);

          return _sectionWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(count: allProjects.length),
                const SizedBox(height: 14),
                _filterRow(),
                const SizedBox(height: 16),

                if (allProjects.isEmpty)
                  _emptyState(
                    title: 'No projects found',
                    message: 'Projects created by your team will appear here.',
                  )
                else if (filteredProjects.isEmpty)
                  _emptyState(
                    title: 'No matching projects',
                    message: 'No projects found for this priority filter.',
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredProjects.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _projectCard(filteredProjects[index]);
                    },
                  ),
              ],
            ),
          );
        }

        return _sectionWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(count: null),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionWrapper({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _header({required int? count}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Project List',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF151522),
            ),
          ),
        ),
        if (count != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _filterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _filterChip('All', 'all'),
          const SizedBox(width: 8),
          _filterChip('High', 'high'),
          const SizedBox(width: 8),
          _filterChip('Medium', 'medium'),
          const SizedBox(width: 8),
          _filterChip('Low', 'low'),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String key) {
    final isSelected = _priorityFilter == key;

    return GestureDetector(
      onTap: () {
        setState(() {
          _priorityFilter = key;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : const Color(0xFFF2F4F7),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE4E6EB),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF555B66),
          ),
        ),
      ),
    );
  }

  Widget _projectCard(ProjectModel project) {
    final priorityColor = _priorityColor(project.priority);
    final priorityLabel = _priorityLabel(project.priority);

    final startDate = _formatDate(project.startDate);
    final dueDate = _formatDate(project.dueDate);

    final memberCount = project.members.length;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskDetailScreen(data: project),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFBFCFE),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE9ECF2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _projectIcon(priorityColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    project.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF151522),
                    ),
                  ),
                ),
                _priorityBadge(priorityLabel, priorityColor),
              ],
            ),

            if (project.description.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                project.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  height: 1.45,
                  color: Colors.grey.shade700,
                ),
              ),
            ],

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _dateBox(
                    title: 'Start',
                    value: startDate,
                    icon: Icons.calendar_today_outlined,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _dateBox(
                    title: 'Due',
                    value: dueDate,
                    icon: Icons.event_available_outlined,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Icon(
                  Icons.group_outlined,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 5),
                Text(
                  '$memberCount members',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                const Spacer(),
                Text(
                  'View Details',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _projectIcon(Color color) {
    return Container(
      height: 42,
      width: 42,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        Icons.work_outline_rounded,
        size: 22,
        color: color,
      ),
    );
  }

  Widget _priorityBadge(String label, Color color) {
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

  Widget _dateBox({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9ECF2)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: 7),
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
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

  Widget _emptyState({
    required String title,
    required String message,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9ECF2)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.folder_open_outlined,
            size: 46,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF151522),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}