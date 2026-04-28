// lib/features/login/domain/entities/session.dart

class Session {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String username;
  final String empId;
  final String role;

  Session({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.username,
    required this.empId,
    required this.role,
  });
}