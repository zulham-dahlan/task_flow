import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_flow/models/task_model.dart';

class SqliteInstance {
  Database? database;
  final String databaseName = "task_flow";
  final int databaseVersion = 1;

  Future<Database> connection() async {
    if (database != null && database!.isOpen) {
      return database!;
    }

    database = await _initDatabase();

    return database!;
  }

  Future _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, databaseName);

    return openDatabase(path, version: databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE task (id INTEGER PRIMARY KEY autoincrement, title TEXT, description TEXT, is_complete INTEGER)");
  }

  Future<List<TaskModel>> getAllTasks() async {
    final allTasks = await database!.query("task");

    return allTasks.map((e) => TaskModel.fromJson(e)).toList();
  }

  Future<int> insertTask(TaskModel taskModel) async {
    final insertStatus = await database!.insert("task", taskModel.toJson());
    return insertStatus;
  }

  Future<int> updateTask(TaskModel taskModel) async {
    final updateStatus = await database!.update("task", taskModel.toJson(), where: "id = ?", whereArgs: [taskModel.id]);
    return updateStatus;
  }

  Future<int> deleteTask(int id) async {
    final deleteStatus = await database!.delete("task", where: "id = ?", whereArgs: [id]);
    return deleteStatus;
  }

  Future<int> updateStatusComplete(int id, bool status) async {
    int numberStatus = status ? 1 : 0;
    final updateResult = await database!.rawUpdate("UPDATE task SET is_complete = ? WHERE id = ?", [numberStatus, id]);
    return updateResult;
  }
}
