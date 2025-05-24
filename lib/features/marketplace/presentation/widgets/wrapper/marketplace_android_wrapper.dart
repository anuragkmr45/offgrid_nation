import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';

class MarketplaceAndroidWrapper extends StatelessWidget {
  final Widget child;

  const MarketplaceAndroidWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Marketplace',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: Icon(Icons.person, color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: child,
    );
  }
}
