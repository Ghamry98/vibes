import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vibes/config/Router.dart';
import 'package:vibes/config/Themes.dart';
import 'package:flutter/material.dart';
import 'package:vibes/src/providers/UserProvider.dart';
import 'package:vibes/src/views/BaseView.dart';
import 'package:vibes/config/AppLocalizations.dart';
import 'package:vibes/config/SetupLocator.dart';
import 'package:oktoast/oktoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return BaseView<UserProvider>(
      onModelReady: (provider) {
        // Fetching app settigns (locale and theme)
        provider.fetchSettings();
      },
      builder: (BuildContext context, UserProvider userProvider, Widget child) {
        return OKToast(
          child: ExcludeSemantics(
            child: MaterialApp(
              title: 'Vibes',
              initialRoute: '/',
              onGenerateRoute: Router.generateRoute,
              debugShowCheckedModeBanner: false,
              theme: Themes.lightTheme,
              darkTheme: Themes.darkTheme,
              locale: userProvider.appLocale,
              supportedLocales: [
                Locale('en'),
                Locale('ar'),
                Locale('de'),
                Locale('fr'),
                Locale('it'),
                Locale('es'),
                Locale('hi'),
                Locale('ru'),
                Locale('tr'),
                Locale('zh', 'CN'),
                Locale('ja'),
              ],
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              builder: (BuildContext context, Widget page) {
                return SafeArea(child: page);
              },
            ),
          ),
        );
      },
    );
  }
}
