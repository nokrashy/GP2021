import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fristapp/shared/component/constants.dart';

ThemeData darkTheme = ThemeData(
  primarySwatch: defultColor,
  scaffoldBackgroundColor: Colors.grey[850],
  appBarTheme: AppBarTheme(
    // ignore: deprecated_member_use
    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.grey[850],
      statusBarIconBrightness: Brightness.light,
    ),
    backgroundColor: Colors.grey[850],
    elevation: 0.0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: defultColor,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: defultColor,
    backgroundColor: Colors.grey[850],
    selectedIconTheme: IconThemeData(
      color: defultColor,
    ),
    unselectedItemColor: Colors.grey,
    elevation: 20.0,
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 20.0,
      color: Colors.white,
    ),
    subtitle1: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16.0,
        color: Colors.white,
        height: 1.0),
  ),
  fontFamily: 'serif',
);

ThemeData lightTheme = ThemeData(
  primarySwatch: defultColor,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    // ignore: deprecated_member_use
    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
    backgroundColor: Colors.white,
    elevation: 0.0,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: defultColor,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: defultColor,
    elevation: 20.0,
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 20.0,
      color: Colors.black,
    ),
    subtitle1: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16.0,
        color: Colors.black,
        height: 1.0),
  ),
  fontFamily: 'serif',
  //fontFamily: 'timeLine',
);
