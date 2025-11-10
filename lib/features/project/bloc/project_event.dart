part of 'project_bloc.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object> get props => [];
}

class GetProjects extends ProjectEvent {
  const GetProjects();
}

class GetProjectDetails extends ProjectEvent {
  final String? id;
  const GetProjectDetails({
    this.id
}) ;
}class CreateProject extends ProjectEvent {
  final String? name,
      description,
      startDate,
      dueDate,
      priority;
  const CreateProject({
    this.name,this.startDate,this.dueDate,this.description,this.priority
}) ;
}
