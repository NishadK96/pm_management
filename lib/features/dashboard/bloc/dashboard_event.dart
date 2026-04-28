part of 'dashboard_bloc.dart';

abstract class DashboardEvent {}

class DashboardStarted extends DashboardEvent {
  final bool isCoordinator;

  DashboardStarted({required this.isCoordinator});
}