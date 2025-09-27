import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';

class LongButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const LongButton({super.key,required this.label,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Container(
        // margin: EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        height: 60,
        decoration: ShapeDecoration(
          color: AppColors.primary,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: const Color(0xFFE6ECF0),
            ),
            borderRadius: BorderRadius.circular(8),
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
        alignment: Alignment.center,
        child: Text(
          label??'Assign Project',
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            height: 1.22,
          ),
        ),
      ),
    );
  }
}
