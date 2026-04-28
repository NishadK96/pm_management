import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/constants/icon_constants.dart';
import 'package:ipsum_user/core/widgets/title_widget.dart';
import 'package:ipsum_user/features/project/bloc/project_bloc.dart';
import 'package:ipsum_user/features/project/project_card.dart';
import 'package:ipsum_user/features/task_detail/bloc/task_bloc.dart';
import 'package:ipsum_user/features/task_detail/task_detail_screen.dart';
import 'package:ipsum_user/main.dart';

import 'model/project_model.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  List<ProjectModel>? productList;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // 🔹 Trigger fetch when screen opens
    context.read<ProjectBloc>().add(const FetchProjects());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const TitleWidget(label: 'Project'),
      ),
      body: BlocConsumer<ProjectBloc, ProjectState>(
        listener: (context, state) {
          // 🔹 Loading flag
          if (state is ProjectLoading) {
            setState(() => isLoading = true);
          } else {
            setState(() => isLoading = false);
          }

          // 🔹 Error
          if (state is ProjectError) {
            Fluttertoast.showToast(msg: state.message);
          }

          // 🔹 Success – update local list
          if (state is ProjectLoaded) {
            setState(() {
              productList = state.projects;
            });
          }
        },
        builder: (context, state) {
          // Show full-screen loader if first load
          if (isLoading && (productList == null || productList!.isEmpty)) {
            return const Center(child: CircularProgressIndicator());
          }

          final count = productList?.length ?? 0;

          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total $count Project',
                        style: GoogleFonts.roboto(
                          color: const Color(0xFF151522),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          height: 1.22,
                        ),
                      ),
                      Container(
                        width: 37,
                        height: 37,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: Color(0xFFE6ECF0),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x05000000),
                              blurRadius: 8,
                              offset: Offset(1, 1),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        padding: const EdgeInsets.all(5),
                        child: SvgPicture.string(IconConst().filterIcon),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // List
                  ListView.separated(
                    padding: const EdgeInsets.only(bottom: 15),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: productList?.length ?? 0,
                    itemBuilder: (context, i) {
                      final item = productList![i];
                      // print(item.name);

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (_) =>
                                    TaskBloc(repository: projectsRepository),
                                child: TaskDetailScreen(data: productList?[i]),
                              ),
                            ),
                          );
                        },
                        child: ProjectCard(
                          data: item,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 5),
                  ),

                  // If list is empty but not loading, show a simple text
                  if (!isLoading &&
                      (productList == null || productList!.isEmpty))
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text('No projects found'),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
