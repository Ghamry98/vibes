import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:vibes/src/blocs/IconsBloc.dart';
import 'package:vibes/utils/Constants.dart';
import 'package:vibes/config/RequestInterceptors.dart';

/// Returns the previously registered app providers and services.
GetIt locator = GetIt.instance;

/// This method is responsible for the dependency injection, where it defines, configures, and registers the app providers and services.
Future<void> setupLocator() async {
  // SharedPrefs
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);

  // Dio for API calls and interceptors
  Dio dio = _setDio();
  locator.registerLazySingleton(() => dio);

  RequestInterceptors interceptors = RequestInterceptors();
  interceptors.setInterceptors();
  locator.registerLazySingleton(() => interceptors);

  // Configuring notifications
  FirebaseMessaging _firebaseMessaging = _configureFCM();
  final IconsBloc _iconsBloc = new IconsBloc();
  locator.registerLazySingleton(() => _firebaseMessaging);
  locator.registerLazySingleton(() => _iconsBloc);

  // Google translate
  GoogleTranslator _translator = GoogleTranslator();
  locator.registerLazySingleton(() => _translator);
}

Dio _setDio() {
  // Setting network options
  BaseOptions options = new BaseOptions(
    baseUrl: Constants.baseUrl,
    connectTimeout: Constants.requestTimeout,
    receiveTimeout: Constants.requestTimeout,
  );

  Dio dio = new Dio(options);

  return dio;
}

FirebaseMessaging _configureFCM() {
  // Setting FCM permissions
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  _firebaseMessaging.requestNotificationPermissions(
    const IosNotificationSettings(sound: true, badge: true, alert: true),
  );

  return _firebaseMessaging;
}
