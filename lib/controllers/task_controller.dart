import 'package:todo/models/task.dart';
import 'package:get/get.dart';

import '../db/db_helper.dart';

class TaskController {
  List taskList = <Task>[].obs;

  Future<int> addTask({required Task task}) {
    return DBHelper.insert(task);
  }

  void getTasks() async {
    final List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  deleteTasks({required Task task}) async {
    await DBHelper.delete(task);
    getTasks();
  }

  deleteAll() async {
    await DBHelper.deleteAll();
    getTasks();
  }

  markTaskCompleted({required int id}) async {
    await DBHelper.update(id);
    getTasks();
  }
}
