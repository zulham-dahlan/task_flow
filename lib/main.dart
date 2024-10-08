import 'package:flutter/material.dart';
import 'package:task_flow/models/task_model.dart';
import 'package:task_flow/screens/edit_task_screen.dart';
import 'package:task_flow/screens/home_screen.dart';
import 'package:task_flow/screens/new_task_screen.dart';
import 'package:task_flow/style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Flow',
      theme:
          ThemeData(useMaterial3: true, scaffoldBackgroundColor: bgScaffoldColor, fontFamily: "Poppins"),
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        NewTaskScreen.routeName: (context) => const NewTaskScreen(),
        EditTaskScreen.routeName: (context) => EditTaskScreen(
            detailTask: ModalRoute.of(context)?.settings.arguments as TaskModel)
      },
    );
  }
}
