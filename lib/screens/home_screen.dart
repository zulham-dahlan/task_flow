import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_flow/bloc/task_bloc.dart';
import 'package:task_flow/cubit/checkbox_cubit.dart';
import 'package:task_flow/models/task_model.dart';
import 'package:task_flow/screens/edit_task_screen.dart';
import 'package:task_flow/screens/new_task_screen.dart';
import 'package:task_flow/style.dart';
import 'package:task_flow/widgets/delete_confirmation_dialog.dart';
import 'package:top_snackbar/top_snackbar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  static const routeName = "/home_screen";
  final taskBloc = TaskBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgScaffoldColor,
        foregroundColor: Colors.deepOrange,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Task Flow",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, NewTaskScreen.routeName).then((_) {
                taskBloc.add(GetTaskList());
              });
            },
            icon: const Icon(Icons.add),
            iconSize: 30,
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        bloc: taskBloc..add(GetTaskList()),
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            );
          }

          if (state is TaskLoaded) {
            if (state.tasks.isEmpty) {
              return const Padding(padding: EdgeInsets.all(16), child: Center(
                child: Text(
                  "Belum ada tugas.\n Tambahkan tugas untuk memulai!",
                  textAlign: TextAlign.center,
                ),
              ),);
            }

            return ListView.separated(
              itemCount: state.tasks.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemBuilder: (BuildContext context, int index) {
                TaskModel task = state.tasks[index];
                final deleteTaskBloc = TaskBloc();
                final checkBoxCubit = CheckboxCubit();

                checkBoxCubit.initValue(task.isComplete);

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 1.2),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    horizontalTitleGap: 4,
                    leading: BlocConsumer<CheckboxCubit, bool>(
                      bloc: checkBoxCubit,
                      listener: (context, state) {
                        if (!checkBoxCubit.isInitialized) {
                          if (state) {
                            CustomTopSnackbar.showSuccess(
                                duration: const Duration(seconds: 2),
                                context,
                                'Task Complete');
                          } else {
                            CustomTopSnackbar.showInfo(
                                duration: const Duration(seconds: 2),
                                context,
                                'Task Incomplete');
                          }
                        }
                      },
                      builder: (context, state) {
                        return Checkbox(
                          activeColor: Colors.deepOrange,
                          value: state,
                          onChanged: (bool? value) {
                            checkBoxCubit.changeCheckboxValue(task.id!, value!);
                          },
                        );
                      },
                    ),
                    title: Text(
                      task.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis),
                      maxLines: 2,
                    ),
                    subtitle: Text(
                      task.description,
                      style: const TextStyle(overflow: TextOverflow.ellipsis),
                      maxLines: 3,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, EditTaskScreen.routeName,
                              arguments: task)
                          .then((_) {
                        taskBloc.add(GetTaskList());
                      });
                    },
                    trailing: BlocListener<TaskBloc, TaskState>(
                      bloc: deleteTaskBloc,
                      listener: (context, state) {
                        if (state is ActionTaskSuccess) {
                          taskBloc.add(GetTaskList());
                        }

                        if (state is TaskError) {
                          CustomTopSnackbar.showError(context, state.message);
                        }
                      },
                      child: IconButton(
                          onPressed: () async {
                            final isConfirm =
                                await deleteConfirmationDialog(context);
                            if (isConfirm) {
                              deleteTaskBloc.add(DeleteTask(id: task.id!));
                            }
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 8);
              },
            );
          }

          if (state is TaskError) {
            return Center(child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis), maxLines: 3,
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    taskBloc.add(GetTaskList());
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  child: const Text(
                    "Refresh",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),);
          }
          return Container();
        },
      ),
    );
  }
}
