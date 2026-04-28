part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

/// Initial
class LoginInitial extends LoginState {}

/// Loading (used for your button isLoading)
class LoginLoading extends LoginState {}

/// Success
class LoginSuccess extends LoginState {
  final Session session; // or your response model

  const LoginSuccess({required this.session});

  @override
  List<Object?> get props => [session];
}

/// Failure
class LoginFailure extends LoginState {
  final String message;

  const LoginFailure({required this.message});

  @override
  List<Object?> get props => [message];
}