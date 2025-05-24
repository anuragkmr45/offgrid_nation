import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/core/widgets/custom_button.dart';

class AppleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool loading;

  const AppleSignInButton({
    super.key,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: onPressed,
      text: 'Continue with Apple',
      backgroundColor: AppColors.textPrimary,
      textColor: AppColors.background,
      height: 48,
      width: double.infinity,
      borderRadius: 8,
      loading: loading,
      icon: Image.asset(
        'lib/assets/images/apple-icon.png',
        height: 24,
        width: 24,
      ),
    );
  }
}
