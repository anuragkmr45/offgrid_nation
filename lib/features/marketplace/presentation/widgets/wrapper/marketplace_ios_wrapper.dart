import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';

class MarketplaceIOSWrapper extends StatelessWidget {
  final Widget child;

  const MarketplaceIOSWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.primary,
        middle: const Text(
          'Marketplace',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: const Icon(CupertinoIcons.back, color: Colors.white),
        trailing: const CircleAvatar(
          backgroundColor: Colors.white,
          radius: 14,
          child: Icon(
            CupertinoIcons.person,
            size: 16,
            color: AppColors.primary,
          ),
        ),
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}
