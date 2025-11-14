import 'package:json_annotation/json_annotation.dart';

// part 'project_model.g.dart';
class ProjectModel {
  String? id;
  String? name;
  String? description;
  @JsonKey(name: 'start_date')
  String? startDate;
  @JsonKey(name: 'due_date')
  String? dueDate;
  String? status;
  String? priority;
  @JsonKey(name: 'notify_due',defaultValue: false)
  bool? notifyDue;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'updated_at')
  String? updatedAt;
  @JsonKey(name: 'created_by')
  String? createdBy;
  @JsonKey(name: 'updated_by')
  String? updatedBy;


  ProjectModel({this.id,
    this.name,
    this.description,
    this.startDate,
    this.dueDate,
    this.status,
    this.priority,
    this.notifyDue,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy
  });

  ProjectModel.fromJson(Map<String, dynamic> json) {
    // print();
    id = json['id'];
    name=json['name'];
    description = json['description'];
    startDate = json['start_date'];
    dueDate = json['due_date'];
    status = json['status'];
    priority = json['priority'];
    notifyDue = json['notify_due'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['start_date'] = startDate;
    data['due_date'] = dueDate;
    data['status'] = status;
    data['priority'] = priority;
    data['notify_due'] = notifyDue;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;


    return data;
  }
  // factory ProjectModel.fromJson(Map<String, dynamic> srcJson) =>
  //     _$ProjectFromJson(srcJson);
  //
  // Map<String, dynamic> toJson() => _$ProjectToJson(this);
}

