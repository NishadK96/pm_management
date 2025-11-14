part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class GetTasks extends TaskEvent {
  const GetTasks();
}

class GetTaskDetails extends TaskEvent {
  final String? id;
  const GetTaskDetails({
    this.id
  }) ;
}
