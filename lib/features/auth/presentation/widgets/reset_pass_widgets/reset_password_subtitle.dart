import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';

class ResetPasswordSubtitle extends StatelessWidget {
  final String subtitle;

  const ResetPasswordSubtitle({super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Text(
      subtitle,
      style: TextStyle(fontSize: 14, color: AppColors.background),
      textAlign: TextAlign.center,
    );
  }
}
