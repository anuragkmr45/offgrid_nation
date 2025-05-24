import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/core/widgets/custom_input_field.dart';
import 'package:offgrid_nation_app/core/utils/form_validation/signup_form_validation.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SignupCase2 extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;

  const SignupCase2({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
  });

  Widget _buildPasswordField() {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        CustomInputField(
          controller: passwordController,
          placeholder: 'Create a Password',
          obscureText: obscurePassword,
          validator: SignupFormValidation.validatePassword,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: onTogglePassword,
            child: Icon(
              obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        CustomInputField(
          controller: confirmPasswordController,
          placeholder: 'Confirm Password',
          obscureText: obscureConfirmPassword,
          validator:
              (value) => SignupFormValidation.validateConfirmPassword(
                value,
                passwordController.text,
              ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: onToggleConfirmPassword,
            child: Icon(
              obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPasswordField().animate().fadeIn(duration: 800.ms),
        const SizedBox(height: 16),
        _buildConfirmPasswordField().animate().fadeIn(duration: 800.ms),
      ],
    );
  }
}
