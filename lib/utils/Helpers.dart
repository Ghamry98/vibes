import 'dart:convert';

import 'package:age/age.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vibes/config/AppLocalizations.dart';

class Helpers {
  /// Converts JWT String Token into a Map
  static Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      // print('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      // print('invalid payload');
    }

    return payloadMap;
  }

  /// Internal method used by parseJwt() method, to decode base64 string
  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
      // print('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  /// Returns a formatted string with the duration since the "creation date till now".
  /// The flag isLongFormat is responsible for providing a longhand format.
  ///
  /// Eg:
  /// isLongFormat = true results "1 year ago",
  /// while isLongFormat = false results "1y ago".
  static String getElapsedTime(
      DateTime creationDate, BuildContext context, bool isLongFormat) {
    try {
      final localizations = AppLocalizations.of(context);

      DateTime d1 = DateTime.now().toUtc();
      DateTime d2 = creationDate.toLocal().toUtc();

      int years = d1.year - d2.year;
      int months = d1.month - d2.month;

      Duration res = d1.difference(d2);

      if (years > 0) {
        return years == 1
            ? localizations
                .translate(isLongFormat
                    ? "year_ago_long_format"
                    : "year_ago_short_format")
                .replaceFirst("%1d", years.toString())
            : localizations
                .translate(isLongFormat
                    ? "years_ago_long_format"
                    : "years_ago_short_format")
                .replaceFirst("%1d", years.toString());
      } else if (months > 0) {
        return months == 1
            ? localizations
                .translate(isLongFormat
                    ? "month_ago_long_format"
                    : "month_ago_short_format")
                .replaceFirst("%1d", months.toString())
            : localizations
                .translate(isLongFormat
                    ? "months_ago_long_format"
                    : "months_ago_short_format")
                .replaceFirst("%1d", months.toString());
      } else if (res.inDays > 0) {
        return res.inDays == 1
            ? localizations
                .translate(isLongFormat
                    ? "day_ago_long_format"
                    : "day_ago_short_format")
                .replaceFirst("%1d", res.inDays.toString())
            : localizations
                .translate(isLongFormat
                    ? "days_ago_long_format"
                    : "days_ago_short_format")
                .replaceFirst("%1d", res.inDays.toString());
      } else if (res.inHours > 0) {
        return res.inHours == 1
            ? localizations
                .translate(isLongFormat
                    ? "hour_ago_long_format"
                    : "hour_ago_short_format")
                .replaceFirst("%1d", res.inHours.toString())
            : localizations
                .translate(isLongFormat
                    ? "hours_ago_long_format"
                    : "hours_ago_short_format")
                .replaceFirst("%1d", res.inHours.toString());
      } else if (res.inMinutes > 0) {
        return res.inMinutes == 1
            ? localizations
                .translate(isLongFormat
                    ? "min_ago_long_format"
                    : "min_ago_short_format")
                .replaceFirst("%1d", res.inMinutes.toString())
            : localizations
                .translate(isLongFormat
                    ? "mins_ago_long_format"
                    : "mins_ago_short_format")
                .replaceFirst("%1d", res.inMinutes.toString());
      } else if (res.inSeconds > 0) {
        return res.inSeconds == 1
            ? localizations
                .translate(isLongFormat
                    ? "sec_ago_long_format"
                    : "sec_ago_short_format")
                .replaceFirst("%1d", res.inSeconds.toString())
            : localizations
                .translate(isLongFormat
                    ? "secs_ago_long_format"
                    : "secs_ago_short_format")
                .replaceFirst("%1d", res.inSeconds.toString());
      }
      return localizations.translate("now");
    } catch (e) {
      return "";
    }
  }

  /// Returns a formatted string with the duration since the "creation date till now".
  ///
  /// Eg: "2y 3m 1d".
  static String getformattedCreationDate(DateTime creationDate) {
    try {
      DateTime d1 = DateTime.now().toUtc();
      DateTime d2 = creationDate.toLocal().toUtc();

      AgeDuration age =
          Age.dateDifference(fromDate: d2, toDate: d1, includeToDate: false);

      String result = "";

      if (age.years > 0) {
        result += age.years.toString() + "y";
      }
      if (age.months > 0) {
        result += " " + age.months.toString() + "m";
      }
      if (age.days > 0) {
        result += " " + age.days.toString() + "d";
      }
      if (age.years <= 0 && age.months <= 0 && age.days <= 0) {
        result = "1d";
      }

      return result;
    } catch (e) {
      return "";
    }
  }

  /// Gets the reverse-geocoding of a certain position (coordinates).
  ///
  /// Format: subAdministrativeArea, country.
  /// if subAdministrativeArea is not found, it is replaced with the administrativeArea,
  /// if none of them are found, only country is returned.
  static Future<String> getAddressFromLocation(Position location) async {
    try {
      List<Placemark> addresses =
          await Geolocator().placemarkFromPosition(location);

      if (addresses != null && addresses.isNotEmpty) {
        if (addresses[0].subAdministrativeArea.isNotEmpty &&
            addresses[0].country.isNotEmpty) {
          return addresses[0].subAdministrativeArea +
              ", " +
              addresses[0].country;
        } else if (addresses[0].administrativeArea.isNotEmpty &&
            addresses[0].country.isNotEmpty) {
          return addresses[0].subAdministrativeArea +
              ", " +
              addresses[0].country;
        } else if (addresses[0].subAdministrativeArea.isNotEmpty) {
          return addresses[0].subAdministrativeArea;
        } else if (addresses[0].administrativeArea.isNotEmpty) {
          return addresses[0].administrativeArea;
        } else if (addresses[0].country.isNotEmpty) {
          return addresses[0].country;
        } else {
          return "";
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Gets the iso-2 (Alpha-2) code of a certain country.
  /// in case of US, the name of the state is returned.
  static Future<String> getCountryCode(Position location) async {
    try {
      List<Placemark> addresses =
          await Geolocator().placemarkFromPosition(location);

      if (addresses[0].isoCountryCode == "US") {
        return addresses[0].administrativeArea.toLowerCase();
      } else {
        return addresses[0].isoCountryCode;
      }
    } catch (e) {
      return null;
    }
  }
}
