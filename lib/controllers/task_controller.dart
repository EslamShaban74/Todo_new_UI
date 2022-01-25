import 'package:todo/models/task.dart';
import 'package:intl/intl.dart';

class TaskController {
  List taskList = <Task>[
    Task(
      id: 5,
      title: 'title 1 ',
      note: 'No thing to do ',
      startTime: DateFormat('hh:mm a')
          .format(DateTime.now().add(const Duration(minutes: 1))),
      date: 'wed',
      color: 1,
      isCompleted: 0,
    ),
    Task(
      id: 1,
      title: 'title 1 ',
      note: 'No thing to do ',
      startTime: DateFormat('hh:mm a')
          .format(DateTime.now().add(const Duration(minutes: 1))),
      date: 'wed',
      color: 1,
      isCompleted: 0,
    ),
    Task(
      id: 1,
      title: 'title 1 ',
      note: 'No thing to do ',
      startTime: DateFormat('hh:mm a')
          .format(DateTime.now().add(const Duration(minutes: 1))),
      date: 'wed',
      color: 1,
      isCompleted: 0,
    ),
    Task(
      id: 1,
      title: 'title 1 ',
      note: 'No thing to do ',
      startTime: DateFormat('hh:mm a')
          .format(DateTime.now().add(const Duration(minutes: 1))),
      date: 'wed',
      color: 1,
      isCompleted: 0,
    ),
  ];


  addTask({required Task task}) {


  }

  void getTasks() {}
}
