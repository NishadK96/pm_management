part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String employeeCode;
  final String password;
  final String fcmToken;
  final String deviceType;
  final String deviceId;

  const LoginSubmitted({
    required this.email,
    required this.employeeCode,
    required this.password,
    required this.fcmToken,
    required this.deviceType,
    required this.deviceId,
  });

  @override
  List<Object?> get props => [
        email,
        employeeCode,
        password,
        fcmToken,
        deviceType,
        deviceId,
      ];
}