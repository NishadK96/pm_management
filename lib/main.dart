import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:ipsum_user/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:ipsum_user/features/dashboard/dashboard_screen.dart';
import 'package:ipsum_user/features/login/bloc/login_bloc.dart';
import 'package:ipsum_user/features/login/data/login_data_src.dart';
import 'package:ipsum_user/features/login/login.dart';
import 'package:ipsum_user/features/project/bloc/create_project_bloc.dart';
import 'package:ipsum_user/features/project/bloc/project_bloc.dart';
import 'package:ipsum_user/features/project/data/datasources/projects_data_source.dart';
import 'package:ipsum_user/features/project/data/repositories/projects_repository.dart';
import 'package:ipsum_user/features/task_detail/bloc/task_bloc.dart';
import 'package:ipsum_user/features/users/data/datasources/users_data_source.dart';
import 'package:ipsum_user/features/users/data/repositories/users_repository.dart';
import 'package:ipsum_user/injection_container.dart' as di;
import 'package:ipsum_user/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/local/app_prefs.dart';

import 'features/login/data/repositories/login_repository.dart';
import 'features/login/domain/usecases/login_usecase.dart';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
final appPrefs = sl<AppPrefs>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // // Build dependencies
  // final prefs = await SharedPreferences.getInstance();
  // final appPrefs = AppPrefs(prefs);
  final dio = Dio();

  // Login
  final loginDataSource = LoginDataSource(dio: dio);
  final loginRepository =
      LoginRepository(dataSource: loginDataSource, appPrefs: appPrefs);
  final loginUseCase = LoginUseCase(loginRepository);

  // Projects
  final projectsDataSource =
      ProjectsDataSource(client: dio, appPrefs: appPrefs);
  final projectsRepository = ProjectsRepository(dataSource: projectsDataSource);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  

  // Users
  final usersDataSource = UsersDataSource(client: dio, appPrefs: appPrefs);
  final usersRepository = UsersRepository(dataSource: usersDataSource);

  final bool isAuthenticated = appPrefs.isLoggedIn;
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (value) => runApp(
      MultiRepositoryProvider(
        providers: [
          // 👇 make AppPrefs available everywhere
          RepositoryProvider<AppPrefs>.value(value: appPrefs),

          // if you want repo access via context.read<>
          RepositoryProvider<ProjectsRepository>.value(
            value: projectsRepository,
          ),
          // add UsersRepository here too if you use it
          // RepositoryProvider<UsersRepository>.value(value: usersRepository),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => LoginBloc(loginUseCase: loginUseCase),
            ),
            BlocProvider(
              create: (context) => ProjectBloc(repository: projectsRepository),
            ),
            BlocProvider(
              create: (context) =>
                  CreateProjectBloc(repository: projectsRepository),
            ),
            BlocProvider(
              create: (context) => TaskBloc(repository: projectsRepository),
            ),
            BlocProvider(
              create: (context) =>
                  DashboardBloc(repository: projectsRepository),
            ),
          ],
          child: MyApp(isAuthenticated: isAuthenticated,loginUseCase: loginUseCase,projectsRepository: projectsRepository),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;
  final LoginUseCase loginUseCase;
  final ProjectsRepository projectsRepository;

  const MyApp({
    super.key,
    required this.isAuthenticated,
    required this.loginUseCase,
    required this.projectsRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: isAuthenticated
          ? BlocProvider(
              // ✅ ProjectBloc needs repository, we pass it here
              create: (_) => ProjectBloc(repository: projectsRepository)
                ..add(const FetchProjects()),
              child: const DashboardScreen(),
            )
          : BlocProvider(
              // ✅ LoginBloc needs loginUseCase
              create: (_) => LoginBloc(loginUseCase: loginUseCase),
              child: const Login(),
            ),
    );
  }
}
