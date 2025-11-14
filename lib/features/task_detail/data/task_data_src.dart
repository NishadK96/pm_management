import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:ipsum_user/core/utils/authenticate.dart';
import 'package:ipsum_user/core/utils/data_response.dart';
import 'package:ipsum_user/core/utils/urls.dart';
import 'package:ipsum_user/features/login/data/login_data_src.dart';
import 'package:ipsum_user/features/project/model/project_model.dart';
import 'package:mime/mime.dart';

import 'package:http_parser/http_parser.dart';
// import 'package:pos_app/variants/model/variant_model.dart';

class TaskDataSource {
  Dio client = Dio();

  String Token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzU5NTExOTQ3LCJpYXQiOjE3NTk1MTEwNDcsImp0aSI6ImFkZjViY2I0MTBhMjQ2OTA5NTY2MjhlYTU0ZGZhOWQ3IiwidXNlcl9pZCI6ImRjNzlkNTI3LTY5YzUtNDNlZS05ZTRjLTk4ODE4ZTI4OThhMSJ9.v5II8_3cLTV6RNR7A6_mqjdLmIU7lS0Tr_HcevFVGgE";
  Future<DoubleResponse> getTasks() async {

    try {
      final response = await client.get(
        PmUrls.taskUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization' : 'Bearer $Token'
            // 'Authorization' : 'Bearer ${authentication.token}'
          },

        ),
      );

      if (response.data['status'] == 200) {
        List<ProjectModel> productList = [];
        for (var element in response.data['data']) {
          productList.add(ProjectModel.fromJson(element));

        } print(productList[0].name);

        // print(productList.first);
        return DoubleResponse(true, productList);
      }
      else if(response.statusCode==401){
        print("helooooooooooooooooooooooooooooooooooo");
        final tokenResponse= LoginDataSource().updateAccessToken();
        print(tokenResponse.toString());
        final response = await client.get(
          PmUrls.projectUrl,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization' : 'Bearer ${tokenResponse}'
            },

          ),
        );
        List<ProjectModel> productList = [];
        for (var element in response.data['data']) {
          productList.add(ProjectModel.fromJson(element));
        }
        print(productList.length);
        return DoubleResponse(true, productList);
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
            'Authorization' : 'Bearer ${Token}'
            // 'Authorization' : 'Bearer ${authentication.token}'
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
