// lib/features/task_detail/task_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipsum_user/core/constants/icon_constants.dart';
import 'package:ipsum_user/core/local/app_prefs.dart';
import 'package:ipsum_user/core/widgets/long_button.dart';
import 'package:ipsum_user/core/widgets/title_widget.dart';
import 'package:ipsum_user/features/create_project/widgets/date_time_row.dart';
import 'package:ipsum_user/features/project/data/repositories/projects_repository.dart';
import 'package:ipsum_user/features/task_detail/create_new_task_button.dart';
import 'package:ipsum_user/features/task_detail/single_task_detail_screen.dart';
import 'package:ipsum_user/features/task_detail/task_detail_card.dart'
    show TaskDetailCard;
import 'package:ipsum_user/features/project/model/project_model.dart';
import 'package:ipsum_user/features/task_detail/bloc/task_bloc.dart';
import 'package:ipsum_user/features/task_detail/model/task_model.dart';
import 'package:ipsum_user/features/users/data/repositories/users_repository.dart';
import 'package:ipsum_user/injection_container.dart';

class TaskDetailScreen extends StatefulWidget {
  final ProjectModel? data;
  const TaskDetailScreen({super.key, this.data});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  bool dateTimeEnabled = true;
  bool notifyEnabled = true;

  final TextEditingController noteController = TextEditingController();

  DateTime startDate = DateTime(2025, 8, 1, 0, 20);
  DateTime dueDate = DateTime(2025, 8, 24, 0, 20);

  List<TaskModel>? taskList;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Optionally you can parse project start/due dates here if needed
    // For now we keep the defaults you had.

    final projectId = widget.data?.id;
    if (projectId != null) {
      context.read<TaskBloc>().add(FetchTasksForProject(projectId: projectId));
    }
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appPrefs = sl<AppPrefs>();
    final role = appPrefs.role;
    final isCoordinator = role?.toLowerCase() == 'coordinator' ||
        role?.toLowerCase() == 'co-ordinator';
final projectsRepository = sl<ProjectsRepository>();
final usersRepository = sl<UsersRepository>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TitleWidget(label: widget.data?.name ?? 'Project Detail'),
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskLoading) {
            setState(() => isLoading = true);
          } else {
            setState(() => isLoading = false);
          }

          if (state is TaskError) {
            // You can replace this with Fluttertoast if you like
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
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Project description
                  TaskDetailCard(
                    title: 'Title',
                    child: Container(
                      padding: const EdgeInsets.only(right: 16),
                      child: TextFormField(
                        maxLines: 3,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: widget.data?.description ?? '',
                          hintStyle: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

// 🔹 Project members
                  if (widget.data?.members.isNotEmpty ?? false) ...[
                    TaskDetailCard(
                      title: 'Project Members',
                      child: SizedBox(
                        height: 60,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.data!.members.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (ctx, index) {
                            final member = widget.data!.members[index];
                            final user = member.user;
                            final name =
                                (user.fullName ?? user.username).trim();
                            final initials = name
                                .split(' ')
                                .where((p) => p.isNotEmpty)
                                .map((p) => p[0])
                                .take(2)
                                .join()
                                .toUpperCase();

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.blueGrey.shade200,
                                  child: Text(
                                    initials,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  width: 70,
                                  child: Text(
                                    name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: const Color(0xFF151522),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Dates section (still using your dummy dates for now)
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
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  dateTimeEnabled = !dateTimeEnabled;
                                });
                              },
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) =>
                                    ScaleTransition(
                                        scale: animation, child: child),
                                child: dateTimeEnabled
                                    ? SvgPicture.string(
                                        IconConst().switchOn,
                                        key: const ValueKey("on"),
                                      )
                                    : SvgPicture.string(
                                        IconConst().switchOff,
                                        color: Colors.grey,
                                        key: const ValueKey("off"),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        if (dateTimeEnabled) ...[
                          const Divider(),
                          DateTimeRow(label: 'Start Date', dateTime: startDate),
                          DateTimeRow(label: 'Due Date', dateTime: dueDate),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Create new task button (your existing one)
                  isCoordinator
                      ? Container()
                      : CreateNewTaskButton(
                          projectId: widget.data!.id,
                          projectsRepository: projectsRepository,
                          usersRepository: usersRepository,
                          projectMembers: widget.data?.members ?? [], // 👈 NEW
                          onTaskCreated: () {
                            final id = widget.data?.id;
                            if (id != null && id.isNotEmpty) {
                              context
                                  .read<TaskBloc>()
                                  .add(FetchTasksForProject(projectId: id));
                            }
                          },
                        ),
                  const SizedBox(height: 12),

                  // 🔹 List of tasks under this project
                  if (isLoading && (taskList == null || taskList!.isEmpty))
                    const Center(child: CircularProgressIndicator())
                  else if (taskList != null && taskList!.isNotEmpty)
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: taskList!.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final task = taskList![index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    SingleTaskDetailScreen(task: task),
                              ),
                            );
                          },
                          child: TaskDetailCard(
                            title: task.name,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.description,
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Start Date :',
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF151522),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          task.startDate,
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF2E60C1),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Due Date  :',
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF151522),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          task.endDate,
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF2E60C1),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Row(
                                        children: [
                                          // show up to 2 small avatars for assigned users
                                          ...task.assignedToData
                                              .take(2)
                                              .map((u) {
                                            final initials =
                                                (u.fullName ?? u.username)
                                                    .trim()
                                                    .split(' ')
                                                    .where((p) => p.isNotEmpty)
                                                    .map((p) => p[0])
                                                    .take(2)
                                                    .join()
                                                    .toUpperCase();

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: CircleAvatar(
                                                radius: 12,
                                                backgroundColor:
                                                    Colors.blueGrey.shade200,
                                                child: Text(
                                                  initials,
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                          if (task.assignedToData.length > 2)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text(
                                                '+${task.assignedToData.length - 2}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 10,
                                                  color:
                                                      const Color(0xFF151522),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text('No tasks found for this project'),
                    ),

                  const SizedBox(height: 12),

                  // Notify me section
                  TaskDetailCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.string(IconConst().notifyIcon),
                            const SizedBox(width: 10),
                            Text(
                              'Notify me on due date',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF151522),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                notifyEnabled = !notifyEnabled;
                              });
                            },
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) =>
                                  ScaleTransition(
                                scale: animation,
                                child: child,
                              ),
                              child: notifyEnabled
                                  ? SvgPicture.string(
                                      IconConst().switchOn,
                                      key: const ValueKey("on"),
                                    )
                                  : SvgPicture.string(
                                      IconConst().switchOff,
                                      color: Colors.grey,
                                      key: const ValueKey("off"),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  LongButton(
                    label: "Complete",
                    onTap: () async {
                      _showSuccessBottomSheet();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSuccessBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Image.asset("assets/completeIcon.png"),
              ),
              Text(
                'Task Competed Successfully ',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF151522),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'The task has been completed successfully. All required steps were executed, and the outcome matches the expected results.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF6E6E6E),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              LongButton(
                label: "Finish",
                onTap: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
