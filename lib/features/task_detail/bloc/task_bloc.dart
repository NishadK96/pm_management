// lib/features/task_detail/bloc/task_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ipsum_user/features/project/data/repositories/projects_repository.dart';
import 'package:ipsum_user/features/task_detail/model/task_model.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final ProjectsRepository repository;

  TaskBloc({required this.repository}) : super(const TaskInitial()) {
    on<FetchTasksForProject>(_onFetchTasksForProject);
  }

  Future<void> _onFetchTasksForProject(
    FetchTasksForProject event,
    Emitter<TaskState> emit,
  ) async {
    emit(const TaskLoading());

    try {
      final tasks = await repository.getTasksForProject(event.projectId);
      emit(TaskLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }
}