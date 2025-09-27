import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/widgets/divider_widget.dart';
import 'package:ipsum_user/features/dashboard/widget/dashboard_button.dart';
import 'package:ipsum_user/features/task_detail/task_detail_card.dart';

class CreateNewTaskButton extends StatefulWidget {
  const CreateNewTaskButton({super.key});

  @override
  State<CreateNewTaskButton> createState() => _CreateNewTaskButtonState();
}

class _CreateNewTaskButtonState extends State<CreateNewTaskButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showTaskBottomSheet,
        child: DashboardButton(label: "Create new Task"));
  }

  void _showTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {

        return Column(
          children: [
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
                  SizedBox(height: 16,),
                   TaskDetailCard( title: 'Title',
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
                     ), )
                ],
              ),
            ),
            DividerWidget(),
            Padding(padding:const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date of Task Creation',
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 10,),

              ],
            ),
            )
          ],
        );
      },
    );
  }
}
