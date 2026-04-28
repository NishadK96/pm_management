// lib/features/dashboard/widget/progression_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/constants/icon_constants.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';

class ProgressionCard extends StatelessWidget {
  final String title;
  final String description;
  final double progress; // 0.0 - 1.0
  final String dateText;

  const ProgressionCard({
    super.key,
    required this.title,
    required this.description,
    required this.progress,
    required this.dateText,
  });

  @override
  Widget build(BuildContext context) {
    final percentStr = '${(progress * 100).toStringAsFixed(0)}%';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        image: const DecorationImage(
          image: AssetImage("assets/bgImg.png"),
          fit: BoxFit.fill,
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE3E3E3)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.isEmpty ? 'No highlighted item' : title,
            style: GoogleFonts.roboto(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style:
                GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 10),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                percentStr,
                style: GoogleFonts.poppins(
                  color: const Color(0XFF2D2D2D),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            color: Colors.green,
            backgroundColor: Colors.white38,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 100,
                child: Stack(
                  children: [
                    Container(
                      width: 29,
                      height: 29,
                      decoration: ShapeDecoration(
                        color: AppColors.primary,
                        shape: const OvalBorder(),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      child: Container(
                        width: 29,
                        height: 29,
                        decoration: ShapeDecoration(
                          color: AppColors.secondary,
                          shape: const OvalBorder(),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      child: Container(
                        width: 29,
                        height: 29,
                        decoration: ShapeDecoration(
                          color: AppColors.tertiary,
                          shape: const OvalBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  SvgPicture.string(
                    IconConst().projectIcon,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    dateText,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}