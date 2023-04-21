import 'package:flutter/material.dart';

class MyThemes{
  MyThemes._();

  static ThemeData lightTheme=ThemeData(
    brightness:Brightness.light,
    primarySwatch:Colors.blue,
  );

  static ThemeData darkTheme=ThemeData(
    brightness:Brightness.dark,
    primarySwatch:Colors.blue
  );
}