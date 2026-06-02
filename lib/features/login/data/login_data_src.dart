// import 'package:dio/dio.dart';
// import 'package:ipsum_user/core/urls.dart';
// import 'package:ipsum_user/core/utils/authenticate.dart';
// import 'package:ipsum_user/core/utils/data_response.dart';
// import 'package:ipsum_user/features/login/model/user_model.dart';

// class LoginDataSource {
//   Dio client = Dio();

//   Future<DoubleResponse> userLogin({
//     required String password,
//     required String email,
//     required String employeeCode,
//   }) async {
//     UserModel authenticatedUser;
//     print(PmUrls.loginUrl);
//     print(email);
//     print(employeeCode);
//     print(password);
//     final response = await client.post(
//       PmUrls.loginUrl,
//       data:
//       // {
//       //   "username": "coordinator@gmail.com",
//       //   "employee_code": "EMP0012",
//       //   "password": "aDxRJSYy",
//       // },
//       {
//         "username": email,
//         "employee_code": employeeCode,
//         "password": password
//       },

//       options: Options(
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//       ),
//     );
// print("responseee $response");
//     if (response.data['status'] == 200) {
//       authenticatedUser = UserModel.fromJson(response.data['data']);

//       if (authenticatedUser.access != null) {
//         await authentication.saveAuthenticatedUser(
//           authenticatedUser: authenticatedUser,
//         );
//       }
//       return DoubleResponse(
//         response.data['status'] == 200,
//         response.data['message'],
//       );
//     }

//     return DoubleResponse(
//       response.data['status'] ,
//       response.data['message'],
//     );
//   }
//   Future<DoubleResponse> updateAccessToken() async {
//     String? token=authentication.authenticatedUser.refresh;
//     print(PmUrls.tokenUpdateUrl);
//     final response = await client.post(
//       PmUrls.tokenUpdateUrl,
//       data:
//       {
//         "refresh": token,
//       },
//       options: Options(
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//       ),
//     );
// print(response.data);
//     if (response.data['status'] == 200) {

//       return DoubleResponse(
//         response.data['status'] == 200,
//         response.data['message'],
//       );
//     }

//     return DoubleResponse(
//       response.data['status'] ,
//       response.data['message'],
//     );
//   }
// }
// lib/features/login/data/datasources/login_data_source.dart
import 'package:dio/dio.dart';
import 'package:ipsum_user/core/urls.dart';
import 'package:ipsum_user/core/utils/authenticate.dart';
import 'package:ipsum_user/core/utils/data_response.dart';

import 'package:ipsum_user/features/login/model/user_model.dart';

class LoginDataSource {
  final Dio client;

  LoginDataSource({Dio? dio}) : client = dio ?? Dio();

 Future<UserModel> login({
  required String email,
  required String employeeCode,
  required String password,
  required String fcmToken,
  required String deviceType,
  required String deviceId,
}) async {
  try {
    final url =
        'https://backend.project-management-tool.shamshailksa.com/auth/user-login/';

    print("API CALLED $url");

    final response = await client.post(
      url,
      data: {
        "username": email,
        "employee_code": employeeCode,
        "password": password,
        "fcm_token": fcmToken,
        "device_type": deviceType,
        "device_id": deviceId,
      },
      options: Options(
        followRedirects: true,
        validateStatus: (status) => status != null && status < 500,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE DATA: ${response.data}");

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;

      if (data['status'] == 200 && data['data'] != null) {
        return UserModel.fromJson(
          data['data'] as Map<String, dynamic>,
        );
      } else {
        throw Exception(data['message'] ?? 'Login failed');
      }
    } else {
      throw Exception(
        'Login failed with code ${response.statusCode}',
      );
    }
  } on DioException catch (e) {
    print("DIO ERROR: ${e.message}");
    print("DIO RESPONSE: ${e.response?.data}");
    print("DIO STATUS: ${e.response?.statusCode}");
    rethrow;
  } catch (e, stack) {
    print("LOGIN ERROR: $e");
    print(stack);
    rethrow;
  }
}
  Future<DoubleResponse> updateAccessToken() async {
    String? token = authentication.authenticatedUser.refresh;
    print(PmUrls.tokenUpdateUrl);
    final response = await client.post(
      PmUrls.tokenUpdateUrl,
      data: {
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
      response.data['status'],
      response.data['message'],
    );
  }
}
