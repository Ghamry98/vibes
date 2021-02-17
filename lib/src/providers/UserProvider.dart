import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibes/config/ErrorHandler.dart';
import 'package:vibes/src/blocs/IconsBloc.dart';
import 'package:vibes/src/models/CustomResponse.dart';
import 'package:vibes/src/models/Feed.dart';
import 'package:vibes/src/models/Media.dart';
import 'package:vibes/src/models/NotificationSettings.dart';
import 'package:vibes/src/models/User.dart';
import 'package:vibes/src/models/AppSettings.dart';
import 'package:vibes/src/providers/BaseProvider.dart';
import 'package:vibes/src/providers/BookmarksProvider.dart';
import 'package:vibes/src/providers/CountriesProvider.dart';
import 'package:vibes/src/providers/NotificationsProvider.dart';
import 'package:vibes/src/providers/PostsProvider.dart';
import 'package:vibes/src/services/AuthenticationService.dart';
import 'package:vibes/utils/Constants.dart';
import 'package:vibes/utils/Helpers.dart';
import 'package:vibes/config/RequestInterceptors.dart';
import 'package:vibes/config/SetupLocator.dart';

class UserProvider extends BaseProvider {
  final AuthenticationService authService = locator<AuthenticationService>();
  final SharedPreferences sharedPrefs = locator<SharedPreferences>();
  RequestInterceptors interceptors = locator<RequestInterceptors>();
  final IconsBloc iconsBloc = locator<IconsBloc>();
  final FirebaseMessaging _firebaseMessaging = locator<FirebaseMessaging>();

  static AppSettings _userSettings = AppSettings.primary();
  static User _user;
  static Position _currentLocation;
  static String _currentCountry;

  bool loginGuest() {
    try {
      _user = User.simple(
        -1,
        "Guest",
        null,
        UserRole.guest,
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      setState(ViewState.busy);
      var response = await authService.loginUser(email, password);
      if (response.isSuccess) {
        _user = response.data[0];
        sharedPrefs.setString(Constants.tokenKey, response.data[1]);
        interceptors.setInterceptors();

        notifyListeners();

        await Future.wait([
          fetchUserSettings(),
          updateFcmToken(),
        ]);
      }
      setState(ViewState.idle);

      return response.isSuccess;
    } catch (e) {
      if (state != ViewState.idle) {
        setState(ViewState.idle);
      }
      return false;
    }
  }

  Future<bool> socialLogin(
      SocialLoginType socialLoginType, BuildContext context) async {
    try {
      setState(ViewState.busy);

      var socialResponse = await _socialAuthorization(socialLoginType, context);

      if (socialResponse.isSuccess) {
        var response = await authService.socialLogin(
          socialResponse.data,
          socialLoginType,
        );

        if (response.isSuccess) {
          _user = response.data[0];
          sharedPrefs.setString(Constants.tokenKey, response.data[1]);
          interceptors.setInterceptors();

          notifyListeners();

          updateFcmToken();

          // Reg
          if (_user.isActive == null) {
            String currentLanguageCode = appLocale.languageCode;

            updateUserSettings(currentLanguageCode);

            // login
          } else {
            await fetchUserSettings();
          }
        }

        setState(ViewState.idle);
        return response.isSuccess;
      }

      setState(ViewState.idle);
      return false;
    } catch (e) {
      if (state != ViewState.idle) {
        setState(ViewState.idle);
      }
      return false;
    }
  }

  Future<CustomResponse> _socialAuthorization(
      SocialLoginType socialLoginType, BuildContext context) async {
    try {
      switch (socialLoginType) {
        case SocialLoginType.facebook:
          return await authService.facebookAuthorization();
        case SocialLoginType.google:
          return await authService.googleAuthorization();
        case SocialLoginType.twitter:
          return await authService.twitterAuthorization(context);
        default:
          return CustomResponse.error();
      }
    } catch (e) {
      return CustomResponse.error();
    }
  }

  Future<bool> updateFcmToken({String newToken}) async {
    try {
      String fcmToken;

      if (newToken == null) {
        // Get FCM Token
        fcmToken = await _firebaseMessaging.getToken();
      } else {
        fcmToken = newToken;
      }

      if (fcmToken != null) {
        var response = await authService.updateUserFcmToken(_user.id, fcmToken);

        return response.isSuccess;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> fetchUserSettings() async {
    try {
      setState(ViewState.busy);
      var response = await authService.getUserSettings(_user.id);
      if (response.isSuccess && response.data != null) {
        AppSettings appSettings = response.data;

        changeSettings(appSettings);
      }
      setState(ViewState.idle);

      return response.isSuccess;
    } catch (e) {
      if (state != ViewState.idle) {
        setState(ViewState.idle);
      }
      return false;
    }
  }

  Future<bool> updateUserSettings(String languageCode) async {
    try {
      AppSettings appSettings = new AppSettings(Locale(languageCode), theme);

      setState(ViewState.busy);
      var response = await authService.setUserSettings(_user.id, appSettings);

      if (response.isSuccess) {
        changeSettings(appSettings);
      }
      setState(ViewState.idle);

      return response.isSuccess;
    } catch (e) {
      if (state != ViewState.idle) {
        setState(ViewState.idle);
      }
      return false;
    }
  }

  Future<bool> updateNotificationSettings(NotificationSettings settings) async {
    try {
      NotificationSettings temp = _user.notificationSettings;
      _user.notificationSettings = settings;

      notifyListeners();

      var response =
          await authService.setNotificationSettings(_user.id, settings);

      if (!response.isSuccess) {
        _user.notificationSettings = temp;
      }
      notifyListeners();

      return response.isSuccess;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatePassword(String password) async {
    try {
      setState(ViewState.busy);
      var response = await authService.changePassword(password);
      if (response.isSuccess) {
        _user = response.data[0];
        sharedPrefs.setString(Constants.tokenKey, response.data[1]);
        interceptors.setInterceptors();
      }
      setState(ViewState.idle);

      return response.isSuccess;
    } catch (e) {
      if (state != ViewState.idle) {
        setState(ViewState.idle);
      }
      return false;
    }
  }

  Future<CustomResponse> register(
      String email, String username, String password) async {
    try {
      setState(ViewState.busy);
      var response = await authService.registerUser(email, username, password);
      if (response.isSuccess) {
        _user = response.data[0];
        sharedPrefs.setString(Constants.tokenKey, response.data[1]);
        interceptors.setInterceptors();

        Future.wait([
          updateUserSettings(appLocale.languageCode),
          updateFcmToken(),
        ]);
      }
      setState(ViewState.idle);

      return response;
    } catch (e) {
      if (state != ViewState.idle) {
        setState(ViewState.idle);
      }
      return new CustomResponse.error();
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      setState(ViewState.busy);
      var response = await authService.resetPassword(email);
      setState(ViewState.idle);

      return response.isSuccess;
    } catch (e) {
      if (state != ViewState.idle) {
        setState(ViewState.idle);
      }
      return false;
    }
  }

  Future<String> uploadFile(File file) async {
    try {
      return await authService.uploadFile(file);
    } catch (e) {
      return null;
    }
  }

  Future<bool> fetchUserData() async {
    try {
      String token = sharedPrefs.getString(Constants.tokenKey);

      if (token != null && token.isNotEmpty) {
        setState(ViewState.busy);
        var userObject = Helpers.parseJwt(token);

        if (userObject != null && userObject["id"] != null) {
          setState(ViewState.busy);
          var response = await authService.getUserData(userObject["id"] as int);

          if (response.isSuccess) {
            _user = response.data;

            await fetchUserSettings();
          }

          setState(ViewState.idle);
          return response.isSuccess;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      if (state != ViewState.idle) {
        setState(ViewState.idle);
      }
      return false;
    }
  }

  Future<bool> verifyToken({bool listenOnFcmTokenRefresh = false}) async {
    try {
      String token = sharedPrefs.getString(Constants.tokenKey);

      if (token != null && token.isNotEmpty) {
        setState(ViewState.busy);
        var userObject = Helpers.parseJwt(token);

        if (userObject != null && userObject["id"] != null) {
          var response =
              await authService.getUserSettings(userObject["id"] as int);

          if (response.isSuccess) {
            await fetchUserData();
          } else {
            if (response.error == ErrorType.unauthorized) {
              logout();
              return false;
            }
          }

          setState(ViewState.idle);

          return true;
        } else {
          logout();
          return false;
        }
      } else {
        logout();
        return false;
      }
    } catch (e) {
      // logout();
      if (state != ViewState.idle) {
        setState(ViewState.idle);
      }
      return false;
    }
  }

  Future<User> fetchUserById(int userId) async {
    try {
      var response = await authService.getUserData(userId);

      return response.data;
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateUserBio(String bio) async {
    try {
      String temp = _user.bio;
      _user.bio = bio;
      notifyListeners();

      var response = await authService.updateUserBio(_user.id, bio);

      if (!response.isSuccess) {
        _user.bio = temp;
        notifyListeners();
      }

      return response.isSuccess;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUserAvatar(File image) async {
    try {
      var newAvatar = new Media.localFile(image, MediaType.image);

      if (!newAvatar.isImage || !newAvatar.isFileValid) {
        return false;
      }
      Media temp = _user.avatar;
      _user.avatar = newAvatar;
      notifyListeners();

      String url = await authService.uploadFile(newAvatar.localFile);

      if (url == null) {
        _user.avatar = temp;
        notifyListeners();
        return false;
      } else {
        newAvatar.url = url;
      }

      var response =
          await authService.updateUserAvatar(_user.id, newAvatar.url);

      if (!response.isSuccess) {
        _user.avatar = temp;
      } else {
        _user.avatar.url = newAvatar.url;
      }
      notifyListeners();

      return response.isSuccess;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deactivateAccount() async {
    try {
      bool value = false;

      bool temp = _user.isActive;
      _user.isActive = value;
      notifyListeners();

      var response = await authService.activateAccount(_user.id, value);

      if (!response.isSuccess) {
        _user.isActive = temp;
        notifyListeners();
      }

      return response.isSuccess;
    } catch (e) {
      return false;
    }
  }

  Future<bool> activateAccount() async {
    try {
      bool value = true;

      bool temp = _user.isActive;
      _user.isActive = value;

      setState(ViewState.busy);
      var response = await authService.activateAccount(_user.id, value);

      if (!response.isSuccess) {
        _user.isActive = temp;
      }
      setState(ViewState.idle);

      return response.isSuccess;
    } catch (e) {
      if (state != ViewState.idle) {
        setState(ViewState.idle);
      }
      return false;
    }
  }

  Future<bool> updatePrivacy(bool isPrivate) async {
    try {
      bool temp = _user.isPrivate;
      _user.isPrivate = isPrivate;
      notifyListeners();

      var response = await authService.updatePrivacy(_user.id, isPrivate);

      if (!response.isSuccess) {
        _user.isPrivate = temp;
        notifyListeners();
      }

      return response.isSuccess;
    } catch (e) {
      return false;
    }
  }

  Future<bool> fetchAllFeed() async {
    try {
      List<Feed> res = await authService.getAllUserFeed(_user.id);

      _user.allFeeds = res;
      notifyListeners();

      if (res == null) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> fetchAllPosts() async {
    try {
      List<Feed> res = await authService.getPostsByUserId(_user.id);

      _user.posts = res;
      notifyListeners();

      if (res == null) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> fetchAllComments() async {
    try {
      List<Feed> res = await authService.getAllUserComments(_user.id);

      _user.comments = res;
      notifyListeners();

      if (res == null) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> fetchAllInteractions() async {
    try {
      List<Feed> res = await authService.getAllUserInteractions(_user.id);

      _user.interactions = res;
      notifyListeners();

      if (res == null) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> fetchUserFeeds(User author) async {
    try {
      List<Feed> res = await authService.getAllUserFeed(author.id);

      author.allFeeds = res;
      notifyListeners();

      if (res == null) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> fetchUserPosts(User author) async {
    try {
      List<Feed> res = await authService.getPostsByUserId(author.id);

      author.posts = res;
      notifyListeners();

      if (res == null) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> fetchUserComments(User author) async {
    try {
      List<Feed> res = await authService.getAllUserComments(author.id);

      author.comments = res;
      notifyListeners();

      if (res == null) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> fetchUserInteractions(User author) async {
    try {
      List<Feed> res = await authService.getAllUserInteractions(author.id);

      author.interactions = res;
      notifyListeners();

      if (res == null) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await Future.wait([
        authService.socialLogout(),
        _firebaseMessaging.deleteInstanceID(),
      ]);

      sharedPrefs.setString(Constants.tokenKey, null);
      sharedPrefs.setBool(Constants.showHomePageTooltipKey, true);
      interceptors.clearInterceptors();
      iconsBloc.clearData();

      _user = null;

      PostsProvider.clearData();
      BookmarksProvider.clearData();
      CountriesProvider.clearData();
      NotificationsProvider.clearData();

      notifyListeners();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> fetchCountry() async {
    bool res = await fetchCountryFromGPS();
    if (!res) {
      res = await fetchCountryFromIP();
    }
  }

  Future<bool> fetchCountryFromGPS() async {
    try {
      _currentLocation = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      List<Placemark> addresses =
          await Geolocator().placemarkFromPosition(_currentLocation);

      if (addresses != null && addresses.isNotEmpty) {
        _currentCountry = addresses[0].isoCountryCode;
      }
      if (_currentLocation != null && _currentCountry != null) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> fetchCountryFromIP() async {
    _currentCountry = await authService.getCountryFromIP();

    if (_currentCountry != null) {
      return true;
    }
    return false;
  }

  void fetchSettings() {
    _fetchLanguage();
    _fetchTheme();

    notifyListeners();
  }

  void _fetchLanguage() {
    String storedLanguageCode = sharedPrefs.getString(Constants.languageKey);
    if (storedLanguageCode != null) {
      _userSettings.language = Locale(storedLanguageCode);
    } else {
      _userSettings.language = AppSettings.getLanguage("en");
      sharedPrefs.setString(Constants.languageKey, "en");
    }
  }

  void _fetchTheme() {
    String storedTheme = sharedPrefs.getString(Constants.themeKey);
    if (storedTheme != null) {
      _userSettings.theme = AppSettings.getTheme(storedTheme);
    } else {
      _userSettings.theme = UserTheme.light;
      sharedPrefs.setString(Constants.themeKey,
          _userSettings.theme.toString().replaceFirst("UserTheme.", ""));
    }
  }

  bool changeSettings(AppSettings settings) {
    try {
      bool res1, res2;

      if (settings.language != null) {
        res1 = changeLanguage(settings.language);
      }

      if (settings.theme != null) {
        res2 = _changeTheme(settings.theme);
      }

      return res1 && res2;
    } catch (e) {
      return false;
    }
  }

  bool changeLanguage(Locale language) {
    try {
      if (_userSettings.language.languageCode == language.languageCode) {
        return false;
      } else {
        _userSettings.language = language;
        sharedPrefs.setString(Constants.languageKey, language.languageCode);

        notifyListeners();
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  bool _changeTheme(UserTheme theme) {
    try {
      if (_userSettings.theme == theme) {
        return false;
      } else {
        _userSettings.theme = theme;
        sharedPrefs.setString(Constants.themeKey,
            theme.toString().replaceFirst("UserTheme.", ""));
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  bool shouldShowAddPostTooltip() {
    try {
      bool showTooltip = sharedPrefs.getBool(Constants.showHomePageTooltipKey);

      if (showTooltip != null) {
        if (user == null || user.role == UserRole.guest) {
          sharedPrefs.setBool(Constants.showHomePageTooltipKey, true);
        } else {
          sharedPrefs.setBool(Constants.showHomePageTooltipKey, false);
        }

        return showTooltip;
      } else {
        if (user == null || user.role == UserRole.guest) {
          sharedPrefs.setBool(Constants.showHomePageTooltipKey, true);
        } else {
          sharedPrefs.setBool(Constants.showHomePageTooltipKey, false);
        }
        return true;
      }
    } catch (e) {
      return true;
    }
  }

  AppSettings get appSettings => _userSettings ?? AppSettings.primary();
  NotificationSettings get notificationSettings =>
      _user != null && _user.notificationSettings != null
          ? _user.notificationSettings
          : null;

  Locale get appLocale =>
      appSettings.language != null ? appSettings.language : Locale('en');

  UserTheme get theme =>
      appSettings.theme != null ? appSettings.theme : UserTheme.light;

  User get user => _user;
  String get currentCountry => _currentCountry;
  Position get currentLocation => _currentLocation;
}
