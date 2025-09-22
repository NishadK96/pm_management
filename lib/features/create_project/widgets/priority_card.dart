import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/constants/icon_constants.dart';

class PriorityCard extends StatelessWidget {
final  VoidCallback? onTap;
final String? label;
final Color? color;
   const PriorityCard({super.key,this.onTap,this.label,this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
          padding: EdgeInsets.all(6),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: const Color(0xFFE6ECF0),
              ),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: SvgPicture.string(IconConst().highPriorityIcon,color: color,)),
      title: Text(
        label??'Medium Priority',
        style: GoogleFonts.roboto(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,

        ),
      ),
      onTap: onTap,
    );
  }
}
