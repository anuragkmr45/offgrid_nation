import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/core/widgets/custom_loader.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:offgrid_nation_app/core/widgets/custom_modal.dart';
import 'package:offgrid_nation_app/features/auth/presentation/bloc/signup_bloc.dart';
import './signup_step_0.dart';
import './signup_step_1.dart';
import './signup_step_2.dart';
import './signup_button.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  // int? _resendToken;
  final String _countryCode = '+91';

  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignupPressed() {
    final bloc = context.read<SignupBloc>();

    if (_formKey.currentState!.validate()) {
      final phone = '$_countryCode${_phoneController.text.trim()}';
      final password = _passwordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();

      if (password != confirmPassword) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
        return;
      }

      bloc.add(SignupSubmitted(phone: phone, password: password));
    }
  }

  Future<void> _verifyPhoneNumber() async {
    final bloc = context.read<SignupBloc>();
    final phone = '$_countryCode${_phoneController.text.trim()}';
    final otp = _otpController.text.trim();

    if (otp.isEmpty) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a valid OTP')));
      return;
    }

    bloc.add(VerifyOTP(phone, otp));

    final verifiedState = await bloc.stream.firstWhere(
      (state) => state.otpVerification != OTPVerificationStatus.verifying,
    );

    if (verifiedState.otpVerification == OTPVerificationStatus.verified) {
      setState(() {
        _isLoading = false;
        _currentStep = 2;
      });
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid OTP')));
    }
  }

  void _onNextPressed() async {
    setState(() => _isLoading = true);

    final bloc = context.read<SignupBloc>();

    if (_currentStep == 0) {
      final username = _usernameController.text.trim();
      final phone = '$_countryCode${_phoneController.text.trim()}';

      if (!_formKey.currentState!.validate()) {
        setState(() => _isLoading = false);
        return;
      }

      bloc.add(CheckUsernameAvailability(username));

      final usernameState = await bloc.stream.firstWhere(
        (state) =>
            state.usernameAvailability != UsernameAvailabilityStatus.checking,
      );

      if (usernameState.usernameAvailability !=
          UsernameAvailabilityStatus.available) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Username not available')));
        return;
      }

      bloc.add(SendOTPRequested(username, phone));
      return;
    }

    if (_currentStep == 1) {
      await _verifyPhoneNumber();
      return;
    }

    _onSignupPressed();
  }

  Widget _buildContent() {
    switch (_currentStep) {
      case 0:
        return SignupCase0(
          usernameController: _usernameController,
          phoneController: _phoneController,
          countryCode: _countryCode,
        );
      case 1:
        return SignupCase1(
          otpController: _otpController,
          verifyPhoneNumber: _verifyPhoneNumber,
        );
      case 2:
        return SignupCase2(
          passwordController: _passwordController,
          confirmPasswordController: _confirmPasswordController,
          obscurePassword: _obscurePassword,
          obscureConfirmPassword: _obscureConfirmPassword,
          onTogglePassword: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
          onToggleConfirmPassword: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        );
      default:
        return SignupCase0(
          usernameController: _usernameController,
          phoneController: _phoneController,
          countryCode: _countryCode,
        );
    }
  }

  Widget _buildBody() {
    // ← NEW: if loading, show only spinner
    if (_isLoading) {
      return const Center(child: CustomLoader());
    }

    // otherwise original layout
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Form(key: _formKey, child: _buildContent()),
          ),
        ),
        SignupBottomButtons(
          currentStep: _currentStep,
          onNextPressed: _onNextPressed,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state.status == SignupStatus.otpSent) {
          setState(() {
            _isLoading = false;
            _currentStep = 1;
          });
        }
        if (state.status == SignupStatus.failure) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Signup failed')),
            );
        }
        if (state.status == SignupStatus.success) {
          setState(() {
            _isLoading = false;
          });
          CustomModal.show(
            context: context,
            title: 'Success',
            content: const Text('Account created successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/auth/login');
                },
                child: const Text('Continue'),
              ),
            ],
          );
        }
      },
      builder: (context, state) {
        return Platform.isIOS
            ? CupertinoPageScaffold(
              backgroundColor: AppColors.primary,
              child: SafeArea(child: _buildBody()),
            )
            : Scaffold(
              backgroundColor: AppColors.primary,
              body: SafeArea(child: _buildBody()),
            );
      },
    );
  }
}
