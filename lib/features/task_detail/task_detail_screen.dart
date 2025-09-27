import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/constants/icon_constants.dart';
import 'package:ipsum_user/core/widgets/long_button.dart';
import 'package:ipsum_user/core/widgets/title_widget.dart';
import 'package:ipsum_user/features/create_project/assign_screen.dart';
import 'package:ipsum_user/features/create_project/widgets/date_time_row.dart';
import 'package:ipsum_user/features/create_project/widgets/priority_card.dart';
import 'package:ipsum_user/features/dashboard/widget/dashboard_button.dart';
import 'package:ipsum_user/features/task_detail/create_new_task_button.dart';
import 'package:ipsum_user/features/task_detail/task_detail_card.dart'
    show TaskDetailCard;

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  bool dateTimeEnabled = true;
  bool notifyEnabled = true;

  final TextEditingController projectTitleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  String selectedPriority = "Medium";
  DateTime startDate = DateTime(2025, 8, 1, 0, 20);
  DateTime dueDate = DateTime(2025, 8, 24, 0, 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TitleWidget(label: 'Web Dev'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TaskDetailCard(
                title: 'Title',
                child: Container(
                  padding: EdgeInsets.only(right: 16),
                  child: TextFormField(
                    maxLines: 3,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:
                          "Amet minim mollit non deserunt ullam co est sit aliqua dolor do amet sint. Velit ficia consequat duis enimmollit. ",
                      hintStyle: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AssignProjectScreen(),
                    ),
                  );
                },
                child: TaskDetailCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.string(IconConst().assignIcon),
                          const SizedBox(width: 10),
                          Text(
                            'Assign To',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              height: 1.22,
                            ),
                          ),
                        ],
                      ),

                      Container(
                        padding: EdgeInsets.only(right: 10),
                        child: Row(
                          children: const [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.red,
                            ),
                            // SizedBox(width: 4),
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
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
                                ScaleTransition(scale: animation, child: child),
                            child: dateTimeEnabled
                                ? SvgPicture.string(
                                    IconConst().switchOn, // ✅ ON state icon
                                    key: const ValueKey("on"),
                                  )
                                : SvgPicture.string(
                                    IconConst().switchOff,
                                    color: Colors.grey, // ⬜ OFF state icon
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
              TaskDetailCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.string(IconConst().priorityIcon),
                        const SizedBox(width: 10),
                        Text(
                          'Priority',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            height: 1.22,
                          ),
                        ),
                      ],
                    ),

                    GestureDetector(
                      onTap: _showPriorityBottomSheet,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          selectedPriority,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              TaskDetailCard(
                title: 'Note',
                child: TextFormField(
                  controller: noteController,
                  maxLines: 3,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        "Amet minim mollit non deserunt ullam co est sit aliqua dolor do amet sint. Velit ficia consequat duis enimmollit. ",
                  ),
                ),
              ),
              const SizedBox(height: 12),
              CreateNewTaskButton(),
              const SizedBox(height: 12),
              TaskDetailCard(
                title: 'Task Title',
                child: Column(
                  children: [
                    TextFormField(
                      controller: noteController,
                      maxLines: 3,
                      readOnly: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            "Amet minim mollit non deserunt ullam co est sit aliqua dolor do amet sint. Velit ficia consequat duis enimmollit. ",
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            SizedBox(width: 5),
                            Text(
                              '12 Jun 2022',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF2E60C1),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                height: 2.20,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Due Date  :',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF151522),
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              '12 Jun 2022',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF2E60C1),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                height: 2.20,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 5),
                          child: Row(
                            children: const [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.red,
                              ),
                              // SizedBox(width: 4),
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
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
                            color: Color(0xFF151522),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            notifyEnabled = !notifyEnabled;
                          });
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(scale: animation, child: child),
                          child: notifyEnabled
                              ? SvgPicture.string(
                                  IconConst().switchOn, // ✅ ON state icon
                                  key: const ValueKey("on"),
                                )
                              : SvgPicture.string(
                                  IconConst().switchOff,
                                  color: Colors.grey, // ⬜ OFF state icon
                                  key: const ValueKey("off"),
                                ),
                        ),
                      ),
                    ),
                    // SizedBox(width: 10,)
                  ],
                ),
              ),
              SizedBox(height: 20),
              LongButton(label: "Complete", onTap:_showSuccessBottomSheet )

            ],
          ),
        ),
      ),
    );
  }

  void _showPriorityBottomSheet() {
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
              Text(
                'Priority',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              PriorityCard(
                label: 'High Priority',
                color: Color(0xffFF0000),
                onTap: () {
                  setState(() => selectedPriority = "High");
                  Navigator.pop(context);
                },
              ),
              PriorityCard(
                label: 'Medium Priority',
                color: Color(0xffF18F1C),
                onTap: () {
                  setState(() => selectedPriority = "Medium");
                  Navigator.pop(context);
                },
              ),
              PriorityCard(
                label: 'Low Priority',
                color: Color(0xff50D166),
                onTap: () {
                  setState(() => selectedPriority = "Low");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
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
                padding: EdgeInsets.symmetric(horizontal: 60),
                  child: Image.asset("assets/completeIcon.png")),
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
              SizedBox(height: 20,),
              LongButton(label: "Finish", onTap: (){})
            ],
          ),
        );
      },
    );
  }
}
