import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/input_field.dart';

import '../../models/task.dart';
import '../widgets/button.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final DateTime _selectedDate = DateTime.now();
  final String _startTime =
      DateFormat('hh:mm a').format(DateTime.now()).toString();
  final String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)));

  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Add Task', style: headingStyle),
              InputField(
                title: 'Title',
                hint: 'Enter title here',
                controller: _titleController,
              ),
              InputField(
                title: 'Note',
                hint: 'Enter note here',
                controller: _noteController,
              ),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.calendar_today_outlined),
                  color: Colors.grey,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.access_time_rounded),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: InputField(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.access_time_rounded),
                        color: Colors.grey,
                      ),
                    ),
                  )
                ],
              ),
              InputField(
                title: 'Remind',
                hint: '$_selectedRemind minutes early',
                widget: Row(
                  children: [
                    DropdownButton(
                      borderRadius: BorderRadius.circular(10.0),
                      dropdownColor: Colors.blueGrey,
                      items: remindList
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(
                                '$value',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList(),
                      style: subTitleStyle,
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedRemind = newValue!;
                        });
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                        size: 24,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      underline: Container(height: 0),
                    ),
                    const SizedBox(width: 6.0),
                  ],
                ),
              ),
              InputField(
                title: 'Repeat',
                hint: _selectedRepeat,
                widget: Row(
                  children: [
                    DropdownButton(
                      dropdownColor: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10.0),
                      items: repeatList
                          .map<DropdownMenuItem<String>>(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList(),
                      style: subTitleStyle,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRepeat = newValue!;
                        });
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                        size: 24,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      underline: Container(height: 0),
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
              const SizedBox(height: 18.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalette(),
                  MyButton(
                    label: 'Create Task',
                    onTap: () {
                      _validateDate();
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() => AppBar(
        elevation: 0.0,
        backgroundColor: context.theme.backgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Get.isDarkMode ? Colors.white : primaryClr,
            size: 20,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/person.jpeg'),
          ),
          SizedBox(width: 20.0),
        ],
      );

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      addTaskstoDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        'Field required',
        'Title and Note fields are required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
      );
    } else {
      debugPrint('errrrrrroorrr');
    }
  }

  addTaskstoDb() async {
    int value = await _taskController.addTask(
      task: Task(
        title: _titleController.text,
        note: _noteController.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        color: _selectedColor,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
      ),
    );

    debugPrint('$value');
  }

  _colorPalette() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Color',
            style: titleStyle,
          ),
          const SizedBox(height: 8.0),
          Wrap(
            children: List.generate(
                3,
                (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CircleAvatar(
                          child: _selectedColor == index
                              ? const Icon(
                                  Icons.done,
                                  color: Colors.white,
                                  size: 16.0,
                                )
                              : null,
                          radius: 14.0,
                          backgroundColor: (index == 0)
                              ? primaryClr
                              : index == 1
                                  ? pinkClr
                                  : orangeClr,
                        ),
                      ),
                    )),
          )
        ],
      ),
    );
  }
}
