import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.textPrimary.withAlpha(102),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child:
            Platform.isIOS
                ? const CupertinoActivityIndicator(
                  color: AppColors.textPrimary,
                  radius: 14,
                )
                : const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3.0,
                ),
      ),
    );
  }
}
