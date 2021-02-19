import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Responsible for creating a native circular progress indicator.
class CrossCircularProgressIndicator extends StatelessWidget {
  final Color color;

  /// Returns a native circular progress indicator.
  const CrossCircularProgressIndicator({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Platform.isIOS
        ? CupertinoActivityIndicator()
        : CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
              this.color != null ? this.color : theme.primaryColorLight,
            ),
          );
  }
}
