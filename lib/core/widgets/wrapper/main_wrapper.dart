import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'android_wrapper.dart';
import 'ios_wrapper.dart';

class MainWrapper extends StatelessWidget {
  final Widget child;
  final int currentTabIndex;
  final ValueChanged<int>? onTabSelected;
  final bool isHomeScreen;

  const MainWrapper({
    super.key,
    required this.child,
    this.currentTabIndex = 0,
    this.onTabSelected,
    this.isHomeScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? IOSWrapper(
          currentTabIndex: currentTabIndex,
          onTabSelected: onTabSelected,
          // isHomeScreen: isHomeScreen,
          child: child,
        )
        : AndroidWrapper(
          currentTabIndex: currentTabIndex,
          onTabSelected: onTabSelected,
          isHomeScreen: isHomeScreen,
          child: child,
        );
  }
}
