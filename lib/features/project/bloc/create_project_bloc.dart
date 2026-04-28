// lib/features/create_project/bloc/create_project_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ipsum_user/features/project/model/project_model.dart';
import 'package:ipsum_user/features/project/data/repositories/projects_repository.dart';

part 'create_project_event.dart';
part 'create_project_state.dart';

class CreateProjectBloc extends Bloc<CreateProjectEvent, CreateProjectState> {
  final ProjectsRepository repository;

  CreateProjectBloc({required this.repository})
      : super(const CreateProjectInitial()) {
    on<SubmitCreateProject>(_onSubmitCreateProject);
  }

  Future<void> _onSubmitCreateProject(
    SubmitCreateProject event,
    Emitter<CreateProjectState> emit,
  ) async {
    emit(const CreateProjectLoading());

    try {
      String formatDate(DateTime d) =>
          '${d.year.toString().padLeft(4, '0')}-'
          '${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')}';

      final project = await repository.createProject(
        name: event.name,
        description: event.description,
        startDate: formatDate(event.startDate),
        dueDate: formatDate(event.dueDate),
        notifyDue: event.notifyDue,
      );

      emit(CreateProjectSuccess(project: project));
    } catch (e) {
      emit(CreateProjectFailure(message: e.toString()));
    }
  }
}