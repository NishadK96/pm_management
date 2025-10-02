import 'package:dio/dio.dart';
import 'package:ipsum_user/core/utils/authenticate.dart';
import 'package:ipsum_user/core/utils/data_response.dart';
import 'package:ipsum_user/core/utils/urls.dart';
import 'package:ipsum_user/features/login/model/user_model.dart';

class LoginDataSource {
  Dio client = Dio();

  Future<DoubleResponse> userLogin({
    required String password,
    required String email,
    required String employeeCode,
  }) async {
    UserModel authenticatedUser;
    print(PmUrls.loginUrl);
    final response = await client.post(
      PmUrls.loginUrl,
      data:
      // {
      //   "username": "coordinator@gmail.com",
      //   "employee_code": "EMP0012",
      //   "password": "aDxRJSYy",
      // },
      {
        "username": email,
        "employee_code":employeeCode,
        "password": password,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.data['status'] == 200) {
      authenticatedUser = UserModel.fromJson(response.data['data']);

      if (authenticatedUser.access != null) {
        await authentication.saveAuthenticatedUser(
          authenticatedUser: authenticatedUser,
        );
      }
      return DoubleResponse(
        response.data['status'] == 200,
        response.data['message'],
      );
    }

    return DoubleResponse(
      response.data['status'] ,
      response.data['message'],
    );
  }
  Future<DoubleResponse> updateAccessToken() async {
    String? token=authentication.authenticatedUser.refresh;
    print(PmUrls.tokenUpdateUrl);
    final response = await client.post(
      PmUrls.tokenUpdateUrl,
      data:
      {
        "refresh": token,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
print(response.data);
    if (response.data['status'] == 200) {

      return DoubleResponse(
        response.data['status'] == 200,
        response.data['message'],
      );
    }

    return DoubleResponse(
      response.data['status'] ,
      response.data['message'],
    );
  }
}
