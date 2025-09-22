import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleWidget extends StatelessWidget {
  final String? label;
  const TitleWidget({super.key,required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label??"",style: GoogleFonts.poppins(
        fontSize: 24,fontWeight: FontWeight.w400
    ) ,

    );
  }
}
