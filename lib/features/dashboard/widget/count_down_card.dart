import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/constants/icon_constants.dart';
import 'dart:async';

import 'package:ipsum_user/core/theme/app_colors.dart';
class CountDownCard extends StatefulWidget {
  const CountDownCard({super.key});

  @override
  State<CountDownCard> createState() => _CountDownCardState();
}

class _CountDownCardState extends State<CountDownCard> {


  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      width: w,
      padding: EdgeInsets.all(5),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: const Color(0xFFE9E9E9),
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
child: Column(
  mainAxisAlignment: MainAxisAlignment.start,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Container(width: w,
      alignment: Alignment.center,
      child: Text(
        'Your Task End in!',
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          // transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(-3.14),
          width: 90,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                strokeAlign: BorderSide.strokeAlignCenter,
                color: const Color(0xFFCFCFCF),
              ),
            ),
          ),
        ),
        Text(
          '06 Aug 08 AM',
          style: GoogleFonts.poppins(
            color: const Color(0xFF818181),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          // transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(-3.14),
          width: 90,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                strokeAlign: BorderSide.strokeAlignCenter,
                color: const Color(0xFFCFCFCF),
              ),
            ),
          ),
        ),
      ],
    ),

    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'The Logo Process is a dummy task list\nfor design purpose 1',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w500,

          ),
        ),
        Container(
          width: 68,
          height: 26,
          decoration: ShapeDecoration(
            color: const Color(0xFF050505),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ),
          alignment: Alignment.center,
          child:  Text(
            'High',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

      ],
    ),
    SizedBox(height: 10,),
    LinearProgressIndicator(
      value: 0.05,
      color: AppColors.primary,
      backgroundColor: Colors.white38,
    ),

    SizedBox(height: 10,),
    Row(
      children: [
       SvgPicture.string(IconConst().calenderIcon,),
        SizedBox(width: 5,),
        Text(
          '12 Jun 2022',
          style: GoogleFonts.poppins(
            color: const Color(0xFF2E60C1),
            fontSize: 10,
            fontWeight: FontWeight.w500,
            height: 2.20,
          ),
        ),
        SizedBox(width: 12),
        SvgPicture.string(IconConst().flagIcon,),
        SizedBox(width: 5,),
        Text(
          '12 Jun 2022',
          style: GoogleFonts.poppins(
            color: const Color(0xFF2E60C1),
            fontSize: 10,
            fontWeight: FontWeight.w500,
            height: 2.20,
          ),
        ),

      ],
    ),
  ],
),
    );
  }
}
