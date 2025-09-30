import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ipsum_user/features/login/data/login_data_src.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginDataSource _dataSource = LoginDataSource();
  // final _userProvider = UserProvider();

  LoginBloc() : super(SignInInitial());
  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is SignInEvent) {
      yield* _mapCustomerLoginState(
          email: event.email, password: event.password,employeeCode: event.employeeCode);
    }
  }

  Stream<LoginState> _mapCustomerLoginState(
      {required String email, required String password, required String employeeCode}) async* {
    print(email);
    print(password);
    print(employeeCode);
    yield SignInLoading();
    final dataResponse =
    await _dataSource.userLogin(email: email,employeeCode: employeeCode, password: password);
    if (dataResponse.data1) {
      yield SignInSuccess();
    } else {
      yield SignInFailed(message: dataResponse.data2);
    }
  }
}