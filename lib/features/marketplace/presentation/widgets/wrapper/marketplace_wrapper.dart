import 'dart:io';
import 'package:flutter/material.dart';
import 'marketplace_android_wrapper.dart';
import 'marketplace_ios_wrapper.dart';

class MarketplaceWrapper extends StatelessWidget {
  final Widget child;

  const MarketplaceWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? MarketplaceIOSWrapper(child: child)
        : MarketplaceAndroidWrapper(child: child);
  }
}
