import 'package:json_annotation/json_annotation.dart';

class UserModel {
  String? refresh;
  String? access;
  @JsonKey(name: 'user_id')
  String? userId;
  String? username;
  @JsonKey(name: 'emp_id')
  String? empId;
  String? role;


  UserModel(
      {this.refresh,
        this.access,
        this.userId,
        this.username,
        this.empId,
        this.role,
       });

  UserModel.fromJson(Map<String, dynamic> json) {
    refresh = json['refresh'];
    access = json['access'];
    userId = json['user_id'];
    username = json['username'];
    empId = json['emp_id'];
    role = json['role'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['refresh'] = refresh;
    data['access'] = access;

    data['user_id'] = userId;
    data['username'] = username;
    data['emp_id'] = empId;
    data['role'] = role;

    return data;
  }
}

