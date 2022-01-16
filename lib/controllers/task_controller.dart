import 'package:todo/models/task.dart';

class TaskController {
  List taskList = <Task>[
    Task(
      title: 'title 1 ',
      note: 'No thing to do ',
      startTime: '20:6',
      endTime: '3:20',
      date: 'wed',
      color: 1,
      isCompleted: 0,
    ),
  ];

  void getTasks() {}
}
