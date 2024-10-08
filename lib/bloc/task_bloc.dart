import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_flow/models/task_model.dart';
import 'package:task_flow/services/sqlite_instance.dart';

part 'task_event.dart';

part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final _sqliteInstance = SqliteInstance();

  TaskBloc() : super(TaskInitial()) {
    on<GetTaskList>(_onGetTaskList);
    on<AddNewTask>(_onAddNewTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  void _onGetTaskList(GetTaskList event, Emitter<TaskState> emit) async {
    try {
      emit(TaskLoading());

      await _sqliteInstance.connection();

      final allTask = await _sqliteInstance.getAllTasks();

      emit(TaskLoaded(tasks: allTask.reversed.toList()));
    } catch (e, s) {
      print("Stack Trace : $s");
      emit(TaskError(
          message: "Gagal mengambil list task : ${e.toString()}"));
    }
  }

  void _onAddNewTask(AddNewTask event, Emitter<TaskState> emit) async {
    try {
      emit(TaskLoading());

      await _sqliteInstance.connection();

      final insertTask = await _sqliteInstance.insertTask(event.task);

      if (insertTask != 0) {
        emit(ActionTaskSuccess());
      } else {
        emit(TaskError(message: "Task gagal tersimpan, coba lagi nanti!"));
      }
    } catch (e, s) {
      print("Stack Trace : $s");
      emit(TaskError(message: "Task gagal tersimpan : ${e.toString()}"));
    }
  }

  void _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      emit(TaskLoading());

      await _sqliteInstance.connection();

      final insertTask = await _sqliteInstance.updateTask(event.task);

      if (insertTask != 0) {
        emit(ActionTaskSuccess());
      } else {
        emit(TaskError(message: "Task gagal diperbarui, coba lagi nanti!"));
      }
    } catch (e, s) {
      print("Stack Trace : $s");
      emit(TaskError(message: "Task gagal tersimpan : ${e.toString()}"));
    }
  }

  void _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      emit(TaskLoading());

      await _sqliteInstance.connection();
      final deleteTask = await _sqliteInstance.deleteTask(event.id);

      if (deleteTask != 0) {
        emit(ActionTaskSuccess());
      } else {
        emit(TaskError(message: "Task gagal dihapus, coba lagi nanti!"));
      }
    } catch (e, s) {
      print("Stack Trace : $s");
      emit(TaskError(message: "Task gagal dihapus : ${e.toString()}"));
    }
  }
}
