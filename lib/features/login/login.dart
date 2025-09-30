import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';
import 'package:ipsum_user/core/widgets/custom_textfield.dart';
import 'package:ipsum_user/core/widgets/long_button.dart';
import 'package:ipsum_user/features/dashboard/dashboard_screen.dart';

import 'bloc/login_bloc.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          isLoading = false;
          setState(() {});

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardScreen(),
              ),
                  (route) => false);
        } else if (state is SignInFailed) {
          isLoading = false;
          setState(() {});
          Fluttertoast.showToast(msg: state.message ?? "");
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
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
                      decoration: const BoxDecoration(),
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
                      height: size.height / 1.5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 40,
                      ),
                      child: Column(
                        children: [
                          CustomTextField(hint: "Enter email", isLogin: true,controller: emailController,),
                          const SizedBox(height: 15),
                          CustomTextField(
                            hint: "Enter password",
                            controller: passwordController,
                            isLogin: true,
                            isPassword: true,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(hint: "Employee code", isLogin: true,controller: codeController,),
                          const SizedBox(height: 40),
                          LongButton(
                            isLoading: isLoading,
                            onTap: () {
                              isLoading = true;
                              setState(() {});

                              context.read<LoginBloc>().add(SignInEvent(
                                  email: emailController.text,
                                  password: passwordController.text,
                              employeeCode: codeController.text));
                            },
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
      ),
    );
  }
}
