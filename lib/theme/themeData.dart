import 'package:flutter/material.dart';

ThemeData Lightmode = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Color(0xfff6f6f6),
    primaryColor: Color(0xff1f968f),
    secondaryHeaderColor: Color(0xff1f968f),
    canvasColor: Colors.black,
    cardColor: Colors.white);

ThemeData Darkmode = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.grey.shade900,
  secondaryHeaderColor: Color(0xff1f968f),
  primaryColor: Color(0xff1f968f),
  canvasColor: Colors.white,
  cardColor: Color(0xff151414),
);
