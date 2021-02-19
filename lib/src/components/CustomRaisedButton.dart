import 'package:flutter/material.dart';
import 'package:vibes/config/ThemeColors.dart';
import 'package:vibes/src/components/CrossCircularProgressIndicator.dart';
import 'package:vibes/src/modifiedPackages/ProgressButton/ProgressButton.dart';

/// This widget is responsible for creating a customized RaisedButton with built-in native loading indicator.
class CustomRaisedButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final bool isLoading;
  final double width;
  final double height;
  final double borderRadius;
  final Color color;

  /// Returns a RaisedButton with built-in native loading indicator.
  CustomRaisedButton({
    @required this.title,
    @required this.onPressed,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 52.0,
    this.borderRadius = 100.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final _state = this.isLoading ? ButtonState.loading : ButtonState.idle;

    return ProgressButton(
      stateWidgets: {
        ButtonState.idle: Text(
          this.title,
          style: theme.textTheme.button,
          textAlign: TextAlign.center,
        ),
        ButtonState.loading: Text(""),
        ButtonState.fail: Icon(Icons.error, color: Colors.white),
        ButtonState.success: Icon(Icons.check, color: Colors.white),
      },
      stateColors: {
        ButtonState.idle:
            this.color != null ? this.color : theme.primaryColorLight,
        ButtonState.loading:
            this.color != null ? this.color : theme.primaryColorLight,
        ButtonState.fail: ThemeColors.errorColor(1),
        ButtonState.success: ThemeColors.successColor(1),
      },
      radius: this.borderRadius,
      height: this.height,
      maxWidth: this.width,
      progressIndicator: CrossCircularProgressIndicator(),
      progressIndicatorAligment: MainAxisAlignment.center,
      onPressed: _state == ButtonState.loading || this.onPressed == null
          ? null
          : () => _onPressed(context),
      state: _state,
    );
  }

  void _onPressed(BuildContext context) {
    // Close keyboard
    FocusScope.of(context).requestFocus(new FocusNode());

    // Do the main function
    this.onPressed();
  }
}
