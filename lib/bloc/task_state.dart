part of 'task_bloc.dart';

@immutable
sealed class TaskState {}

final class TaskInitial extends TaskState {}

final class TaskLoading extends TaskState {}

final class TaskLoaded extends TaskState {
  final List<TaskModel> tasks;

  TaskLoaded({required this.tasks});
}

final class TaskError extends TaskState {
  final String message;

  TaskError({required this.message});
}

final class ActionTaskSuccess extends TaskState {}
