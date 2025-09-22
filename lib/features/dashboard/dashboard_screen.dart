import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/constants/icon_constants.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';
import 'package:ipsum_user/features/create_project/create_project_screen.dart';
import 'package:ipsum_user/features/dashboard/widget/dashboard_button.dart';
import 'package:ipsum_user/features/dashboard/widget/progression_card.dart';
import 'package:ipsum_user/features/dashboard/widget/project_list.dart';
import 'package:ipsum_user/features/notification/notification_screen.dart';
import 'package:ipsum_user/features/profile/profile_screen.dart';

import 'widget/dashboard_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
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
                    // borderRadius: BorderRadius.only(
                    //   bottomLeft: Radius.circular(20),
                    //   bottomRight: Radius.circular(20),
                    // ),
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
                            // ());
                            //
                          },
                          child: const CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(
                              "https://img.freepik.com/premium-photo/happy-man-ai-generated-portrait-user-profile_1119669-1.jpg?w=2000",
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ashwin",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "Chairman (ID : 154565)",
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
              ],
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Project progress section
                  ProgressionCard(),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DashboardCard(
                        title: "All Project",
                        count: "0",
                        subtitle: "Task",
                        icon: IconConst().projectIcon,
                        color: Color(0xFFE3F2FD),
                        iconColor: Color(0xFF1565C0),
                      ),
                      DashboardCard(
                        title: "Approvals",
                        count: "0",
                        subtitle: "Request",
                        icon: IconConst().approvalIcon,
                        color: Color(0xFFF3E5F5),
                        iconColor: Color(0xFF8E24AA),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DashboardCard(
                        title: "In progress",
                        count: "0",
                        subtitle: "Projects",
                        icon: IconConst().progressIcon,
                        color: Color(0xFFE0F7FA),
                        iconColor: Color(0xFF00838F),
                      ),
                      DashboardCard(
                        title: "Over Due",
                        count: "0",
                        subtitle: "Task",
                        icon: IconConst().dueIcon,
                        color: Color(0xFFFFF3E0),
                        iconColor: Color(0xFFF57C00),
                      ),
                    ],
                  ),

                  // Dashboard cards (responsive grid)
                  const SizedBox(height: 20),

                  // Create new project button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateProjectScreen(),
                        ),
                      );
                    },
                    child: DashboardButton(label: "Create new Project"),
                  ),

                  const SizedBox(height: 10),
                  // Create new project button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateProjectScreen(),
                        ),
                      );
                    },
                    child: DashboardButton(label: "Create new Task"),
                  ),

                  SizedBox(height: 20),

                  // Project list title
                  ProjectList(),
                  SizedBox(height: 50,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
