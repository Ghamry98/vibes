import 'package:flutter/material.dart';
import 'package:vibes/src/providers/UserProvider.dart';
import 'package:vibes/src/views/BaseView.dart';

class SplashScreen extends StatelessWidget {
  void _handleRouting(BuildContext context, UserProvider provider) async {
    await provider.verifyToken().then((res) async {
      // get user country
      await provider.fetchCountry();

      // User is logged in
      if (res) {
        // if user should continue its registration
        if (provider.user.isActive == null) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/RegisterConditions',
            (Route<dynamic> route) => false,
          );
          // if the user needs to change his password
        } else if (provider.user.needPasswordChange) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/ChangePassword',
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/MainNavigation',
            (Route<dynamic> route) => false,
          );
        }
        // User is not logged in
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/IntroGuide',
          (Route<dynamic> route) => false,
        );
      }
    }).catchError((err) async {
      // get user country
      await provider.fetchCountry();

      Navigator.of(context).pushNamedAndRemoveUntil(
        '/IntroGuide',
        (Route<dynamic> route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<UserProvider>(
      onModelReady: (provider) => _handleRouting(context, provider),
      builder: (BuildContext context, UserProvider provider, Widget child) {
        return Scaffold(
          body: Center(
            child: Image(
              fit: BoxFit.contain,
              height: 100,
              width: 150,
              image: AssetImage("assets/icons/logo.png"),
            ),
          ),
        );
      },
    );
  }
}
