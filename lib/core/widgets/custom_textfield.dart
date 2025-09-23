import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class CustomTextField extends StatelessWidget {
  final String? label;
  const CustomTextField({super.key,required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label??'Full name',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 5,),
        TextField(
          decoration: InputDecoration(

              fillColor: Color(0xFFF4F4F4),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFF4F4F4),
                ),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ), enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFF4F4F4),
                ),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),

          ),

        )
      ],
    );
  }
}

