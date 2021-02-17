import 'package:flutter/material.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    try {
      // Getting arguments passed in while calling Navigator.pushNamed
      final args = settings.arguments;

      switch (settings.name) {
        default:
          return _errorRoute();
      }
    } catch (e) {
      return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('We are sorry, please restart the app.'),
        ),
      );
    });
  }
}
