// lib/features/dashboard/widget/project_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/constants/icon_constants.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';
import 'package:ipsum_user/features/project/bloc/project_bloc.dart';
import 'package:ipsum_user/features/project/model/project_model.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({super.key});

  @override
  State<ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  /// 'all' | 'high' | 'medium' | 'low'
  String _priorityFilter = 'all';

  @override
  void initState() {
    print("api call for projects list");
    super.initState();
    // Trigger API call
    context.read<ProjectBloc>().add(const FetchProjects());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        if (state is ProjectLoading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Project List',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Center(child: CircularProgressIndicator()),
            ],
          );
        }

        if (state is ProjectError) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Project List',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                state.message,
                style: GoogleFonts.roboto(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ],
          );
        }

        if (state is ProjectLoaded) {
          final allProjects = state.projects;

          // If there are no projects at all -> show full empty state
          if (allProjects.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Project List",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: size.width,
                  height: 2,
                  color: AppColors.dividerGrey,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width,
                  child: SvgPicture.string(IconConst().emptyProjectIcon),
                ),
              ],
            );
          }

          // There are projects overall — apply filter
          final List<ProjectModel> filtered = _filterProjects(allProjects);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Project List',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // 🔹 Filter chips ALWAYS visible in this branch
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
              const SizedBox(height: 20),

              // 🔹 If current filter has no matches, show a small message, not full empty state
              if (filtered.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'No projects found for this priority.',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final proj = filtered[index];
                    return _buildProjectCard(proj);
                  },
                ),
            ],
          );
        }
        // Initial state
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Project List',
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  List<ProjectModel> _filterProjects(List<ProjectModel> projects) {
    if (_priorityFilter == 'all') return projects;

    return projects.where((p) {
      final pr = (p.priority ?? '').toLowerCase();
      if (_priorityFilter == 'high') {
        return pr == 'high_priority';
      } else if (_priorityFilter == 'medium') {
        return pr == 'medium_priority';
      } else if (_priorityFilter == 'low') {
        return pr == 'low_priority';
      }
      return true;
    }).toList();
  }

  Widget _filterChip(String label, String key) {
    final isSelected = _priorityFilter == key;
    return GestureDetector(
      onTap: () {
        setState(() {
          _priorityFilter = key;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.roboto(
            color: isSelected ? Colors.blue : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(ProjectModel project) {
    // Map priority text
    final String priorityLabel;
    final Color priorityColor;
    switch ((project.priority ?? '').toLowerCase()) {
      case 'high_priority':
        priorityLabel = 'High';
        priorityColor = Colors.red;
        break;
      case 'medium_priority':
        priorityLabel = 'Medium';
        priorityColor = Colors.orange;
        break;
      case 'low_priority':
        priorityLabel = 'Low';
        priorityColor = Colors.green;
        break;
      default:
        priorityLabel = 'N/A';
        priorityColor = Colors.grey;
    }

    // You don't have completion % in the API yet, so use 0 or compute later
    const double completionPercent = 0.0;

    // Format dates (they are String in your ProjectModel now)
    final startDate = project.startDate ?? '';
    final endDate = project.dueDate ?? '';

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 4,
            offset: Offset(0, 0),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            project.name,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),

          // Optional description (small)
          if (project.description.isNotEmpty) ...[
            Text(
              project.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Progress bar
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: completionPercent, // 0.0 for now
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "${(completionPercent * 100).toStringAsFixed(0)}%",
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Dates + Priority
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.string(IconConst().calenderIcon),
                  const SizedBox(width: 4),
                  Text(
                    startDate,
                    style: GoogleFonts.roboto(fontSize: 12),
                  ),
                  const SizedBox(width: 12),
                  SvgPicture.string(IconConst().flagIcon),
                  const SizedBox(width: 4),
                  Text(
                    endDate,
                    style: GoogleFonts.roboto(fontSize: 12),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  priorityLabel,
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
