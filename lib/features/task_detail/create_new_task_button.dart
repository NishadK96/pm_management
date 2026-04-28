// lib/features/task_detail/create_new_task_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/constants/icon_constants.dart';
import 'package:ipsum_user/core/widgets/divider_widget.dart';
import 'package:ipsum_user/features/dashboard/widget/dashboard_button.dart';
import 'package:ipsum_user/features/project/model/project_model.dart';
import 'package:ipsum_user/features/task_detail/task_detail_card.dart';
import 'package:ipsum_user/features/project/data/repositories/projects_repository.dart';
import 'package:ipsum_user/features/users/data/repositories/users_repository.dart';
import 'package:ipsum_user/features/users/model/user_model.dart';

// lib/features/task_detail/create_new_task_button.dart
class CreateNewTaskButton extends StatefulWidget {
  final String projectId;
  final ProjectsRepository projectsRepository;
  final UsersRepository usersRepository;
  final VoidCallback? onTaskCreated;
  final List<ProjectMember> projectMembers; // 👈 NEW

  const CreateNewTaskButton({
    super.key,
    required this.projectId,
    required this.projectsRepository,
    required this.usersRepository,
    this.onTaskCreated,
    required this.projectMembers, // 👈 NEW
  });

  @override
  State<CreateNewTaskButton> createState() => _CreateNewTaskButtonState();
}
class _CreateNewTaskButtonState extends State<CreateNewTaskButton> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();

  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now().add(const Duration(days: 7));

  List<UserModel> _allUsers = [];
  List<String> _selectedUserIds = [];
  String _priority = 'medium_priority'; // default
  bool _isSubmitting = false;
  bool _hasMembers = false; // 👈 NEW

  @override
  void initState() {
    super.initState();
    _hasMembers = widget.projectMembers.isNotEmpty;
  }
  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return GestureDetector(
      onTap: () async {
        if (!_hasMembers) {
          await _showAddMembersSheet();  // 👈 first make sure project has members
        } else {
          _showTaskBottomSheet();        // 👈 then normal create-task flow
        }
      },
      child: const DashboardButton(label: "Create new Task"),
    );
  }
  Future<void> _showAddMembersSheet() async {
    // Load users if needed
    if (_allUsers.isEmpty) {
      try {
        _allUsers = await widget.usersRepository.getAllUsers();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load users: $e')),
        );
        return;
      }
    }

    final Set<String> selectedUserIds = {};

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add Project Members',
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_allUsers.isEmpty)
                    const Center(child: CircularProgressIndicator())
                  else
                    SizedBox(
                      height: 300,
                      child: ListView.separated(
                        itemCount: _allUsers.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final u = _allUsers[index];
                          final isSelected = selectedUserIds.contains(u.id);
                          return ListTile(
                            title: Text(
                              u.fullName ?? u.username,
                              style: GoogleFonts.roboto(fontSize: 14),
                            ),
                            subtitle: Text(
                              u.roleName??"",
                              style: GoogleFonts.roboto(fontSize: 12),
                            ),
                            trailing: Checkbox(
                              value: isSelected,
                              onChanged: (val) {
                                setSheetState(() {
                                  if (val == true) {
                                    selectedUserIds.add(u.id);
                                  } else {
                                    selectedUserIds.remove(u.id);
                                  }
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selectedUserIds.isEmpty
                          ? null
                          : () async {
                              // call add-member API for each selected user
                              try {
                                for (final userId in selectedUserIds) {
                                  await widget.projectsRepository
                                      .addMemberToProject(
                                    projectId: widget.projectId,
                                    userId: userId,
                                  );
                                }

                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Members added successfully'),
                                    ),
                                  );
                                }

                                setState(() {
                                  _hasMembers = true;
                                });

                                Navigator.pop(ctx);

                                // After adding members, go straight to create-task sheet
                                _showTaskBottomSheet();
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Failed to add members: $e')),
                                  );
                                }
                              }
                            },
                      child: const Text('Add Members'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  Future<void> _loadUsers() async {
    try {
      final users = await widget.usersRepository.getAllUsers();
      setState(() {
        _allUsers = users;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load users: $e')),
      );
    }
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final initial = isFrom ? _fromDate : _toDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
          if (_toDate.isBefore(_fromDate)) {
            _toDate = _fromDate;
          }
        } else {
          _toDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  Future<void> _createTask() async {
  final name = _titleCtrl.text.trim();
  final description = _descCtrl.text.trim();

  if (name.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter task title')),
    );
    return;
  }

  setState(() => _isSubmitting = true);
  try {
    await widget.projectsRepository.createTask(
      projectId: widget.projectId,
      name: name,
      description: description,
      assignedTo: _selectedUserIds,
      startDate: _formatDate(_fromDate),
      endDate: _formatDate(_toDate),
      priority: _priority,
      notifyDue: true,
    );

    if (mounted) {
      // ✅ Tell parent "a task was created"
      widget.onTaskCreated?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task created successfully')),
      );
      Navigator.of(context).pop(); // close bottom sheet
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create task: $e')),
      );
    }
  } finally {
    if (mounted) setState(() => _isSubmitting = false);
  }
}

  Future<void> _showAssignUserSheet() async {
    if (_allUsers.isEmpty) {
      await _loadUsers();
    }

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Assign To',
                    style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_allUsers.isEmpty)
                    const Center(child: CircularProgressIndicator())
                  else
                    SizedBox(
                      height: 300,
                      child: ListView.separated(
                        itemCount: _allUsers.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final u = _allUsers[index];
                          final selected =
                              _selectedUserIds.contains(u.id);
                          return ListTile(
                            title: Text(
                              u.fullName ?? u.username,
                              style: GoogleFonts.roboto(fontSize: 14),
                            ),
                            subtitle: Text(
                              u.roleName??"",
                              style: GoogleFonts.roboto(fontSize: 12),
                            ),
                            trailing: Checkbox(
                              value: selected,
                              onChanged: (val) {
                                setSheetState(() {
                                  if (val == true) {
                                    _selectedUserIds.add(u.id);
                                  } else {
                                    _selectedUserIds.remove(u.id);
                                  }
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Done'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    setState(() {}); // to refresh label in main sheet
  }

  Future<void> _showPrioritySheet() async {
    const priorities = [
      'low_priority',
      'medium_priority',
      'high_priority',
    ];

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Priority',
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              ...priorities.map((p) {
                final isSelected = p == _priority;
                return ListTile(
                  title: Text(
                    p,
                    style: GoogleFonts.roboto(fontSize: 14),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    setState(() => _priority = p);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _showTaskBottomSheet() {
  final size = MediaQuery.of(context).size;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // so we can style the container
    builder: (context) {
      final bottomInset = MediaQuery.of(context).viewInsets.bottom;

      return Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: FractionallySizedBox(
          heightFactor: 0.75, // 👈 75% of screen height
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // 🔹 Small grab handle
                const SizedBox(height: 8),
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 8),

                // 🔹 Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      children: [
                        // Header + Title + Description
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Create New Task',
                                style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TaskDetailCard(
                                title: 'Title',
                                child: Container(
                                  padding:
                                      const EdgeInsets.only(right: 16),
                                  child: TextFormField(
                                    controller: _titleCtrl,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText:
                                          "Enter your task title here...",
                                      hintStyle: GoogleFonts.poppins(
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TaskDetailCard(
                                title: 'Description',
                                child: Container(
                                  padding:
                                      const EdgeInsets.only(right: 16),
                                  child: TextFormField(
                                    controller: _descCtrl,
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText:
                                          "Enter description / notes...",
                                      hintStyle: GoogleFonts.poppins(
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const DividerWidget(),

                        // Date range
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date of Task',
                                style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: size.width / 2.4,
                                    child: GestureDetector(
                                      onTap: () =>
                                          _pickDate(isFrom: true),
                                      child: TaskDetailCard(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                              children: [
                                                Text(
                                                  'From',
                                                  style:
                                                      GoogleFonts.roboto(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  _formatDate(_fromDate),
                                                  style:
                                                      GoogleFonts.roboto(
                                                    color:
                                                        Colors.grey[700],
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                      right: 8.0),
                                              child: SvgPicture.string(
                                                IconConst().calenderIcon,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width / 2.4,
                                    child: GestureDetector(
                                      onTap: () =>
                                          _pickDate(isFrom: false),
                                      child: TaskDetailCard(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                              children: [
                                                Text(
                                                  'To',
                                                  style:
                                                      GoogleFonts.roboto(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  _formatDate(_toDate),
                                                  style:
                                                      GoogleFonts.roboto(
                                                    color:
                                                        Colors.grey[700],
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                      right: 8.0),
                                              child: SvgPicture.string(
                                                IconConst().calenderIcon,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const DividerWidget(),

                        // Assign + Priority + Button
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              TaskDetailCard(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    'Assign To',
                                    style: GoogleFonts.roboto(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    _selectedUserIds.isEmpty
                                        ? 'No user selected'
                                        : '${_selectedUserIds.length} user(s) selected',
                                    style: GoogleFonts.roboto(
                                        fontSize: 12),
                                  ),
                                  trailing:
                                      const Icon(Icons.chevron_right),
                                  onTap: _showAssignUserSheet,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TaskDetailCard(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    'Priority',
                                    style: GoogleFonts.roboto(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    _priority,
                                    style: GoogleFonts.roboto(
                                        fontSize: 12),
                                  ),
                                  trailing:
                                      const Icon(Icons.chevron_right),
                                  onTap: _showPrioritySheet,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isSubmitting
                                      ? null
                                      : _createTask,
                                  child: _isSubmitting
                                      ? const SizedBox(
                                          height: 18,
                                          width: 18,
                                          child:
                                              CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text('Create Task'),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )));
        
      },
    );
  
  }
}
