import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ipsum_user/features/login/domain/entities/session.dart';
import 'package:ipsum_user/features/login/domain/usecases/login_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc({required this.loginUseCase}) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      final session = await loginUseCase(
        email: event.email,
        employeeCode: event.employeeCode,
        password: event.password,
        fcmToken: event.fcmToken,
        deviceType: event.deviceType,
        deviceId: event.deviceId,
      );

      emit(LoginSuccess(session: session));
    } catch (e) {
      emit(LoginFailure(message: e.toString()));
    }
  }
}