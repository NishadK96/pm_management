// lib/features/login/domain/repositories/i_login_repository.dart
import 'package:ipsum_user/features/login/domain/entities/session.dart';

abstract class ILoginRepository {
  Future<Session> login({
    required String email,
    required String employeeCode,
    required String password,
    required String fcmToken,
    required String deviceType,
    required String deviceId,
  });
}