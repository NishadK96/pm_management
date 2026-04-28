import 'package:bloc/bloc.dart';
import 'package:ipsum_user/features/project/data/repositories/projects_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ProjectsRepository repository;

  DashboardBloc({required this.repository}) : super(DashboardInitial()) {
    on<DashboardStarted>(_onDashboardStarted);
  }

  Future<void> _onDashboardStarted(
    DashboardStarted event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    try {
      final data = await repository.getDashboardData(
        isCoordinator: event.isCoordinator,
      );

      emit(DashboardLoaded(data: data));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }
}