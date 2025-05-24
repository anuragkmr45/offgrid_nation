import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A reusable, platform-aware modal that can display
/// content and actions for both iOS and Android.
class CustomModal {
  /// Shows the modal dialog.
  ///
  /// [title] is an optional string for the dialog's title.
  /// [content] is the main body of the dialog.
  /// [actions] is a list of buttons or widgets to display at the bottom.
  static Future<void> show({
    required BuildContext context,
    String? title,
    required Widget content,
    List<Widget> actions = const [],
  }) {
    if (Platform.isIOS) {
      // iOS-style dialog
      return showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: title != null ? Text(title) : null,
            content: content,
            actions: actions,
          );
        },
      );
    } else {
      // Android/Material-style dialog
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: title != null ? Text(title) : null,
            content: content,
            actions: actions,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      );
    }
  }
}
