import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/constants/icon_constants.dart';
import 'package:ipsum_user/core/widgets/title_widget.dart';
import 'package:ipsum_user/features/project/bloc/project_bloc.dart';
import 'package:ipsum_user/features/project/project_card.dart';
import 'package:ipsum_user/features/task_detail/task_detail_screen.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  @override
  void initState() {
    // productList.clear();
    context.read<ProjectBloc>().add(GetProjects());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: TitleWidget(label: 'Project')),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total 3 Project',
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
                    side: BorderSide(
                      width: 1,
                      color: const Color(0xFFE6ECF0),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x05000000),
                      blurRadius: 8,
                      offset: Offset(1, 1),
                      spreadRadius: 0,
                    )
                  ],
                ),
                padding: EdgeInsets.all(5),
                child: SvgPicture.string(IconConst().filterIcon),
              ),
            ],
          ),
              SizedBox(height: 15,),
              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const TaskDetailScreen(),
                    ),
                  );
                },
                  child: ProjectCard())
            ],
          ),

        ),
      ),
    );
  }
}
