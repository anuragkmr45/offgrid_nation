import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'app_exception.dart';

class ErrorHandler {
  /// Returns user-friendly message only
  static String handle(dynamic error) {
    if (error is AppException) {
      return error.message ?? "An error occurred. Please try again.";
    } else if (error is SocketException) {
      return "No internet connection. Please check your network.";
    } else if (error is TimeoutException) {
      return "Request timed out. Please try again.";
    } else if (error is HttpException) {
      return "Server error occurred. Please try later.";
    } else if (error.toString().contains("401")) {
      return "Unauthorized access. Please login again.";
    }

    return "Something went wrong. Please try again.";
  }

  /// Shows the message in a platform-adaptive dialog
  static void handleWithUI(BuildContext context, dynamic error) {
    final message = handle(error);
    _showDialog(context, message);
  }

  static void _showDialog(BuildContext context, String message) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }
}
