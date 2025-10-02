part of 'project_bloc.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();
  @override
  List<Object> get props => [];
}

class ProjectListInitial extends ProjectState {}

class ProjectListLoading extends ProjectState {}

class ProjectListSuccess extends ProjectState {
  final  DoubleResponse productList;

  const ProjectListSuccess({required this.productList});
}

class ProjectListFailed extends ProjectState {}
class ProjectDetailsLoading extends ProjectState {}

class ProjectDetailsSuccess extends ProjectState {
  final  DoubleResponse productList;

  const ProjectDetailsSuccess({required this.productList});
}

class ProjectDetailsFailed extends ProjectState {}
