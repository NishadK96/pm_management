// lib/features/project/bloc/project_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ipsum_user/features/project/data/repositories/projects_repository.dart';
import 'package:ipsum_user/features/project/model/project_model.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectsRepository repository;

  ProjectBloc({required this.repository}) : super(const ProjectInitial()) {
    on<FetchProjects>(_onFetchProjects);
  }

  Future<void> _onFetchProjects(
    FetchProjects event,
    Emitter<ProjectState> emit,
  ) async {
    emit(const ProjectLoading());

    try {
      final projects = await repository.getProjects();
      emit(ProjectLoaded(projects: projects));
    } catch (e) {
      emit(ProjectError(message: e.toString()));
    }
  }
}