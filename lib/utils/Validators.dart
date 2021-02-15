import 'package:flutter/widgets.dart';
import 'package:vibes/config/AppLocalizations.dart';

class Validators {
  // Validation attributes
  static final int _postTitleMaxLength = 280; // 280 characters
  static final int _maxFileSize = 50 * 1024 * 1024; // 50 MB

  // Supported file formats
  static final List<String> _supportedImageExtensions = ["jpg", "jpeg", "png"];
  static final List<String> _supportedVideoExtensions = ["mp4"];

  // Regular Expressions
  static final RegExp multilineUrlRegex = new RegExp(
    r"[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)",
    caseSensitive: false,
    multiLine: true,
  );
  static final RegExp _urlRegex = new RegExp(
    r"^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/\S*)?$",
    caseSensitive: false,
    multiLine: false,
  );
  static final Pattern _emailRegex =
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";

  /// Validates the given email address.
  static String emailValidator(BuildContext context, String value) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    if (value.isEmpty) {
      return localizations.translate("validators_field_is_required");
    }
    if (!RegExp(_emailRegex).hasMatch(value)) {
      return localizations.translate("validators_valid_email");
    }

    return null;
  }

  /// Validates that the username is not empty.
  static String usernameValidator(BuildContext context, String value) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    if (value.isEmpty) {
      return localizations.translate("validators_field_is_required");
    }

    return null;
  }

  /// Validates that the given string is not empty.
  static String emptyFieldValidator(BuildContext context, String value) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    if (value.isEmpty) {
      return localizations.translate("validators_field_is_required");
    }

    return null;
  }

  /// Validates that the two given email addresses match.
  static String resetPasswordEmailValidator(
      BuildContext context, String value1, String value2) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    if (value1.isEmpty) {
      return localizations.translate("validators_field_is_required");
    }
    if (!RegExp(_emailRegex).hasMatch(value1)) {
      return localizations.translate("validators_valid_email");
    }
    if (value1 != value2) {
      return localizations.translate("validators_valid_reset_email");
    }

    return null;
  }

  /// Validates the given password.
  ///
  /// Min password length is 6 characters.
  static String passwordValidator(BuildContext context, String value) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final int minLength = 6;
    if (value.isEmpty) {
      return localizations.translate("validators_field_is_required");
    }
    if (value.length < minLength) {
      return localizations
          .translate("validators_field_atleast_error")
          .replaceFirst("%1d", minLength.toString());
    }
    return null;
  }

  /// Validates that the two given passwords match.
  static String confirmPasswordValidator(
      BuildContext context, String value1, String value2) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    if (value2.isEmpty) {
      return localizations.translate("validators_field_is_required");
    }
    if (value2 != value1) {
      return localizations.translate("validators_confirm_password");
    }
    return null;
  }

  /// Validates the given url.
  static String urlValidator(BuildContext context, String value) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    if (!_urlRegex.hasMatch(value)) {
      return localizations.translate("validators_valid_url");
    }

    return null;
  }

  /// Validates and updates the FormField currentstate.
  static bool updateState(GlobalKey<FormFieldState> key, bool validState) {
    if (key.currentState.validate()) {
      if (validState) return null;
      return true;
    } else {
      if (!validState) return null;
      return false;
    }
  }

  /// Validates the post title max length.
  ///
  /// Maximum is 280 characters.
  static String postTitleValidator(String value) {
    if (value != null &&
        value.isNotEmpty &&
        value.length <= _postTitleMaxLength) {
      return null;
    }

    return "";
  }

  /// Validates the file size.
  ///
  /// Maximum is 50 MB.
  static bool validateFileSize(int fileSize) {
    if (fileSize <= _maxFileSize) {
      return true;
    }
    return false;
  }

  /// Validates the extension of a file.
  ///
  /// Supported formats: mp4, jpg, jpeg, png.
  static bool validateFileExtension(String fileExtension) {
    if (validateImageExtension(fileExtension) ||
        validateVideoExtension(fileExtension)) {
      return true;
    }
    return false;
  }

  /// Validates the extension of an image.
  ///
  /// Supported formats: jpg, jpeg, png.
  static bool validateImageExtension(String fileExtension) {
    if (_supportedImageExtensions.contains(fileExtension)) {
      return true;
    }
    return false;
  }

  /// Validates the extension of a video.
  ///
  /// Supported formats: mp4.
  static bool validateVideoExtension(String fileExtension) {
    if (_supportedVideoExtensions.contains(fileExtension)) {
      return true;
    }
    return false;
  }
}
