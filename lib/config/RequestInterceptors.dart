import 'package:vibes/utils/Constants.dart';
import 'package:vibes/config/SetupLocator.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestInterceptors {
  Dio dio = locator<Dio>();
  SharedPreferences sharedPrefs = locator<SharedPreferences>();

  /// Gets the user JWT token from the shared preferences, and set it as an Authorization header for all the upcoming network requests.
  void setInterceptors() {
    SharedPreferences sharedPrefs = locator<SharedPreferences>();

    if (dio.interceptors != null && dio.interceptors.isNotEmpty) {
      dio.interceptors.clear();
    }

    // Adding requests auth interceptor
    String token = sharedPrefs.get(Constants.tokenKey);

    if (token != null) {
      dio.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
        dio.lock();

        options.headers["Authorization"] = "jwt " + token;

        dio.unlock();
        return options;
      }));
    }
  }

  /// Clears all the dio client interceptors.
  void clearInterceptors() {
    if (dio.interceptors != null && dio.interceptors.isNotEmpty) {
      dio.interceptors.clear();
    }
  }
}
