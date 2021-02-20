import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vibes/config/ThemeColors.dart';

class Themes {
  /// Returns the main app light theme.
  static ThemeData get lightTheme => ThemeData(
        fontFamily: 'Montserrat',
        brightness: Brightness.light,
        primaryColor: ThemeColors.primaryColor(1),
        scaffoldBackgroundColor: ThemeColors.scaffoldColor(1),
        accentColor: ThemeColors.redColor(1),
        primaryColorLight: ThemeColors.blueColor(1),
        indicatorColor: ThemeColors.lightRedColor(1),
        focusColor: ThemeColors.focusColor(1),
        unselectedWidgetColor: ThemeColors.focusColor(1),
        dividerColor: ThemeColors.dividerColor(1),
        hintColor: ThemeColors.textPrimaryColor(1),
        secondaryHeaderColor: ThemeColors.textSecondaryColor(1),
        buttonColor: ThemeColors.blueColor(1),
        textTheme: TextTheme(
          button: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            letterSpacing: 0.25,
            fontWeight: FontWeight.w600,
          ),
          headline1: TextStyle(
            fontSize: 34.0,
            letterSpacing: 0.25,
            color: ThemeColors.textPrimaryColor(1),
          ),
          headline2: TextStyle(
            fontSize: 28.0,
            letterSpacing: 0.25,
            color: ThemeColors.textPrimaryColor(1),
          ),
          headline3: TextStyle(
            fontSize: 24.0,
            letterSpacing: 0.25,
            color: ThemeColors.textPrimaryColor(1),
          ),
          headline4: TextStyle(
            fontSize: 22.0,
            letterSpacing: 0.25,
            color: ThemeColors.textPrimaryColor(1),
          ),
          headline5: TextStyle(
            fontSize: 20.0,
            letterSpacing: 0.25,
            color: ThemeColors.textPrimaryColor(1),
          ),
          headline6: TextStyle(
            fontSize: 18.0,
            letterSpacing: 0.25,
            color: ThemeColors.textPrimaryColor(1),
          ),
          bodyText1: TextStyle(
            fontSize: 16.0,
            letterSpacing: 0.25,
            color: ThemeColors.textPrimaryColor(1),
          ),
          bodyText2: TextStyle(
            fontSize: 14.0,
            letterSpacing: 0.25,
            color: ThemeColors.textPrimaryColor(1),
          ),
          caption: TextStyle(
            fontSize: 12.0,
            letterSpacing: 0.25,
            color: ThemeColors.textPrimaryColor(1),
          ),
          subtitle1: TextStyle(
            fontSize: 10.0,
            letterSpacing: 0.25,
            color: ThemeColors.textPrimaryColor(1),
          ),
          subtitle2: TextStyle(
            fontSize: 8.0,
            letterSpacing: 0.25,
            color: ThemeColors.textPrimaryColor(1),
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: ThemeColors.blueColor(1),
          disabledColor: ThemeColors.inactiveColor(1),
        ),
        appBarTheme: AppBarTheme(color: ThemeColors.scaffoldColor(1)),
        iconTheme: IconThemeData(color: ThemeColors.textPrimaryColor(1)),
        tooltipTheme: TooltipThemeData(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
            color: ThemeColors.blueColor(1),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        tabBarTheme: TabBarTheme(
          labelStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
          labelColor: ThemeColors.redColor(1),
          unselectedLabelColor: ThemeColors.focusColor(1),
        ),
        cupertinoOverrideTheme: CupertinoThemeData(
          primaryColor: ThemeColors.redColor(1),
          barBackgroundColor: ThemeColors.textPrimaryColor(1),
        ),
      );

  /// Returns the main app dark theme.
  static ThemeData get darkTheme => ThemeData(
        fontFamily: 'Montserrat',
        brightness: Brightness.dark,
        primaryColor: ThemeColors.primaryDarkColor(1),
        scaffoldBackgroundColor: ThemeColors.scaffoldDarkColor(1),
        accentColor: ThemeColors.redColor(1),
        primaryColorLight: ThemeColors.blueColor(1),
        indicatorColor: ThemeColors.darkRedColor(1),
        focusColor: ThemeColors.focusDarkColor(1),
        unselectedWidgetColor: ThemeColors.inactiveDarkColor(1),
        dividerColor: ThemeColors.dividerDarkColor(1),
        hintColor: ThemeColors.textPrimaryDarkColor(1),
        secondaryHeaderColor: ThemeColors.textSecondaryDarkColor(1),
        buttonColor: ThemeColors.blueColor(1),
        textTheme: TextTheme(
          button: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            letterSpacing: 0.25,
            fontWeight: FontWeight.w600,
          ),
          headline1: TextStyle(
            fontSize: 34.0,
            letterSpacing: 0.25,
            color: ThemeColors.textPrimaryDarkColor(1),
          ),
          headline2: TextStyle(
            fontSize: 28.0,
            letterSpacing: 0.25,
            color: ThemeColors.textPrimaryDarkColor(1),
          ),
          headline3: TextStyle(
            fontSize: 24.0,
            letterSpacing: 0.25,
            color: ThemeColors.textPrimaryDarkColor(1),
          ),
          headline4: TextStyle(
            fontSize: 22.0,
            letterSpacing: 0.25,
            color: ThemeColors.textPrimaryDarkColor(1),
          ),
          headline5: TextStyle(
            fontSize: 20.0,
            letterSpacing: 0.25,
            color: ThemeColors.textPrimaryDarkColor(1),
          ),
          headline6: TextStyle(
            fontSize: 18.0,
            letterSpacing: 0.25,
            color: ThemeColors.textPrimaryDarkColor(1),
          ),
          bodyText1: TextStyle(
            fontSize: 16.0,
            letterSpacing: 0.25,
            color: ThemeColors.textPrimaryDarkColor(1),
          ),
          bodyText2: TextStyle(
            fontSize: 14.0,
            letterSpacing: 0.25,
            color: ThemeColors.textPrimaryDarkColor(1),
          ),
          caption: TextStyle(
            fontSize: 12.0,
            letterSpacing: 0.25,
            color: ThemeColors.textPrimaryDarkColor(1),
          ),
          subtitle1: TextStyle(
            fontSize: 10.0,
            letterSpacing: 0.25,
            color: ThemeColors.textPrimaryDarkColor(1),
          ),
          subtitle2: TextStyle(
            fontSize: 8.0,
            letterSpacing: 0.25,
            color: ThemeColors.textPrimaryDarkColor(1),
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: ThemeColors.blueColor(1),
          disabledColor: ThemeColors.inactiveDarkColor(1),
        ),
        appBarTheme: AppBarTheme(color: ThemeColors.scaffoldDarkColor(1)),
        iconTheme: IconThemeData(color: ThemeColors.textPrimaryColor(1)),
        tooltipTheme: TooltipThemeData(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
            color: ThemeColors.blueColor(1),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        tabBarTheme: TabBarTheme(
          labelStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
          labelColor: ThemeColors.redColor(1),
          unselectedLabelColor: ThemeColors.textSecondaryDarkColor(1),
        ),
        cupertinoOverrideTheme: CupertinoThemeData(
          primaryColor: ThemeColors.redColor(1),
          barBackgroundColor: ThemeColors.inactiveDarkColor(1),
        ),
      );
}
