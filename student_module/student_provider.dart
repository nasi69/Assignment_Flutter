import 'package:flutter/material.dart';
import 'package:flutter_application_3/student_module/student_app.dart';
import 'package:flutter_application_3/student_module/student_font_logic.dart';
import 'package:flutter_application_3/student_module/student_screen.dart';
import 'package:flutter_application_3/student_module/student_theme_logic.dart';
import 'package:provider/provider.dart';

Widget studentProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => StudentThemeLogic()),
      ChangeNotifierProvider(create: (context)=>StudentFontLogic())
    ],
    child: StudentApp(),
  );
}