// lib/features/projects/bloc/project_state.dart
part of 'project_bloc.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object?> get props => [];
}

class ProjectInitial extends ProjectState {
  const ProjectInitial();
}

class ProjectLoading extends ProjectState {
  const ProjectLoading();
}

class ProjectLoaded extends ProjectState {
  final List<ProjectModel> projects;

  const ProjectLoaded({required this.projects});

  @override
  List<Object?> get props => [projects];
}

class ProjectError extends ProjectState {
  final String message;

  const ProjectError({required this.message});

  @override
  List<Object?> get props => [message];
}