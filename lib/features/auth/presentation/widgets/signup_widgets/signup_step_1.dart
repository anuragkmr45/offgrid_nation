import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/core/widgets/custom_input_field.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:offgrid_nation_app/features/auth/presentation/bloc/signup_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupCase1 extends StatelessWidget {
  final TextEditingController otpController;
  final Future<void> Function() verifyPhoneNumber;

  const SignupCase1({
    super.key,
    required this.otpController,
    required this.verifyPhoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInputField(
          controller: otpController,
          placeholder: 'Enter OTP',
          keyboardType: TextInputType.number,
        ).animate().fadeIn(duration: 800.ms),
        if (context.watch<SignupBloc>().state.otpVerification ==
            OTPVerificationStatus.invalid)
          const Text('Invalid OTP', style: TextStyle(color: Colors.red)),
        const SizedBox(height: 8),
        Text(
          "Haven't received it? Resend",
          style: const TextStyle(color: Colors.white),
        ).animate().fadeIn(duration: 800.ms),
        TextButton(
          onPressed: verifyPhoneNumber,
          child: const Text('Resend OTP'),
        ),
      ],
    );
  }
}
