import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/core/widgets/custom_input_field.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/core/utils/form_validation/login_form_validation.dart';

class ResetPasswordFormStep extends StatelessWidget {
  final int currentStep;
  final TextEditingController phoneController;
  final TextEditingController otpController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback togglePasswordVisibility;
  final VoidCallback toggleConfirmVisibility;

  const ResetPasswordFormStep({
    super.key,
    required this.currentStep,
    required this.phoneController,
    required this.otpController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.togglePasswordVisibility,
    required this.toggleConfirmVisibility,
  });

  @override
  Widget build(BuildContext context) {
    switch (currentStep) {
      case 0:
        return CustomInputField(
          controller: phoneController,
          placeholder: 'Enter Your Phone No.',
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone no';
            }
            if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
              return 'Enter a valid phone no';
            }
            return null;
          },
        );
      case 1:
        return CustomInputField(
          controller: otpController,
          placeholder: 'Enter OTP',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the OTP';
            }
            if (value.length < 6) {
              return 'OTP should be at least 4 digits';
            }
            return null;
          },
        );
      case 2:
        return Column(
          children: [
            Stack(
              alignment: Alignment.centerRight,
              children: [
                CustomInputField(
                  controller: newPasswordController,
                  placeholder: 'New Password',
                  obscureText: obscurePassword,
                  validator: LoginFormValidation.validatePassword,
                ),
                IconButton(
                  onPressed: togglePasswordVisibility,
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                CustomInputField(
                  controller: confirmPasswordController,
                  placeholder: 'Confirm New Password',
                  obscureText: obscureConfirmPassword,
                  validator: (value) {
                    if (value != newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                IconButton(
                  onPressed: toggleConfirmVisibility,
                  icon: Icon(
                    obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
