part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class FetchTasksForProject extends TaskEvent {
  final String projectId;

  const FetchTasksForProject({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}