// lib/features/login/domain/usecases/login_usecase.dart
import 'package:ipsum_user/features/login/domain/entities/session.dart';
import 'package:ipsum_user/features/login/domain/repositories/i_login_repository.dart';

class LoginUseCase {
  final ILoginRepository repository;

  LoginUseCase(this.repository);

  Future<Session> call({
    required String email,
    required String employeeCode,
    required String password,
    required String fcmToken,
    required String deviceType,
    required String deviceId,
  }) {
    return repository.login(
      email: email,
      employeeCode: employeeCode,
      password: password,
      fcmToken: fcmToken,
      deviceType: deviceType,
      deviceId: deviceId,
    );
  }
}