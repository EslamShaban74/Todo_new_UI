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
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
    notifyHelper.requestIOSPermissions();
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
      child: ListView.builder(
        scrollDirection: SizeConfig.orientation == Orientation.landscape
            ? Axis.horizontal
            : Axis.vertical,
        itemCount: _taskController.taskList.length,
        itemBuilder: (context, index) {
          var task = _taskController.taskList[index];
          var hour = task.startTime.toString().split(':')[0];
          var minutes = task.startTime.toString().split(':')[1];

          var date = DateFormat.jm().parse(task.startTime!);
          var myTime = DateFormat('HH:mm').format(date);
          NotifyHelper().scheduledNotification(
              int.parse(myTime.toString().split(':')[0]),
              int.parse(myTime.toString().split(':')[1]),
              task);
          return AnimationConfiguration.staggeredList(
            duration: const Duration(milliseconds: 1300),
            position: index,
            child: SlideAnimation(
              horizontalOffset: 300,
              child: FadeInAnimation(
                child: GestureDetector(
                  onTap: _showBottomSheet(context, task),
                  child: TaskTile(task),
                ),
              ),
            ),
          );
        },
      ),
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

  _buildBottomSheet(
      {required String label,
      required Function() onTap,
      required Color color,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : color,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : color,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titleStyle
                : titleStyle.copyWith(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }

  _showBottomSheet(context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.6
                : SizeConfig.screenHeight * 0.8)
            : (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.30
                : SizeConfig.screenHeight * 0.39),
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(
          children: [
            Flexible(
              child: Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                ),
              ),
            ),
            const SizedBox(height: 20),
            task.isCompleted == 1
                ? Container()
                : _buildBottomSheet(
                    label: 'Task completed',
                    onTap: () {},
                    color: primaryClr,
                  ),
            _buildBottomSheet(
              label: 'Delete Task',
              onTap: () {},
              color: primaryClr,
            ),
            Divider(color: Get.isDarkMode ? Colors.grey : darkGreyClr),
            _buildBottomSheet(
              label: 'Cancel ',
              onTap: () {
                Get.back();
              },
              color: primaryClr,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ));
  }
}
