import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double height;
  final double width;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final Image? icon;
  final bool loading;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.height = 45,
    this.width = 350,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 40,
    this.icon,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    Widget childContent;
    if (loading) {
      childContent =
          Platform.isIOS
              ? CupertinoActivityIndicator()
              : SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? Colors.white,
                  ),
                ),
              );
    } else {
      childContent = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 8)],
          Text(
            text,
            style: TextStyle(color: textColor ?? Colors.white, fontSize: 14),
          ),
        ],
      );
    }

    if (Platform.isIOS) {
      return SizedBox(
        height: height,
        width: width,
        child: CupertinoButton(
          onPressed: loading ? null : onPressed,
          color: backgroundColor ?? Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(borderRadius),
          child: childContent,
        ),
      );
    } else {
      return SizedBox(
        height: height,
        width: width,
        child: ElevatedButton(
          onPressed: loading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: childContent,
        ),
      );
    }
  }
}
