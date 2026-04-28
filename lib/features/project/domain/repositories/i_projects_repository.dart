import 'package:ipsum_user/features/project/model/project_model.dart';

abstract class IProjectsRepository {
  Future<List<ProjectModel>> getProjects();
}