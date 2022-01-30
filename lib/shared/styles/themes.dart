import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_app/shared/components/components.dart';
import 'colors.dart';

ThemeData themeLight = ThemeData(
 // fontFamily: 'Cairo',
  backgroundColor: whiteColor,
  scaffoldBackgroundColor: backgroundColor,
  primaryColor: primaryColor,
  colorScheme: const ColorScheme.light(primary: primaryColor),
  buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
  highlightColor: whiteColor,
  inputDecorationTheme:  InputDecorationTheme(
    hoverColor: primaryColor,
    focusColor: primaryColor,
    prefixStyle: const TextStyle(
      color: primaryColor,
    ),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(width: 0.3, color: secondaryColor)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(width: 0.3, color: secondaryColor)),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(width: 0.3, color: primaryColor)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(width: 0.3, color: primaryColor)),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0.0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: bigTextColor,
      unselectedItemColor: Colors.grey,
      selectedIconTheme: IconThemeData(
        size: 24.0,
      )),
  focusColor: primaryColor,
  appBarTheme: const AppBarTheme(
    backgroundColor:backgroundColor ,
    titleTextStyle: TextStyle(color: bigTextColor,fontSize: 16,fontWeight: FontWeight.bold),
    elevation: 0.0,
    systemOverlayStyle: SystemUiOverlayStyle(
     // statusBarColor: backgroundColor,
     statusBarIconBrightness: Brightness.dark,
    ),
    iconTheme: IconThemeData(
      color: bigTextColor,
    ),
    actionsIconTheme: IconThemeData(
     color: bigTextColor,
    )
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
    elevation: 8.0,
  ),

  textTheme: const TextTheme(
    bodyText1: TextStyle(
        fontSize: 18.0, color: bigTextColor, fontWeight: FontWeight.bold),
    subtitle1: TextStyle(fontSize: 14.0, color: midTextColor),
    subtitle2: TextStyle(fontSize: 12, color: smallTextColor),
  ),
  iconTheme: const IconThemeData(
    color: bigTextColor,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: primaryColor,
  ),
);
