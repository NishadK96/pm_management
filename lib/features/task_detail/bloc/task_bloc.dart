import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ipsum_user/core/utils/data_response.dart';
import 'package:ipsum_user/features/project/data/project_data_src.dart';
import 'package:ipsum_user/features/project/model/project_model.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final ProjectDataSource _dataSource = ProjectDataSource();
  TaskBloc() : super(TaskListInitial());
  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if (event is GetTasks) {
      yield* getProjects();
    }
    // if (event is GetVariantByProduct) {
    //   yield* listVariantByProduct(productId: event.productId);
    // }
    // else if (event is CreateProductEvent) {
    //   yield* createProduct(
    //       name: event.name,
    //       description: event.description,
    //       updatedBy: event.updatedBy,
    //       image: event.image,
    //       costingType: event.costingType);
    // }
    // else if (event is CreateAttributeEvent) {
    //   yield* createAttribute(
    //     name: event.name,
    //     description: event.description,
    //     image: event.image,);
    // }
    // else if (event is GetAllAttributes) {
    //   yield* getAllAttributes();
    // }
  }

  Stream<TaskState> getProjects() async* {
    yield TaskListInitial();
    final dataResponse = await _dataSource.getProjects();
    if (dataResponse.data1) {
      // print(",,,,,,,,,,,,,${dataResponse.data2[0]['name']}");
      yield TaskListSuccess(taskList: dataResponse.data2);
    } else {
      yield ProjectListFailed();
    }
  }
  Stream<TaskState> getProjectDetails() async* {
    yield ProjectDetailsLoading();
    final dataResponse = await _dataSource.projectDetails();
    if (dataResponse.data1) {
      yield ProjectDetailsSuccess(productList: dataResponse);
    } else {
      yield ProjectDetailsFailed();
    }
  }


}
