part of 'dashboard_bloc.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final dynamic data;

  DashboardLoaded({required this.data});
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError({required this.message});
}