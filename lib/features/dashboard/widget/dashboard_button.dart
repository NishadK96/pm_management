import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:ipsum_user/core/constants/icon_constants.dart';
import 'package:ipsum_user/core/theme/app_colors.dart' show AppColors;

class DashboardButton extends StatelessWidget {
  final String? label;
   const DashboardButton({super.key,required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8) ),
            color: AppColors.primary
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label??"Create New Project",
              style: GoogleFonts.roboto (fontSize: 16,color: Colors.white  ),
            ),
           SvgPicture.string(IconConst().arrowIcon,width: 24,height: 18,),
          ],
        )


    );
  }
}
