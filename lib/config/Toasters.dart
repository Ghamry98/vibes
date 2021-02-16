import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:vibes/config/AppLocalizations.dart';
import 'package:vibes/config/ThemeColors.dart';
import 'package:vibes/utils/Constants.dart';

class Toasters {
  // Main toaster attributes
  static const double _defaultRadius = 8;
  static const int _defaultTimeout = Constants.shortTimeout;
  static const ToastPosition _defaultPosition = ToastPosition.bottom;
  static final Miui10AnimBuilder _defaultAnimationBuilder = Miui10AnimBuilder();
  static const EdgeInsets _defaultTextPadding = const EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 8,
  );

  /// Displays a basic toaster and returns a ToastFuture object.
  static ToastFuture basic(
    BuildContext context,
    String message, {
    int timeout = _defaultTimeout,
    ToastPosition position = _defaultPosition,
  }) {
    final theme = Theme.of(context);

    return showToast(
      message,
      position: position,
      radius: _defaultRadius,
      backgroundColor: ThemeColors.basicColor(1),
      textStyle: theme.textTheme.bodyText2.merge(
        TextStyle(color: Colors.white),
      ),
      animationBuilder: _defaultAnimationBuilder,
      textPadding: _defaultTextPadding,
      duration: Duration(milliseconds: timeout),
    );
  }

  /// Displays a success toaster and returns a ToastFuture object.
  static ToastFuture success(
    BuildContext context,
    String message, {
    int timeout = _defaultTimeout,
    ToastPosition position = _defaultPosition,
  }) {
    final theme = Theme.of(context);

    return showToast(
      message,
      position: position,
      radius: _defaultRadius,
      backgroundColor: ThemeColors.successColor(1),
      textStyle: theme.textTheme.bodyText2.merge(
        TextStyle(color: Colors.white),
      ),
      animationBuilder: _defaultAnimationBuilder,
      textPadding: _defaultTextPadding,
      duration: Duration(milliseconds: timeout),
    );
  }

  /// Displays a warning toaster and returns a ToastFuture object.
  static ToastFuture warning(
    BuildContext context,
    String message, {
    int timeout = _defaultTimeout,
    ToastPosition position = _defaultPosition,
  }) {
    final theme = Theme.of(context);

    return showToast(
      message,
      position: position,
      radius: _defaultRadius,
      backgroundColor: ThemeColors.warningColor(1),
      textStyle: theme.textTheme.bodyText2.merge(
        TextStyle(color: Colors.white),
      ),
      animationBuilder: _defaultAnimationBuilder,
      textPadding: _defaultTextPadding,
      duration: Duration(milliseconds: timeout),
    );
  }

  /// Displays an error toaster and returns a ToastFuture object.
  static ToastFuture error(
    BuildContext context, {
    String message,
    int timeout = _defaultTimeout,
    ToastPosition position = _defaultPosition,
  }) {
    final theme = Theme.of(context);

    message = message ?? AppLocalizations.of(context).translate("error_basic");

    return showToast(
      message,
      position: position,
      radius: _defaultRadius,
      backgroundColor: ThemeColors.errorColor(1),
      textStyle: theme.textTheme.bodyText2.merge(
        TextStyle(color: Colors.white),
      ),
      animationBuilder: _defaultAnimationBuilder,
      textPadding: _defaultTextPadding,
      duration: Duration(milliseconds: timeout),
    );
  }
}
