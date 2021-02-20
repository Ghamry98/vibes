import 'package:flutter/material.dart';

/// This widget is responsible for creating Text and Richtext Buttons.
class CustomTextButton extends StatelessWidget {
  final String title;
  final List<TextSpan> children;
  final Function onPressed;
  final bool isLoading;
  final double padding;
  final double borderRadius;
  final TextStyle titleStyle;

  /// Returns a Text Button.
  CustomTextButton({
    @required this.title,
    @required this.onPressed,
    this.isLoading = false,
    this.padding = 5.0,
    this.borderRadius = 20.0,
    this.titleStyle,
  })  : assert(
          title != null,
          'A non-null title must be provided to a CustomTextButton widget.',
        ),
        this.children = null;

  /// Returns a Richtext button.
  CustomTextButton.rich({
    @required this.children,
    @required this.onPressed,
    this.isLoading = false,
    this.padding = 5.0,
    this.borderRadius = 20.0,
  })  : assert(
          children != null,
          'A non-null children must be provided to a CustomTextButton.rich widget.',
        ),
        this.title = null,
        titleStyle = null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: this.isLoading ? null : this.onPressed,
      borderRadius: BorderRadius.circular(this.borderRadius),
      child: Padding(
        padding: EdgeInsets.all(this.padding),
        child: Text.rich(
          TextSpan(
            text: this.title,
            children: children,
            style: this.titleStyle != null
                ? this.titleStyle
                : theme.textTheme.bodyText2.merge(
                    TextStyle(
                      fontWeight: FontWeight.w500,
                      color: theme.primaryColorLight,
                    ),
                  ),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
