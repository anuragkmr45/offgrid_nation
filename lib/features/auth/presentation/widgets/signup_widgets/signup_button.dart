import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/core/widgets/custom_button.dart';

class SignupBottomButtons extends StatelessWidget {
  final int currentStep;
  final VoidCallback onNextPressed;

  const SignupBottomButtons({
    super.key,
    required this.currentStep,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    final buttonText = (currentStep < 2) ? 'Next' : 'Sign Up';
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            onPressed: onNextPressed,
            text: buttonText,
            height: 45,
            width: double.infinity,
            borderRadius: 30,
            backgroundColor: AppColors.background,
            textColor: AppColors.primary,
            loading: false,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              // Navigator.pushReplacementNamed(context, '/auth/login');
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Already have an account? ",
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                Text(
                  'Sign In',
                  style: TextStyle(
                    color: AppColors.background,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
