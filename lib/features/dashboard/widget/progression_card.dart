import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/constants/icon_constants.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';

class ProgressionCard extends StatelessWidget {
  const ProgressionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: ShapeDecoration(
        image: DecorationImage(
          image: AssetImage("assets/bgImg.png"),
          fit: BoxFit.fill,
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFFE3E3E3)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Web Design Project',
            style: GoogleFonts.roboto(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing',
            style: GoogleFonts.poppins(color: AppColors.textGrey, fontSize: 10),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '05%',
                style: GoogleFonts.poppins(
                  color: Color(0XFF2D2D2D),
                  fontSize: 10,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          LinearProgressIndicator(
            value: 0.05,
            color: Colors.green,
            backgroundColor: Colors.white38,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100,
                child: Stack(
                  children: [
                    Container(
                      width: 29,
                      height: 29,
                      decoration: ShapeDecoration(
                        color: AppColors.primary,

                        shape: OvalBorder(),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      child: Container(
                        width: 29,
                        height: 29,
                        decoration: ShapeDecoration(
                          color: AppColors.secondary,
                          // image: DecorationImage(
                          //   image: NetworkImage("https://placehold.co/29x29"),
                          //   fit: BoxFit.cover,
                          // ),
                          shape: OvalBorder(),
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

                          // image: DecorationImage(
                          //   image: NetworkImage("https://placehold.co/29x29"),
                          //   fit: BoxFit.cover,
                          // ),
                          shape: OvalBorder(),
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
                  SizedBox(width: 10),
                  Text(
                    '24 August 2025',
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
