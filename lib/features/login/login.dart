// lib/features/login/presentation/pages/login_page.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipsum_user/core/theme/app_colors.dart';
import 'package:ipsum_user/core/widgets/custom_textfield.dart';
import 'package:ipsum_user/core/widgets/long_button.dart';
import 'package:ipsum_user/features/dashboard/dashboard_screen.dart';
// adjust path if your bloc is somewhere else
import 'package:ipsum_user/features/login/bloc/login_bloc.dart';

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

  // You should actually set these from real sources in initState.
  String? fcmToken;
  String get deviceType => Platform.isAndroid ? 'android' : 'ios';
  String? deviceId;

  @override
  void initState() {
    super.initState();
    // TODO: fetch real values, e.g.:
    // FirebaseMessaging.instance.getToken().then((t) => setState(() => fcmToken = t));
    // DeviceInfoPlugin()... to get deviceId
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    codeController.dispose();
    super.dispose();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            // 🔹 loading flag
            if (state is LoginLoading) {
              setState(() => isLoading = true);
            } else {
              setState(() => isLoading = false);
            }

            // 🔹 error
            if (state is LoginFailure) {
              print("failee state: $state");
              _showSnack(state.message ?? 'Login failed');
            }

            // 🔹 success (note: no session.*, use fields directly)
            if (state is LoginSuccess) {
              _showSnack('Login successful as ${state.session.role  ?? 'unknown'}');
              // TODO: navigate to dashboard
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
              );
            }
          },
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    // Logo section
                    SizedBox(
                      width: double.infinity,
                      height: size.height * 0.3,
                      child: Container(
                        padding: const EdgeInsets.all(90),
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Form section
                    Container(
                      width: size.width,
                      height: size.height / 1.5,
                      decoration: const BoxDecoration(
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
                          CustomTextField(
                            hint: "Enter email",
                            isLogin: true,
                            controller: emailController,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            hint: "Enter password",
                            controller: passwordController,
                            isLogin: true,
                            isPassword: true,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            hint: "Employee code",
                            isLogin: true,
                            controller: codeController,
                          ),
                          const SizedBox(height: 40),
                          LongButton(
                            isLoading: isLoading,
                            onTap: () async {
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();
                              final code = codeController.text.trim();

                              if (email.isEmpty ||
                                  password.isEmpty ||
                                  code.isEmpty) {
                                _showSnack('Please fill all fields');
                                return;
                              }

                              // if (fcmToken == null || deviceId == null) {
                              //   _showSnack('Device info not ready yet');
                              //   return;
                              // }

                              context.read<LoginBloc>().add(
                                    LoginSubmitted(
                                      email: email,
                                      password: password,
                                      employeeCode: code,
                                      fcmToken: fcmToken??"",
                                      deviceType: deviceType,
                                      deviceId: deviceId??"",
                                    ),
                                  );
                            },
                            label: "Login",
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    alignment: Alignment.center,
                    width: size.width,
                    padding: const EdgeInsets.only(bottom: 25),
                    child: const _TermsText(),
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

class _TermsText extends StatelessWidget {
  const _TermsText();

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
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
    );
  }
}
