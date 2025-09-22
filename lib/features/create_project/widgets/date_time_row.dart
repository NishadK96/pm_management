import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';
import 'package:ipsum_user/core/utils/helpers.dart' ;


class DateTimeRow extends StatelessWidget {
  final String label;
  final DateTime dateTime;

  const DateTimeRow({super.key, required this.label, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [

            Text('$label :',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF151522),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  // height: 1.22,
                ),),

          SizedBox(width: 20,),
          Text(
            formatDate(dateTime),
            style:  TextStyle(color: AppColors.primary),
          ),
          SizedBox(width: 10,),
          Text(
            formatTime(dateTime),
            style:  TextStyle(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
