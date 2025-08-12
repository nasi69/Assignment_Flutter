import 'package:flutter/material.dart';
import 'package:flutter_application_3/student_module/student_font_logic.dart';
import 'package:flutter_application_3/student_module/student_screen.dart';
import 'package:flutter_application_3/student_module/student_theme_logic.dart';
import 'package:provider/provider.dart';

class StudentApp extends StatelessWidget {
  double _size = 0;

  @override
  Widget build(BuildContext context) {
    _size = context.watch<StudentFontLogic>().size;

    int themeIndex = context.watch<StudentThemeLogic>().themeIndex;
    ThemeMode mode = ThemeMode.system;
    switch (themeIndex) {
      case 1:
        mode = ThemeMode.dark;
        break;
      case 2:
        mode = ThemeMode.light;
        break;
      default:
        mode = ThemeMode.system;
    }
    return MaterialApp(
      home: StudentScreen(),
      themeMode: mode,
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
    );
  }

  ThemeData _lightTheme() {
    Color col1 = Color.fromARGB(243, 197, 19, 19);
    return ThemeData(
      brightness: Brightness.light,
      textTheme: TextTheme(bodyMedium: TextStyle(fontSize: _size)),
      listTileTheme: ListTileThemeData(
        textColor: Colors.black,
        iconColor: col1,
        titleTextStyle: TextStyle(fontSize: _size),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: col1,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: col1,
        unselectedItemColor: Colors.grey,
      ),
      drawerTheme: DrawerThemeData(backgroundColor: Colors.white),
    );
  }

  ThemeData _darkTheme() {
    Color col1 = Colors.red;
    return ThemeData(
      brightness: Brightness.dark,
      textTheme: TextTheme(bodyMedium: TextStyle(fontSize: _size)),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: col1,
        unselectedItemColor: Colors.grey,
      ),
      drawerTheme: DrawerThemeData(backgroundColor: Colors.black),
      listTileTheme: ListTileThemeData(
        textColor: Colors.white,
        iconColor: col1,
        titleTextStyle: TextStyle(fontSize: _size),
      ),
    );
  }
}