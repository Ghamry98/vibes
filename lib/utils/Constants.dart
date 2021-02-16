class Constants {
  // Urls
  static const String baseUrl = "https://api.vibes.com";
  static const String frontUrl = "https://vibes.com";
  static const String contactUsUrl = frontUrl + "/contact";
  static const String ipInfoUrl = "https://ipapi.co/json/";

  // Shared Prefs Keys
  static const String languageKey = "LANGUAGE";
  static const String themeKey = "THEME";
  static const String countryKey = "COUNTRY";
  static const String tokenKey = "TOKEN";

  static const String showHomePageTooltipKey = "SHOW_HOME_PAGE_TOOLTIP";

  // Timeouts
  static const int requestTimeout = 10 * 1000; // 10 seconds
  static const int uploadRequestTimeout = 5 * 60 * 1000; // 5 mins

  static const int shortTimeout = 3 * 1000; // 3 seconds
  static const int mediumTimeout = 4 * 1000; // 4 seconds
  static const int longTimeout = 5 * 1000; // 5 seconds
  static const int typeAheadTimeout = 700; // 700 milliseconds

  // API Keys
  static const String gcpApiKey = "GOOGLE_MAPS_API_KEY";

  static const String twitterConsumerApiKey = "TWITTER_CONSUMER_API_KEY";
  static const String twitterSecretApiKey = "TWITTER_SECRET_API_KEY";
  static const String twitterRedirectUri = "example://";
}
