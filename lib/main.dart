import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/utils/authenticate.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/login/bloc/login_bloc.dart';
import 'features/login/login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await authentication.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) =>  runApp(MultiBlocProvider(providers: [
      BlocProvider(
      create: (context) => LoginBloc(),
      )
  ],
    child:
    const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: authentication.isAuthenticated?DashboardScreen():const Login(),
    );
  }
}

