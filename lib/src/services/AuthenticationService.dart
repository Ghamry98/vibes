import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_auth/twitter_auth.dart';
import 'package:vibes/config/ErrorHandler.dart';
import 'package:vibes/src/models/CustomResponse.dart';
import 'package:vibes/src/models/Feed.dart';
import 'package:vibes/src/models/NotificationSettings.dart';
import 'package:vibes/src/models/User.dart';
import 'package:vibes/src/models/AppSettings.dart';
import 'package:vibes/utils/Constants.dart';
import 'package:vibes/config/SetupLocator.dart';

class AuthenticationService {
  Dio dio = locator<Dio>();

  static final GoogleSignIn _google = GoogleSignIn(scopes: ['email']);
  static final FacebookLogin _facebook = FacebookLogin();
  static final TwitterLogin _twitterAndroid = new TwitterLogin(
    consumerKey: Constants.twitterConsumerApiKey,
    consumerSecret: Constants.twitterSecretApiKey,
  );
  static final TwitterAuth _twitterIOS = TwitterAuth(
    clientId: Constants.twitterConsumerApiKey,
    clientSecret: Constants.twitterSecretApiKey,
    callbackUrl: Constants.twitterRedirectUri,
  );

  Future<CustomResponse> loginUser(String email, String password) async {
    try {
      Response response = await dio.post("/login/", data: {
        "email": email,
        "password": password,
      });

      String token = response.data['data']['token'];
      User user = User.fromJSON(response.data['data']['user']);

      return new CustomResponse.success(data: [user, token]);
    } catch (e) {
      return new CustomResponse.error();
    }
  }

  Future<CustomResponse> socialLogin(
      String accessToken, SocialLoginType socialLoginType) async {
    try {
      Response response = await dio.post(
          "/social/" +
              socialLoginType.toString().replaceAll("SocialLoginType.", "") +
              "/",
          data: {
            "secret_key": accessToken,
          });

      String token = response.data['data']['token'];
      User user = User.fromJSON(response.data['data']['user']);

      return new CustomResponse.success(data: [user, token]);
    } catch (e) {
      return new CustomResponse.error();
    }
  }

  Future<CustomResponse> socialLogout() async {
    try {
      // await _twitter.logOut();
      await _google.signOut();
      await _facebook.logOut();

      return CustomResponse.success();
    } catch (e) {
      return new CustomResponse.error();
    }
  }

  Future<CustomResponse> facebookAuthorization() async {
    try {
      final FacebookLoginResult result = await _facebook.logIn(['email']);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final token = result.accessToken.token;
          return new CustomResponse.success(data: token);
        case FacebookLoginStatus.cancelledByUser:
          return CustomResponse.error();
        case FacebookLoginStatus.error:
          return CustomResponse.error();
      }

      return CustomResponse.error();
    } catch (e) {
      return new CustomResponse.error();
    }
  }

  Future<CustomResponse> googleAuthorization() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await _google.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth != null &&
          googleAuth.accessToken != null &&
          googleAuth.idToken != null) {
        return new CustomResponse.success(data: googleAuth.accessToken);
      }

      return CustomResponse.error();
    } catch (e) {
      return new CustomResponse.error();
    }
  }

  Future<CustomResponse> twitterAuthorization(BuildContext context) async {
    try {
      if (Platform.isIOS) {
        FlutterAuthResult resp = await _twitterIOS.login(context);
        return new CustomResponse.success(data: resp.token);
      } else {
        final TwitterLoginResult result = await _twitterAndroid.authorize();

        switch (result.status) {
          case TwitterLoginStatus.loggedIn:
            return new CustomResponse.success(data: result.session.token);
          case TwitterLoginStatus.cancelledByUser:
            return CustomResponse.error();
          case TwitterLoginStatus.error:
            return CustomResponse.error();
        }
      }
      return CustomResponse.error();
    } catch (e) {
      return new CustomResponse.error();
    }
  }

  Future<CustomResponse> changePassword(String password) async {
    try {
      Response response = await dio.post("/change_password", data: {
        "new_password": password,
      });

      String token = response.data['data']['token'];
      User user = User.fromJSON(response.data['data']['user']);

      return new CustomResponse.success(data: [user, token]);
    } catch (e) {
      return new CustomResponse.error();
    }
  }

  Future<CustomResponse> getUserSettings(int userId) async {
    try {
      Response response =
          await dio.get("/user/" + userId.toString() + "/setting");

      AppSettings appSettings = AppSettings.fromJSON(response.data);

      return new CustomResponse.success(data: appSettings);
    } on DioError catch (e) {
      if (e != null && e.response != null) {
        return new CustomResponse.error(
          error: e.response.statusCode == 401
              ? ErrorType.unauthorized
              : ErrorType.basic,
        );
      } else {
        return new CustomResponse.error();
      }
    } catch (e) {
      return new CustomResponse.error();
    }
  }

  Future<CustomResponse> setUserSettings(
      int userId, AppSettings settings) async {
    try {
      await dio.post(
        "/user/" + userId.toString() + "/setting",
        data: settings.toMap(),
      );

      return new CustomResponse.success();
    } catch (e) {
      return new CustomResponse.error();
    }
  }

  Future<CustomResponse> setNotificationSettings(
      int userId, NotificationSettings settings) async {
    try {
      await dio.put(
        "/user/" + userId.toString() + "/",
        data: settings.toMap(),
      );

      return new CustomResponse.success();
    } catch (e) {
      return new CustomResponse.error();
    }
  }

  Future<CustomResponse> activateAccount(int userId, bool value) async {
    try {
      await dio.put(
        "/user/" + userId.toString() + "/",
        data: {"active": value},
      );

      return new CustomResponse.success();
    } catch (e) {
      return new CustomResponse.error();
    }
  }

  Future<CustomResponse> updatePrivacy(int userId, bool isPrivate) async {
    try {
      await dio.put(
        "/user/" + userId.toString() + "/",
        data: {"is_private": isPrivate},
      );

      return new CustomResponse.success();
    } catch (e) {
      return new CustomResponse.error();
    }
  }

  Future<CustomResponse> registerUser(
      String email, String username, String password) async {
    try {
      Response response = await dio.post("/signup", data: {
        "email": email,
        "username": username,
        "password": password,
      });

      String token = response.data['data']['token'];
      User user = User.fromJSON(response.data['data']['user']);

      return new CustomResponse.success(data: [user, token]);
    } on DioError catch (e) {
      if (e.response.data != null && e.response.data["error"] != null) {
        if (e.response.data["error"]["email"] != null) {
          return new CustomResponse.error(error: ErrorType.reg_email);
        } else if (e.response.data["error"]["username"] != null) {
          return new CustomResponse.error(error: ErrorType.reg_username);
        } else {
          return new CustomResponse.error();
        }
      }

      return new CustomResponse.error();
    } catch (e) {
      return new CustomResponse.error();
    }
  }

  Future<CustomResponse> resetPassword(String email) async {
    try {
      await dio.post("/reset_password", data: {
        "email": email,
      });

      return new CustomResponse.success();
    } catch (e) {
      return new CustomResponse.error();
    }
  }

  Future<CustomResponse> getUserData(int id) async {
    try {
      Response response = await dio.get("/users/" + id.toString());

      User user = User.fromJSON(response.data["data"]);

      return new CustomResponse.success(data: user);
    } catch (e) {
      return new CustomResponse.error();
    }
  }

  Future<CustomResponse> updateUserBio(int id, String bio) async {
    try {
      await dio.put("/user/" + id.toString() + "/", data: {"bio": bio});

      return new CustomResponse.success();
    } catch (e) {
      return new CustomResponse.error();
    }
  }

  Future<CustomResponse> updateUserAvatar(int id, String avatar) async {
    try {
      await dio.put("/user/" + id.toString() + "/", data: {"avatar": avatar});

      return new CustomResponse.success();
    } catch (e) {
      return new CustomResponse.error();
    }
  }

  Future<CustomResponse> updateUserFcmToken(int id, String token) async {
    try {
      await dio.put(
        "/user/" + id.toString() + "/",
        data: {"fcm_token": token},
      );

      return new CustomResponse.success();
    } catch (e) {
      return new CustomResponse.error();
    }
  }

  Future<String> getCountryFromIP() async {
    try {
      Response response = await dio.get(Constants.ipInfoUrl);

      return response.data["country_code"];
    } catch (e) {
      return null;
    }
  }

  Future<String> uploadFile(File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "my_file": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      Response response = await dio.post(
        "/upload/",
        data: formData,
        options: RequestOptions(
          connectTimeout: Constants.uploadRequestTimeout,
          receiveTimeout: Constants.uploadRequestTimeout,
          sendTimeout: Constants.uploadRequestTimeout,
        ),
      );

      return response.data["data"];
    } catch (e) {
      return null;
    }
  }

  Future<List<Feed>> getAllUserFeed(int userId) async {
    try {
      Response response =
          await dio.get("/user/" + userId.toString() + "/feed/all/");

      List<Feed> _list = [];
      for (var item in response.data["feeds"]) {
        _list.add(Feed.fromJSON(item));
      }

      return _list;
    } catch (e) {
      // print(e);
      return null;
    }
  }

  Future<List<Feed>> getPostsByUserId(int userId) async {
    try {
      Response response =
          await dio.get("/user/" + userId.toString() + "/feed/post/");

      List<Feed> _list = [];
      for (var item in response.data["feeds"]) {
        _list.add(Feed.fromJSON(item));
      }

      return _list;
    } catch (e) {
      // print(e);
      return null;
    }
  }

  Future<List<Feed>> getAllUserComments(int userId) async {
    try {
      Response response =
          await dio.get("/user/" + userId.toString() + "/feed/comment/");

      List<Feed> _list = [];
      for (var item in response.data["feeds"]) {
        _list.add(Feed.fromJSON(item));
      }

      return _list;
    } catch (e) {
      // print(e);
      return null;
    }
  }

  Future<List<Feed>> getAllUserInteractions(int userId) async {
    try {
      Response response =
          await dio.get("/user/" + userId.toString() + "/feed/interaction/");

      List<Feed> _list = [];
      for (var item in response.data["feeds"]) {
        _list.add(Feed.fromJSON(item));
      }

      return _list;
    } catch (e) {
      // print(e);
      return null;
    }
  }
}
