import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key});

  @override
  Widget build(BuildContext context) {
    var w=MediaQuery.of(context).size.width;
    return Container(
      width: w,

      // height: 166,
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
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Web Dev',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,

                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),

                      decoration: ShapeDecoration(
                        color: const Color(0x19FF9900),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
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
                      child: Text(
                        'On Progress',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFFF9900),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,

                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Text(
                  'Amet minim mollit non deserunt ullamco it aliqua dolor do amet sint. ',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF1B1B1F),
                    fontSize: 17,
                    fontWeight: FontWeight.w400,

                  ),
                ),

              ],
            ),
          ),
          Container(
            width: w,
            decoration: ShapeDecoration(
              color: const Color(0xFFF8F7F5),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: const Color(0x4CA9A8A8),
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.only(left: 16,bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Start Date :',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF151522),
                        fontSize: 10,
                        fontWeight: FontWeight.w400,

                      ),
                    ),
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
                    SizedBox(width: 5,),
                    Text(
                      'Due Date  :',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF151522),
                        fontSize: 10,
                        fontWeight: FontWeight.w400,

                      ),
                    ),
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
                Container(
                  padding: EdgeInsets.only(right: 5),
                  child: Row(
                    children: const [
                      CircleAvatar(radius: 12, backgroundColor: Colors.red),
                      // SizedBox(width: 4),
                      CircleAvatar(radius: 12, backgroundColor: Colors.blue),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
