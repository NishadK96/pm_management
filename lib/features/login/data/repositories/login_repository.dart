// lib/features/login/data/repositories/login_repository.dart
import 'package:ipsum_user/core/local/app_prefs.dart';
import 'package:ipsum_user/features/login/data/login_data_src.dart';
import 'package:ipsum_user/features/login/domain/entities/session.dart';
import 'package:ipsum_user/features/login/domain/repositories/i_login_repository.dart';

class LoginRepository implements ILoginRepository {
  final LoginDataSource dataSource;
  final AppPrefs appPrefs;

  LoginRepository({
    required this.dataSource,
    required this.appPrefs,
  });

  @override
  Future<Session> login({
    required String email,
    required String employeeCode,
    required String password,
    required String fcmToken,
    required String deviceType,
    required String deviceId,
  }) async {
    final user = await dataSource.login(
      email: email,
      employeeCode: employeeCode,
      password: password,
      fcmToken: fcmToken,
      deviceType: deviceType,
      deviceId: deviceId,
    );

    final session = Session(
      accessToken: user.access??"",
      refreshToken: user.refresh??"",
      userId: user.userId??"",
      username: user.username??"",
      empId: user.empId??"",
      role: user.role??"",
    );

    await appPrefs.saveSession(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      userId: session.userId,
      username: session.username,
      empId: session.empId,
      role: session.role,
    );

    return session;
  }
}