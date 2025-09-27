import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';

class TaskDetailCard extends StatelessWidget {
  final String? title;
  final Widget child;

  const TaskDetailCard({super.key, this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 12,bottom: 12,top: 12),
      decoration: ShapeDecoration(
        color: const Color(0xFFF8F7F5),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: const Color(0x4CA9A8A8),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title!,
                style:  GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 14)),
            const SizedBox(height: 8),
            Container(width:double.infinity ,height: 2,color: AppColors.dividerGrey),
            const SizedBox(height: 8),
          ],
          child,
        ],
      ),
    );
  }
}
