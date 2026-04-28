// lib/features/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/constants/icon_constants.dart';
import 'package:ipsum_user/core/local/app_prefs.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';

import 'package:ipsum_user/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:ipsum_user/features/dashboard/widget/dashboard_button.dart';
import 'package:ipsum_user/features/dashboard/widget/progression_card.dart';
import 'package:ipsum_user/features/dashboard/widget/project_list.dart';
import 'package:ipsum_user/features/notification/notification_screen.dart';

import 'package:ipsum_user/features/profile/profile_screen.dart';


import 'package:ipsum_user/features/project/project_screen.dart';
import 'package:ipsum_user/features/create_project/create_project_screen.dart';
import 'package:ipsum_user/features/users/data/repositories/users_repository.dart';
import 'package:ipsum_user/features/users/model/user_profile_model.dart';
import 'package:ipsum_user/features/users/users_list_screen.dart';

import 'package:ipsum_user/injection_container.dart';

// 👇 add this import for the new screen


import 'widget/dashboard_card.dart';

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
      if (mounted) setState(() => _profileLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appPrefs = sl<AppPrefs>();
    final role = appPrefs.role;

    final isCoordinator = role?.toLowerCase() == 'coordinator' ||
        role?.toLowerCase() == 'co-ordinator';

    // 🔹 NEW: chairman check
    final isChairman = role?.toLowerCase() == 'chairman';

    // fire dashboard load once
    if (!_initialized) {
      _initialized = true;
      context
          .read<DashboardBloc>()
          .add(DashboardStarted(isCoordinator: isCoordinator));
    }

    final displayName =
        _profile?.fullName ?? _profile?.username ?? 'User';
    final empId = _profile?.empId ?? '---';
    final profilePic = _profile?.profilePicture;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔹 Header
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.tertiary,
                    AppColors.secondary,
                    AppColors.primary,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ProfileDetailsScreen(),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 28,
                        backgroundImage: profilePic != null
                            ? NetworkImage(profilePic)
                            : const NetworkImage(
                                "https://img.freepik.com/premium-photo/happy-man-ai-generated-portrait-user-profile_1119669-1.jpg?w=2000",
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _profileLoading
                          ? const LinearProgressIndicator(
                              minHeight: 2,
                              color: Colors.white70,
                              backgroundColor: Colors.transparent,
                            )
                          : Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "${role ?? ''} (ID : $empId)",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationsScreen(),
                          ),
                        );
                      },
                      child: SvgPicture.string(
                        IconConst().notificationIcon,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 Dashboard content
            Container(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  if (state is DashboardLoading ||
                      state is DashboardInitial) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  if (state is DashboardError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (state is DashboardLoaded) {
                    final d = state.data;

                    String highlightTitle = '';
                    String highlightDescription = '';
                    String highlightDate = '';
                    double progress = 0.0;

                    if (d.isCoordinator) {
                      highlightTitle =
                          d.highlightedTask?.name ?? 'Highlighted Task';
                      highlightDescription =
                          d.highlightedTask?.description ?? '';
                      highlightDate = d.highlightedTask?.endDate ?? '';
                      progress = 0.0;
                    } else {
                      highlightTitle = d.highlightedProject?.name ??
                          'Highlighted Project';
                      highlightDescription =
                          d.highlightedProject?.description ?? '';
                      highlightDate =
                          d.highlightedProject?.dueDate ?? '';
                      progress = d.projectCompletionPercentage;
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProgressionCard(
                          title: highlightTitle,
                          description: highlightDescription,
                          progress: progress,
                          dateText: highlightDate,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ProjectScreen(),
                                  ),
                                );
                              },
                              child: DashboardCard(
                                title: d.isCoordinator
                                    ? "My Tasks"
                                    : "All Project",
                                count: d.isCoordinator
                                    ? d.ongoingTasks.toString()
                                    : d.totalTasks.toString(),
                                subtitle: "Task",
                                icon: IconConst().projectIcon,
                                color: const Color(0xFFE3F2FD),
                                iconColor: const Color(0xFF1565C0),
                              ),
                            ),
                            DashboardCard(
                              title: "Approvals",
                              count: d.isCoordinator
                                  ? '0'
                                  : d.approvalsPending.toString(),
                              subtitle: "Request",
                              icon: IconConst().approvalIcon,
                              color: const Color(0xFFF3E5F5),
                              iconColor: const Color(0xFF8E24AA),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            DashboardCard(
                              title: "In progress",
                              count: d.ongoingTasks.toString(),
                              subtitle: d.isCoordinator
                                  ? "Tasks"
                                  : "Projects",
                              icon: IconConst().progressIcon,
                              color: const Color(0xFFE0F7FA),
                              iconColor: const Color(0xFF00838F),
                            ),
                            DashboardCard(
                              title: "Over Due",
                              count: d.overDueTasks.toString(),
                              subtitle: "Task",
                              icon: IconConst().dueIcon,
                              color: const Color(0xFFFFF3E0),
                              iconColor: const Color(0xFFF57C00),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // 🔹 Chairman-only "User List" button
                        if (isChairman) ...[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const UsersListScreen(),
                                ),
                              );
                            },
                            child: const DashboardButton(
                              label: "View Users",
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        if (!d.isCoordinator) ...[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const CreateProjectScreen(),
                                ),
                              );
                            },
                            child: const DashboardButton(
                                label: "Create new Project"),
                          ),
                          const SizedBox(height: 20),
                        ],
                        const ProjectList(),
                        const SizedBox(height: 50),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}