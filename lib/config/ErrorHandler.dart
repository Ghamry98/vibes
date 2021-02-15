import 'package:flutter/material.dart';
import 'package:vibes/config/AppLocalizations.dart';

enum ErrorType {
  basic,
  reg_username,
  reg_email,
  unauthorized,
}

class ErrorHandler {
  /// Returns a localized appropriate error message, that suites the given ErrorType.
  static String getErrorMessage(BuildContext context, ErrorType error) {
    final localizations = AppLocalizations.of(context);

    try {
      switch (error) {
        case ErrorType.reg_email:
          return localizations.translate("error_reg_email");
        case ErrorType.reg_username:
          return localizations.translate("error_reg_username");
        default:
          return localizations.translate("error_basic");
      }
    } catch (e) {
      return localizations.translate("error_basic");
    }
  }
}
