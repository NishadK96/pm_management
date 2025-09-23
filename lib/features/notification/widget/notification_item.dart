import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/constants/icon_constants.dart';

class NotificationItem extends StatelessWidget {
  final String title;
  final String timeAgo;
  final String description;

  NotificationItem({
    required this.title,
    required this.timeAgo,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.string(IconConst().notificationBell),
            SizedBox(width: 10),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Task created successfully!',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      '1hr ago',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFB7B7B7),
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: w / 1.5,
                  child: Text(
                    'Amet minim mollit not ulla lorem ipsummet minim mollit not ulla lorem ipsum dolar.',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF8A8A8A),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                // TextField(
                //   maxLength: 3,
                //   readOnly: true,
                //   decoration:  InputDecoration(
                //       border: InputBorder.none,
                //       hintText: "Amet minim mollit non deserunt ullam co est sit aliqua dolor do amet sint. Velit ficia consequat duis enimmollit. ",
                //       hintStyle: GoogleFonts.poppins(fontSize: 14)
                //   ),
                // )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
