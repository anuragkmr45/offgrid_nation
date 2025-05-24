import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/core/widgets/custom_button.dart';
import 'package:offgrid_nation_app/features/auth/presentation/bloc/events/reset_password_event.dart';
import 'package:offgrid_nation_app/features/auth/presentation/bloc/reset_password_bloc.dart';
import 'package:offgrid_nation_app/features/auth/presentation/bloc/states/reset_password_state.dart';
import '../widgets/reset_pass_widgets/reset_password_form_step.dart';
import '../widgets/reset_pass_widgets/reset_password_subtitle.dart';
import '../widgets/reset_pass_widgets/reset_password_success_modal.dart';
import '../widgets/reset_pass_widgets/reset_password_title_icon.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  int _currentStep = 0;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Controllers
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  bool _isLoading(ResetPasswordStatus status) {
    return status == ResetPasswordStatus.loading;
  }

  void _onContinue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final String countryCode = '+91';

    final bloc = context.read<ResetPasswordBloc>();
    final phone = '$countryCode${_phoneController.text.trim()}';
    final otp = _otpController.text.trim();
    final password = _newPasswordController.text.trim();
    final confirmPassword = _confirmNewPasswordController.text.trim();

    if (_currentStep == 0) {
      bloc.add(ForgotPasswordRequested(phone));
    } else if (_currentStep == 1) {
      bloc.add(VerifyPhoneResetPassword(phone, otp));
    } else if (_currentStep == 2) {
      if (password != confirmPassword) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
        return;
      }
      bloc.add(SubmitResetPassword(phone: phone, newPassword: password));
    }
  }

  /// Returns the step subtitle text.
  String _getStepSubtitle() {
    switch (_currentStep) {
      case 0:
        return 'Please enter your phone no and we will send an OTP code in the next step to reset your password.';
      case 1:
        return 'Please enter the OTP we just sent to your phone sms.';
      case 2:
        return 'Please create a new password and confirm it below.';
      default:
        return '';
    }
  }

  /// Returns the icon for the current step.
  IconData _getStepIcon() {
    switch (_currentStep) {
      case 0:
        return Icons.key; // Reset Password
      case 1:
        return Icons.email; // OTP Verification
      case 2:
        return Icons.lock; // Create New Password
      default:
        return Icons.key;
    }
  }

  /// Toggle the visibility for the new password field.
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  /// Toggle the visibility for the confirm password field.
  void _toggleConfirmVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  /// Returns the step title text.
  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Reset Your Password';
      case 1:
        return 'OTP Verification';
      case 2:
        return 'Create New Password';
      default:
        return 'Reset Your Password';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
      listener: (context, state) {
        if (state.status == ResetPasswordStatus.otpSent && _currentStep == 0) {
          setState(() => _currentStep = 1);
        }
        if (state.status == ResetPasswordStatus.otpVerified &&
            _currentStep == 1) {
          setState(() => _currentStep = 2);
        }
        if (state.status == ResetPasswordStatus.success) {
          ResetPasswordSuccessModal.show(context);
        }
        if (state.status == ResetPasswordStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Something went wrong'),
            ),
          );
        }
      },
      builder: (context, state) {
        if (Platform.isIOS) {
          return CupertinoPageScaffold(
            backgroundColor: AppColors.primary,
            navigationBar: CupertinoNavigationBar(
              middle: Image.asset(
                'lib/assets/images/image.png',
                width: 100,
                height: 100,
              ).animate().fadeIn(duration: 800.ms),
              backgroundColor: AppColors.primary,
            ),
            child: SafeArea(child: _buildBody()),
          );
        } else {
          return Scaffold(
            backgroundColor: AppColors.primary,
            appBar: AppBar(
              title: Image.asset(
                'lib/assets/images/image.png',
                width: 100,
                height: 100,
              ).animate().fadeIn(duration: 800.ms),
              backgroundColor: AppColors.primary,
            ),
            body: SafeArea(child: _buildBody()),
          );
        }
      },
    );
  }

  /// Builds the body content by replacing the inline UI with new reusable widgets.
  Widget _buildBody() {
    return Column(
      children: [
        // Form with title, subtitle, and step content.
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Replace the title + icon row with ResetPasswordTitleIcon.
                    ResetPasswordTitleIcon(
                      title: _getStepTitle(),
                      icon: _getStepIcon(),
                    ),
                    const SizedBox(height: 8),
                    // Replace inline subtitle text with ResetPasswordSubtitle.
                    ResetPasswordSubtitle(subtitle: _getStepSubtitle()),
                    const SizedBox(height: 20),
                    // AnimatedSwitcher that swaps out the step content using ResetPasswordFormStep.
                    AnimatedSwitcher(
                      duration: 400.ms,
                      transitionBuilder:
                          (child, animation) =>
                              FadeTransition(opacity: animation, child: child),
                      child: ResetPasswordFormStep(
                        key: ValueKey(_currentStep),
                        currentStep: _currentStep,
                        phoneController: _phoneController,
                        otpController: _otpController,
                        newPasswordController: _newPasswordController,
                        confirmPasswordController:
                            _confirmNewPasswordController,
                        obscurePassword: _obscurePassword,
                        obscureConfirmPassword: _obscureConfirmPassword,
                        togglePasswordVisibility: _togglePasswordVisibility,
                        toggleConfirmVisibility: _toggleConfirmVisibility,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomButton(
            onPressed: () {
              if (!_isLoading(context.read<ResetPasswordBloc>().state.status)) {
                _onContinue();
              }
            },
            text: 'Continue',
            backgroundColor: Colors.white,
            textColor: AppColors.primary,
            height: 45,
            width: double.infinity,
            borderRadius: 30,
            loading: _isLoading(context.read<ResetPasswordBloc>().state.status),
          ),
        ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
      ],
    );
  }
}
