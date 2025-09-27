import 'package:flutter/material.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';
import 'package:ipsum_user/core/widgets/long_button.dart';
import 'package:ipsum_user/features/dashboard/dashboard_screen.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor:AppColors.primary ,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  // Blue Header
                  Container(
                    width: double.infinity,
                    height: size.height * 0.3,
                    decoration: const BoxDecoration(
                      // color: Color(0xFF2471A3),
                      // borderRadius: BorderRadius.only(
                      //   bottomLeft: Radius.circular(40),
                      //   bottomRight: Radius.circular(40),
                      // ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(90),
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/logo.png',
                        // width: 200,
                        // height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // SizedBox(height: size.height * 0.05),

                  // Input Fields
                  Container(
                    width: size.width,
                    height: size.height/1.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 40),
                    child: Column(
                      children: [
                        _buildTextField("Enter email", false),
                        const SizedBox(height: 15),
                        _buildTextField("Enter password", true),
                        const SizedBox(height: 15),
                        _buildTextField("Employee code", false),
                        const SizedBox(height: 40),
                        LongButton(
                          onTap: (){ Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DashboardScreen(),
                            ),
                          );},
                          label: "Login",
                        ),

                      ],
                    ),
                  ),

                  // const Spacer(),

                  // Terms and Privacy

                ],
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  alignment: Alignment.center,
                  width: size.width,
                  padding: const EdgeInsets.only(bottom: 25),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black87, fontSize: 12),
                      children: [
                        TextSpan(text: "By logging in, you accept to our "),
                        TextSpan(
                          text: "Terms",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: " and "),
                        TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, bool isPassword) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
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
      ),
    );
  }
}
