import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';
class CustomTextField extends StatelessWidget {
  final bool isLogin;
  final String? label;
  final TextEditingController? controller;
  final String? hint;
  final  bool? isPassword;
  const CustomTextField({super.key, this.label,this.isLogin=false,this.controller,this.hint,this.isPassword});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ?isLogin? null: Text(
          label??'Full name',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        ?isLogin? null:SizedBox(height: 5,),

        TextField(
          controller: controller,
          obscureText: isPassword??false,
          decoration:isLogin?InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
                color: AppColors.labelGrey
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: BorderSide(color: AppColors.grey)),
            disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: BorderSide(color: AppColors.grey)),
            focusedBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: BorderSide(color: AppColors.primary)),
            enabledBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(8),borderSide: BorderSide(color: AppColors.grey)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ) :InputDecoration(

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

