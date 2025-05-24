import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/core/widgets/custom_button.dart';
import 'package:offgrid_nation_app/core/widgets/custom_modal.dart';

class ResetPasswordSuccessModal {
  static void show(BuildContext context) {
    CustomModal.show(
      context: context,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(height: 20),
          Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
          SizedBox(height: 20),
          Text(
            'Reset Password Successful!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'You will be directed to the login screen.',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: CustomButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/auth/login');
            },
            text: 'OK',
            backgroundColor: AppColors.primary,
            textColor: Colors.white,
            height: 40,
            width: 80,
            borderRadius: 20,
            loading: false,
          ),
        ),
      ],
    );
  }
}
