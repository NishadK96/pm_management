// lib/features/dashboard/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/constants/icon_constants.dart';
import 'package:ipsum_user/core/local/app_prefs.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';
import 'package:ipsum_user/features/create_project/create_project_screen.dart';
import 'package:ipsum_user/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:ipsum_user/features/dashboard/widget/dashboard_button.dart';
import 'package:ipsum_user/features/dashboard/widget/dashboard_card.dart';
import 'package:ipsum_user/features/dashboard/widget/progression_card.dart';
import 'package:ipsum_user/features/dashboard/widget/project_list.dart';
import 'package:ipsum_user/features/notification/notification_screen.dart';
import 'package:ipsum_user/features/profile/profile_screen.dart';
import 'package:ipsum_user/features/project/project_screen.dart';
import 'package:ipsum_user/features/users/data/repositories/users_repository.dart';
import 'package:ipsum_user/features/users/model/user_profile_model.dart';
import 'package:ipsum_user/features/users/users_list_screen.dart';
import 'package:ipsum_user/injection_container.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _initialized = false;
  UserProfileModel? _profile;
  bool _profileLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final appPrefs = sl<AppPrefs>();
    final userId = appPrefs.userId;

    if (userId == null) {
      setState(() => _profileLoading = false);
      return;
    }

    try {
      final repo = sl<UsersRepository>();
      final profile = await repo.getUserProfile(userId);

      if (mounted) {
        setState(() {
          _profile = profile;
          _profileLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _profileLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appPrefs = sl<AppPrefs>();
    final role = appPrefs.role?.toLowerCase().trim();

    final isCoordinator = role == 'coordinator' || role == 'co-ordinator';
    final isChairman = role == 'chairman';

    if (!_initialized) {
      _initialized = true;
      context.read<DashboardBloc>().add(
            DashboardStarted(isCoordinator: isCoordinator),
          );
    }

    final displayName = _profile?.fullName ?? _profile?.username ?? 'User';
    final empId = _profile?.empId ?? '---';
    final profilePic = _profile?.profilePicture;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildHeader(
                  context: context,
                  displayName: displayName,
                  role: appPrefs.role ?? '',
                  empId: empId,
                  profilePic: profilePic,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildDashboardContent(
                    context: context,
                    state: state,
                    isChairman: isChairman,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader({
    required BuildContext context,
    required String displayName,
    required String role,
    required String empId,
    required String? profilePic,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.tertiary,
            AppColors.secondary,
            AppColors.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileDetailsScreen(),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white.withOpacity(0.25),
                backgroundImage: profilePic != null && profilePic.isNotEmpty
                    ? NetworkImage(profilePic)
                    : const NetworkImage(
                        'https://img.freepik.com/premium-photo/happy-man-ai-generated-portrait-user-profile_1119669-1.jpg?w=2000',
                      ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _profileLoading
                  ? const LinearProgressIndicator(
                      minHeight: 2,
                      color: Colors.white,
                      backgroundColor: Colors.transparent,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '$role • ID: $empId',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.78),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NotificationsScreen(),
                  ),
                );
              },
              child: Container(
                height: 42,
                width: 42,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: SvgPicture.string(
                  IconConst().notificationIcon,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent({
    required BuildContext context,
    required DashboardState state,
    required bool isChairman,
  }) {
    if (state is DashboardLoading || state is DashboardInitial) {
      return const Padding(
        padding: EdgeInsets.only(top: 80),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state is DashboardError) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          state.message,
          style: GoogleFonts.poppins(
            color: Colors.red,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    if (state is! DashboardLoaded) {
      return const SizedBox.shrink();
    }

    final d = state.data;

    final highlightTitle = d.isCoordinator
        ? d.highlightedTask?.name ?? 'Highlighted Task'
        : d.highlightedProject?.name ?? 'Highlighted Project';

    final highlightDescription = d.isCoordinator
        ? d.highlightedTask?.description ?? ''
        : d.highlightedProject?.description ?? '';

    final highlightDate = d.isCoordinator
        ? d.highlightedTask?.endDate ?? ''
        : d.highlightedProject?.dueDate ?? '';

    final progress = d.isCoordinator ? 0.0 : d.projectCompletionPercentage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProgressionCard(
          title: highlightTitle,
          description: highlightDescription,
          progress: progress,
          dateText: highlightDate,
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProjectScreen(),
                    ),
                  );
                },
                child: DashboardCard(
                  title: d.isCoordinator ? 'My Tasks' : 'All Projects',
                  count: d.isCoordinator
                      ? d.ongoingTasks.toString()
                      : d.totalTasks.toString(),
                  subtitle: d.isCoordinator ? 'Tasks' : 'Projects',
                  icon: IconConst().projectIcon,
                  color: const Color(0xFFE3F2FD),
                  iconColor: const Color(0xFF1565C0),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DashboardCard(
                title: 'Approvals',
                count: d.isCoordinator ? '0' : d.approvalsPending.toString(),
                subtitle: 'Requests',
                icon: IconConst().approvalIcon,
                color: const Color(0xFFF3E5F5),
                iconColor: const Color(0xFF8E24AA),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DashboardCard(
                title: 'In Progress',
                count: d.ongoingTasks.toString(),
                subtitle: d.isCoordinator ? 'Tasks' : 'Projects',
                icon: IconConst().progressIcon,
                color: const Color(0xFFE0F7FA),
                iconColor: const Color(0xFF00838F),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DashboardCard(
                title: 'Overdue',
                count: d.overDueTasks.toString(),
                subtitle: 'Tasks',
                icon: IconConst().dueIcon,
                color: const Color(0xFFFFF3E0),
                iconColor: const Color(0xFFF57C00),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        if (isChairman) ...[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UsersListScreen(),
                ),
              );
            },
            child: const DashboardButton(
              label: 'View Users',
              icon: Icons.people_alt_outlined,
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (!d.isCoordinator) ...[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateProjectScreen(),
                ),
              );
            },
            child: const DashboardButton(
              label: 'Create New Project',
              icon: Icons.add_task_outlined,
            ),
          ),
          const SizedBox(height: 20),
        ],
        const ProjectList(),
        const SizedBox(height: 40),
      ],
    );
  }
}
