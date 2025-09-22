import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';

class CustomCard extends StatelessWidget {
  final String? title;
  final Widget child;

  const CustomCard({super.key, this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 12,bottom: 12,top: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
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
