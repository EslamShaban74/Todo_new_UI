import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/services/notification_services.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/pages/add_task_page.dart';
import 'package:todo/ui/size_config.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo/ui/widgets/task_tile.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();

  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIosPermission();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(height: 6),
          _showTasks(),
        ],
      ),
    );
  }

  AppBar _appBar() => AppBar(
        elevation: 0.0,
        backgroundColor: context.theme.backgroundColor,
        leading: IconButton(
          icon: Icon(
            Get.isDarkMode
                ? Icons.wb_sunny_outlined
                : Icons.nightlight_round_outlined,
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
            size: 20,
          ),
          onPressed: () {
            ThemeServices().switchTheme();
            notifyHelper.displayNotification(title: 'title', body: 'body');
          },
        ),
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/person.jpeg'),
          ),
          SizedBox(width: 20.0),
        ],
      );

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat.yMMMMd().format(_selectedDate),
                  style: subHeadingStyle),
              Text('Today', style: titleStyle),
            ],
          ),
          MyButton(
            label: '+ Add Task',
            onTap: () async {
              await Get.to(() => const AddTaskPage());
              _taskController.getTasks();
            },
          ),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, top: 6.0),
      child: DatePicker(
        DateTime.now(),
        width: 70,
        height: 100,
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        selectionColor: primaryClr,
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
        selectedTextColor: Colors.white,
        initialSelectedDate: DateTime.now(),
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: TaskTile(Task(
          title: 'title 1 ',
          note: 'No thing to do ',
          startTime: '20:6',
          endTime: '3:20',
          date: 'wed',

          color: 1,
          isCompleted: 0)),
    );
  }

  _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              children: [
                SizeConfig.orientation == Orientation.landscape
                    ? const SizedBox(height: 100.0)
                    : const SizedBox(height: 150),
                SvgPicture.asset(
                  'assets/images/task.svg',
                  height: 100,
                  semanticsLabel: 'tasks',
                  color: primaryClr.withOpacity(0.5),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 15.0),
                  child: Text(
                    'You don\'t have any tasks yet! \n Add new tasks to make your days productive ',
                    style: subTitleStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizeConfig.orientation == Orientation.landscape
                    ? const SizedBox(height: 10)
                    : const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
