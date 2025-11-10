import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/constants/icon_constants.dart';
import 'package:ipsum_user/core/widgets/title_widget.dart';
import 'package:ipsum_user/features/project/bloc/project_bloc.dart';
import 'package:ipsum_user/features/project/project_card.dart';
import 'package:ipsum_user/features/task_detail/task_detail_screen.dart';

import 'model/project_model.dart';

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

  List<ProjectModel>? productList;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: TitleWidget(label: 'Project')),
      body: BlocBuilder<ProjectBloc, ProjectState>(builder: (context, state) {
        if (state is ProjectListSuccess) {
          // print("inside Screen ..................${state.productList[0].name}");
          productList = state.productList;
        }
        if (state is ProjectListFailed) {
          //
                  }
     return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total ${productList?.length.toString()} Project',
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
              ListView.separated(
                padding: const EdgeInsets.only(bottom: 15),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: productList?.length ?? 0,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, i) {
                 print( productList?[i].name);
                  return GestureDetector(
                      onTap: () {
                        // context.read<ProjectBloc>().add(GetProjectDetails(id: productList?[i].id));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                             TaskDetailScreen(data:productList?[i] ,),
                          ),
                        );
                      },
                      child: ProjectCard(
                       data:  productList?[i]

                      ));
                },
                separatorBuilder: (context, index) => SizedBox(height: 5,),
              )
            ],
          ),

        ),

      );
      }),

    );
  }
}
