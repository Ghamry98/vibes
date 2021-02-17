import 'package:flutter/material.dart';

enum UserTheme { light, dark }

class AppSettings {
  // Attributes
  Locale language;
  UserTheme theme;

  // Constructors
  AppSettings(this.language, this.theme);

  AppSettings.primary({
    this.language = const Locale("en"),
    this.theme = UserTheme.light,
  });

  // Mapping
  AppSettings.fromJSON(Map<String, dynamic> data) {
    this.language =
        data["language"] != null ? getLanguage(data["language"]) : Locale("en");
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "language": language.languageCode,
    };
    return map;
  }

  static UserTheme getTheme(String theme) {
    try {
      switch (theme.toLowerCase()) {
        case "light":
          return UserTheme.light;
        case "dark":
          return UserTheme.dark;
        default:
          return UserTheme.light;
      }
    } catch (e) {
      return UserTheme.light;
    }
  }

  static Locale getLanguage(String languageCode) {
    try {
      if (languageCode != null) {
        return Locale(languageCode);
      } else {
        return Locale("en");
      }
    } catch (e) {
      return Locale("en");
    }
  }
}
