part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}
class SignInInitial extends LoginState {}

class SignInLoading extends LoginState {}

class SignInSuccess extends LoginState {}

class SignInFailed extends LoginState {
  final String? message;
  const  SignInFailed({this.message});
}
