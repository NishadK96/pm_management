import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ipsum_user/core/utils/data_response.dart';
import 'package:ipsum_user/features/project/data/project_data_src.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectDataSource _dataSource = ProjectDataSource();
  ProjectBloc() : super(ProjectListInitial());
  @override
  Stream<ProjectState> mapEventToState(ProjectEvent event) async* {
    if (event is GetProjects) {
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

  Stream<ProjectState> getProjects() async* {
    yield ProjectListLoading();
    final dataResponse = await _dataSource.getProjects();
    if (dataResponse.data1) {
      yield ProjectListSuccess(productList: dataResponse);
    } else {
      yield ProjectListFailed();
    }
  }
  Stream<ProjectState> getProjectDetails() async* {
    yield ProjectDetailsLoading();
    final dataResponse = await _dataSource.projectDetails();
    if (dataResponse.data1) {
      yield ProjectDetailsSuccess(productList: dataResponse);
    } else {
      yield ProjectDetailsFailed();
    }
  }


}
