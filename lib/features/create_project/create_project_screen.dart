// lib/features/create_project/create_project_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/constants/icon_constants.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';
import 'package:ipsum_user/core/widgets/long_button.dart';
import 'package:ipsum_user/features/create_project/assign_screen.dart';
import 'package:ipsum_user/features/create_project/calender_screen.dart';
import 'package:ipsum_user/features/create_project/widgets/custom_card.dart';
import 'package:ipsum_user/features/create_project/widgets/date_time_row.dart';
import 'package:ipsum_user/features/create_project/widgets/priority_card.dart';
import 'package:ipsum_user/features/project/bloc/create_project_bloc.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  bool dateTimeEnabled = true;
  bool notifyEnabled = true;

  final TextEditingController projectTitleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  String selectedPriority = "Medium";
  DateTime startDate = DateTime(2025, 8, 1, 0, 20);
  DateTime dueDate = DateTime(2025, 8, 24, 0, 20);

  @override
  void dispose() {
    projectTitleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(msg: msg);
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart ? startDate : dueDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            startDate.hour,
            startDate.minute,
          );
        } else {
          dueDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            dueDate.hour,
            dueDate.minute,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: AppColors.dividerGrey,
        title: Text(
          'Create Project',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w400),
        ),
        leading: const BackButton(),
        actions: [SvgPicture.string(IconConst().moreIcon)],
      ),
      body: BlocConsumer<CreateProjectBloc, CreateProjectState>(
        listener: (context, state) {
          if (state is CreateProjectFailure) {
            _showToast(state.message);
          }

          if (state is CreateProjectSuccess) {
            _showToast('Project created successfully');
            // You can navigate wherever you want after success
            // For now just pop:
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final bool isLoading = state is CreateProjectLoading;

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomCard(
                          title: 'Project Title',
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: TextFormField(
                              controller: projectTitleController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter your project title here...",
                                hintStyle: GoogleFonts.poppins(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        CustomCard(
                          title: 'Description',
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: TextFormField(
                              controller: noteController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter description / notes...",
                                hintStyle: GoogleFonts.poppins(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        CustomCard(
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
                                      duration:
                                          const Duration(milliseconds: 300),
                                      transitionBuilder: (child, animation) =>
                                          ScaleTransition(
                                        scale: animation,
                                        child: child,
                                      ),
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
                                GestureDetector(
                                  onTap: () => _pickDate(isStart: true),
                                  child: DateTimeRow(
                                    label: 'Start Date',
                                    dateTime: startDate,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _pickDate(isStart: false),
                                  child: DateTimeRow(
                                    label: 'Due Date',
                                    dateTime: dueDate,
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        CustomCard(
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: LongButton(
                            label: 'Save',
                            isLoading: isLoading,
                            enabled: !isLoading,
                            onTap: () async {
                              final title = projectTitleController.text.trim();
                              final desc = noteController.text.trim();

                              if (title.isEmpty) {
                                _showToast('Please enter project title');
                                return;
                              }

                              context.read<CreateProjectBloc>().add(
                                    SubmitCreateProject(
                                      name: title,
                                      description: desc,
                                      startDate: startDate,
                                      dueDate: dueDate,
                                      notifyDue: notifyEnabled,
                                    ),
                                  );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
