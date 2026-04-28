// lib/features/create_project/bloc/create_project_event.dart
part of 'create_project_bloc.dart';

abstract class CreateProjectEvent extends Equatable {
  const CreateProjectEvent();

  @override
  List<Object?> get props => [];
}

class SubmitCreateProject extends CreateProjectEvent {
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime dueDate;
  final bool notifyDue;

  const SubmitCreateProject({
    required this.name,
    required this.description,
    required this.startDate,
    required this.dueDate,
    required this.notifyDue,
  });

  @override
  List<Object?> get props => [name, description, startDate, dueDate, notifyDue];
}