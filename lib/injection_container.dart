// injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:ipsum_user/core/local/app_prefs.dart';
import 'package:ipsum_user/features/project/data/datasources/projects_data_source.dart';
import 'package:ipsum_user/features/project/data/repositories/projects_repository.dart';
import 'package:ipsum_user/features/users/data/repositories/users_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ipsum_user/features/users/data/datasources/users_data_source.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // 1) SharedPreferences
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // 2) AppPrefs
  sl.registerLazySingleton<AppPrefs>(() => AppPrefs(sharedPrefs));

  // 3) Dio
  sl.registerLazySingleton<Dio>(() => Dio());

  // 4) Projects
  sl.registerLazySingleton<ProjectsDataSource>(
    () => ProjectsDataSource(
      client: sl<Dio>(),
      appPrefs: sl<AppPrefs>(),
    ),
  );

  sl.registerLazySingleton<ProjectsRepository>(
    () => ProjectsRepository(
      dataSource: sl<ProjectsDataSource>(),
    ),
  );

  // 5) Users
  sl.registerLazySingleton<UsersDataSource>(
    () => UsersDataSource(
      client: sl<Dio>(),
      appPrefs: sl<AppPrefs>(),
    ),
  );

  sl.registerLazySingleton<UsersRepository>(
    () => UsersRepository(
      dataSource: sl<UsersDataSource>(),
    ),
  );

  // 👉 register other stuff (LoginDataSource, LoginRepository, etc.) similarly
}