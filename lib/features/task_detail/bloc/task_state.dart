part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();
  @override
  List<Object> get props => [];
}

class TaskListInitial extends TaskState {}

class TaskListLoading extends TaskState {}

class TaskListSuccess extends TaskState {
  final List<ProjectModel>  taskList;

  const TaskListSuccess({required this.taskList});
}

class ProjectListFailed extends TaskState {}
class ProjectDetailsLoading extends TaskState {}

class ProjectDetailsSuccess extends TaskState {
  final  DoubleResponse productList;

  const ProjectDetailsSuccess({required this.productList});
}

class ProjectDetailsFailed extends TaskState {}
