import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/constants/icon_constants.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';
import 'package:ipsum_user/core/widgets/long_button.dart';
import 'package:ipsum_user/features/create_project/assign_screen.dart';
import 'package:ipsum_user/features/create_project/calender_screen.dart';
import 'package:ipsum_user/features/create_project/widgets/custom_card.dart';
import 'package:ipsum_user/features/create_project/widgets/date_time_row.dart';
import 'package:ipsum_user/features/create_project/widgets/priority_card.dart';


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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: AppColors.dividerGrey,
        title:  Text('Create Project',style: GoogleFonts.poppins(fontSize: 24,fontWeight: FontWeight.w400),),
        leading: const BackButton(),
        actionsPadding: EdgeInsets.only(right: 20),
        actions: [
        SvgPicture.string(IconConst().moreIcon)
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomCard(
                      title: 'Project Title',
                      child: Container(
                        padding: EdgeInsets.only(right: 16),
                        child: TextFormField(
                          controller: projectTitleController,
                          maxLines: 3,
                          readOnly: true,
                          decoration:  InputDecoration(
                            border: InputBorder.none,
                            hintText: "Amet minim mollit non deserunt ullam co est sit aliqua dolor do amet sint. Velit ficia consequat duis enimmollit. ",
                            hintStyle: GoogleFonts.poppins(fontSize: 14)
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                             AssignProjectScreen(),
                          ),
                        );
                      },
                      child: CustomCard(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.string(IconConst().assignIcon,),
                                const SizedBox(width: 10),
                                 Text('Assign To',style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  height: 1.22,
                                ),),
                              ],
                            ),


                            Container(
                              padding: EdgeInsets.only(right: 10),
                              child: Row(
                                children: const [
                                  CircleAvatar(radius: 12, backgroundColor: Colors.red),
                                  // SizedBox(width: 4),
                                  CircleAvatar(radius: 12, backgroundColor: Colors.blue),
                                ],
                              ),
                            )
                          ],
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
                               Text('Date and Time', style: GoogleFonts.poppins(
                                color: const Color(0xFF151522),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,

                              ),),
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
                      IconConst().switchOn,   // ✅ ON state icon
                      key: const ValueKey("on"),

                    )
                        : SvgPicture.string(
                      IconConst().switchOff,
                      color: Colors.grey,// ⬜ OFF state icon
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
                              SvgPicture.string(IconConst().priorityIcon,),
                              const SizedBox(width: 10),
                              Text('Priority', style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                height: 1.22,
                              ),),
                            ],
                          ),


                          GestureDetector(
                            onTap: _showPriorityBottomSheet,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child:  Text(
                                selectedPriority,
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomCard(
                      title: 'Note',
                      child: TextFormField(
                        controller: noteController,
                        maxLines: 3,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Amet minim mollit non deserunt ullam co est sit aliqua dolor do amet sint. Velit ficia consequat duis enimmollit. ",
                        ),
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
                              Text('Notify me on due date', style: GoogleFonts.poppins(
                                color:  Color(0xFF151522),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,

                              ),),
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
                                  IconConst().switchOn,   // ✅ ON state icon
                                  key: const ValueKey("on"),

                                )
                                    : SvgPicture.string(
                                  IconConst().switchOff,
                                  color: Colors.grey,// ⬜ OFF state icon
                                  key: const ValueKey("off"),

                                ),
                              ),
                            ),
                          ),
                        // SizedBox(width: 10,)
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child:LongButton(label: 'Save', onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>   CalenderScreen(),
                          ),
                        );
                      })



                    )
                  ],
                ),
              ),
            ),
          );
        },
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
                label:'High Priority' ,
                color: Color(0xffFF0000),
                onTap: () {
                  setState(() => selectedPriority = "High");
                  Navigator.pop(context);
                },
              ),
              PriorityCard(
                label:'Medium Priority' ,
                color: Color(0xffF18F1C),
                onTap: () {
                  setState(() => selectedPriority = "Medium");
                  Navigator.pop(context);
                },
              ),
              PriorityCard(
                label:'Low Priority' ,
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
}
