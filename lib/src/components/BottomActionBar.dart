import 'package:flutter/material.dart';
import 'package:vibes/src/components/CustomRaisedButton.dart';
import 'package:vibes/src/components/CustomTextButton.dart';

/// Responsible for creating a bottom bar with optional button and action text.
/// Action text support being a TextButton.
class BottomActionBar extends StatelessWidget {
  final String buttonTitle;
  final Function onButtonPressed;
  final String footerMainTitle;
  final String footerActionTitle;
  final Function onActionPressed;
  final Color buttonColor;
  final TextStyle footerStyle;
  final bool isLoading;
  final EdgeInsets margin;

  /// Returns a bottom bar with optional button and action text.
  BottomActionBar({
    this.buttonTitle,
    this.footerMainTitle,
    this.footerActionTitle,
    this.onButtonPressed,
    this.onActionPressed,
    this.buttonColor,
    this.footerStyle,
    this.isLoading = false,
    this.margin = const EdgeInsets.only(bottom: 15),
  });

  bool get buttonVisible => this.buttonTitle != null && this.buttonTitle != "";
  bool get footerVisible =>
      this.footerMainTitle != null && this.footerMainTitle != "";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: this.margin,
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: this.buttonVisible ? 15 : 0),
          this.buttonVisible
              ? CustomRaisedButton(
                  isLoading: this.isLoading,
                  onPressed: this.onButtonPressed,
                  title: this.buttonTitle,
                  color: this.buttonColor,
                )
              : Container(),
          SizedBox(height: this.footerVisible ? 8 : 0),
          this.footerVisible
              ? SizedBox(
                  child: this.footerActionTitle == null
                      ? CustomTextButton(
                          title: this.footerMainTitle,
                          onPressed: this.onActionPressed,
                          isLoading: this.isLoading,
                          titleStyle: this.footerStyle,
                        )
                      : CustomTextButton.rich(
                          children: <TextSpan>[
                            TextSpan(
                              text: this.footerMainTitle,
                              style: theme.textTheme.bodyText2.merge(
                                TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            TextSpan(
                              text: " ${this.footerActionTitle}",
                              style: theme.textTheme.bodyText2.merge(
                                TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: theme.primaryColorLight,
                                ),
                              ),
                            ),
                          ],
                          onPressed: this.onActionPressed,
                          isLoading: this.isLoading,
                        ),
                )
              : Container(),
        ],
      ),
    );
  }
}
