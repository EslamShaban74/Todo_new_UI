import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/ui/theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.payload}) : super(key: key);
  final String payload;

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late String _payload;

  @override
  void initState() {
    _payload = widget.payload;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RichText text;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _payload.toString().split('|')[0],
          style: TextStyle(
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        elevation: 0.0,
        backgroundColor: context.theme.backgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children: <Widget>[
                text = RichText(
                  text: TextSpan(
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Get.isDarkMode ? Colors.white : darkGreyClr,
                      ),
                      children: const [
                        TextSpan(text: 'Hello, '),
                        TextSpan(
                            text: 'Islam ',
                            style: TextStyle(color: primaryClr)),
                      ]),
                ), // Text(
                //   'Hello, Islam',
                //   style: TextStyle(
                //     fontSize: 26,
                //     fontWeight: FontWeight.w900,
                //     color: Get.isDarkMode ? Colors.white : darkGreyClr,
                //   ),
                // ),
                const SizedBox(height: 10.0),
                Text(
                  'You have a new Reminder',
                  style: TextStyle(
                    fontSize: 18,
                    color: Get.isDarkMode ? Colors.grey[100] : darkGreyClr,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30.0),
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 20.0),
                decoration: BoxDecoration(
                  color: primaryClr,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children:  <Widget>[
                          const Icon(
                            Icons.text_format,
                            size: 30,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 20.0),
                          Text(
                            _payload.toString().split('|')[0],
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20.0),
                      const Text(
                       'Title',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      Row(
                        children:  [
                          const Icon(
                            Icons.description,
                            size: 30,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 20.0),
                          Text(
                            _payload.toString().split('|')[1],
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20.0),
                      Text(
                        _payload.toString().split('|')[1],
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children:  [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 30,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 20.0),
                          Text(
                            _payload.toString().split('|')[2],
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20.0),
                      const Text(
                       'Date',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
