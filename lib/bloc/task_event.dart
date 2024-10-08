part of 'task_bloc.dart';

@immutable
sealed class TaskEvent {}

final class GetTaskList extends TaskEvent {}

final class AddNewTask extends TaskEvent {
  final TaskModel task ;

  AddNewTask({required this.task});
}

final class UpdateTask extends TaskEvent {
  final TaskModel task;

  UpdateTask({required this.task});
}

final class DeleteTask extends TaskEvent {
  final int id;

  DeleteTask({required this.id});
}

