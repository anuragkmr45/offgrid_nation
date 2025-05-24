import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';

class MarketplaceHeader extends StatelessWidget {
  const MarketplaceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Today's picks",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
        Row(
          children: [
            Icon(
              Platform.isIOS ? CupertinoIcons.location : Icons.location_on,
              size: 16,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: 4),
            const Text(
              'Pasadena, California',
              style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
            ),
          ],
        ),
      ],
    );
  }
}
