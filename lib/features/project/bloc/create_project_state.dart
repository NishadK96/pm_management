// lib/features/create_project/bloc/create_project_state.dart
part of 'create_project_bloc.dart';

abstract class CreateProjectState extends Equatable {
  const CreateProjectState();

  @override
  List<Object?> get props => [];
}

class CreateProjectInitial extends CreateProjectState {
  const CreateProjectInitial();
}

class CreateProjectLoading extends CreateProjectState {
  const CreateProjectLoading();
}

class CreateProjectSuccess extends CreateProjectState {
  final ProjectModel project;

  const CreateProjectSuccess({required this.project});

  @override
  List<Object?> get props => [project];
}

class CreateProjectFailure extends CreateProjectState {
  final String message;

  const CreateProjectFailure({required this.message});

  @override
  List<Object?> get props => [message];
}