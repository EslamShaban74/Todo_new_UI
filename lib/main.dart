import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/pages/home_page.dart';
import 'package:todo/ui/pages/notification_screen.dart';
import 'package:todo/ui/theme.dart';
import 'package:window_size/window_size.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // set default min and max size ,, and start offset of windows app
  ThemeServices().loadThemeFromBox();
  ThemeServices().theme;
  if (Platform.isWindows) {
    setWindowMaxSize(const Size(double.infinity, 768));
    setWindowMinSize(const Size(400, 400));
    Future<void>.delayed(const Duration(seconds: 1), () {
      setWindowFrame(Rect.fromCenter(
          center: const Offset(1000, 500), width: 600, height: 1000));
    });
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      title: 'To do',
      debugShowCheckedModeBanner: false,
      home: const HomePage()
    );
  }
}
