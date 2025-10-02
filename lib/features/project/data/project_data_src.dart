import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:ipsum_user/core/utils/authenticate.dart';
import 'package:ipsum_user/core/utils/data_response.dart';
import 'package:ipsum_user/core/utils/urls.dart';
import 'package:ipsum_user/features/login/data/login_data_src.dart';
import 'package:ipsum_user/features/project/model/project_model.dart';
import 'package:mime/mime.dart';
// import 'package:pos_app/auth/authenticate.dart';
// import 'package:pos_app/products/model/model.dart';
// import 'package:pos_app/utils/data_response.dart';
// import 'package:pos_app/utils/urls.dart';
import 'package:http_parser/http_parser.dart';
// import 'package:pos_app/variants/model/variant_model.dart';

class ProjectDataSource {
  Dio client = Dio();


  Future<DoubleResponse> getProjects() async {
    print("........${PmUrls.projectUrl}");
    try {
      final response = await client.get(
        PmUrls.projectUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            // 'Authorization' : 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzU5NDIzMzg3LCJpYXQiOjE3NTk0MjI0ODcsImp0aSI6IjE0MzZiNDBmMzQwODQ1ZThhNjJhNTQ0ODk2OTBkNGI1IiwidXNlcl9pZCI6ImRjNzlkNTI3LTY5YzUtNDNlZS05ZTRjLTk4ODE4ZTI4OThhMSJ9.I4bsq0EnUwK2l5TrUzWWnIIqIqCEhtEqDsxI6rVbwc8'
            'Authorization' : 'Bearer ${authentication.token}'
          },

        ),
      );
      print("responseeee $response");
      if (response.data['status'] == 200) {
        List<ProjectModel> productList = [];
        for (var element in response.data['data']) {
          productList.add(ProjectModel.fromJson(element));
        }
      print(productList.length);
        return DoubleResponse(true, productList);
      }
      else if(response.data['code']=="token_not_valid"){
        print("helooooooooooooooooooooooooooooooooooo");
       final tokenResponse= LoginDataSource().updateAccessToken();
       print(tokenResponse.toString());
        final response = await client.get(
          PmUrls.projectUrl,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization' : 'Bearer ${authentication.token}'
            },

          ),
        );
        return DoubleResponse(false, null);
      }
      else {
        // If the response status is not 'success', handle the error here
        return DoubleResponse(false, null);
      }
    } catch (e) {
      print("excccccdeee $e");
      // If an exception occurs during the request, handle it here
      return DoubleResponse(
        false,
        null,
      );
    }
  }
  Future<DoubleResponse> projectDetails({String? id}) async {
    print("........${PmUrls.projectUrl}");
    try {
      final response = await client.get(
        "${PmUrls.projectUrl}$id",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization' : 'Bearer ${authentication.token}'
          },

        ),
      );
      print("responseeee $response");
      if (response.data['status'] == '200') {
        ProjectModel? projectData ;
        for (var element in response.data['data']) {
          projectData=ProjectModel.fromJson(element);
        }
// print(projectData.id);
        return DoubleResponse(true, projectData);
      } else {
        // If the response status is not 'success', handle the error here
        return DoubleResponse(false, null);
      }
    } catch (e) {
      print("excccccdeee $e");
      // If an exception occurs during the request, handle it here
      return DoubleResponse(
        false,
        null,
      );
    }
  }


}
